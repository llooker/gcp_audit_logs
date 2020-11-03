include: "/views/**/*.view"

view: failed_logins {
  derived_table: {
    sql:
   -- Create a temp table that has all logins by date, service, and email and number/rank them by date and date, granted per user
    WITH rank_logins AS (
      SELECT
        activity.activity_timestamp AS activity_timestamp_date,
        activity.service_name AS service_name,
        activity.principal_email AS principal_email,
        activity.granted,
        ROW_NUMBER() OVER(PARTITION BY activity.principal_email ORDER BY activity.principal_email, activity.activity_timestamp, activity.service_name) AS login_rank,
        ROW_NUMBER() OVER(PARTITION BY activity.principal_email, activity.service_name, granted ORDER BY activity.principal_email,activity.activity_timestamp,activity.service_name) AS login_grant_rank,
        LAG(activity.activity_timestamp) OVER (ORDER BY activity.principal_email, activity.activity_timestamp, activity.service_name) as previous_login_time
       from ${security_logs.SQL_TABLE_NAME} AS activity


      -- Only include logins for a given timeframe (variable that user needs to input)
      WHERE CAST(activity.activity_timestamp AS TIMESTAMP) >= {% date_start date_filter %} AND CAST(activity.activity_timestamp AS TIMESTAMP ) < {% date_end date_filter %}
      -- OPTIONAL - only included users with a certain email
      -- AND   authentication_info.principalEmail LIKE '%@google.com'
      GROUP BY 1,2,3,4
      ORDER BY 3,5),

      -- Working off above temp table, rank/number subsequent logins split by successful and unsuccessful logins.
      conseq_logins AS
      (
          SELECT *,
            ROW_NUMBER() OVER(PARTITION BY principal_email, service_name, granted, login_rank - login_grant_rank ORDER BY principal_email,login_rank) AS conseq_login_rank,
            MAX(rank_logins.activity_timestamp_date) OVER (PARTITION BY principal_email, service_name, granted, login_rank - login_grant_rank) AS event_id_timestamp
          FROM rank_logins
          ORDER BY principal_email, login_rank
      ),

      -- get last successful and unsuccessful login
      login_facts AS (
        SELECT
          principal_email,
          service_name,
          MAX(CASE WHEN granted='Yes' THEN activity_timestamp_date ELSE NULL END) AS latest_successful_login,
          MAX(CASE WHEN granted='No' THEN conseq_login_rank ELSE NULL END) as max_not_granted_rank
        FROM conseq_logins
        GROUP BY 1,2
            ),

      max_failed_login AS (
        SELECT
          conseq_logins.principal_email,
          conseq_logins.service_name,
          MAX(CASE WHEN max_not_granted_rank = conseq_login_rank AND granted = 'No' THEN activity_timestamp_date ELSE NULL END) as max_failed_login_time
        FROM conseq_logins
        LEFT JOIN login_facts ON login_facts.principal_email = conseq_logins.principal_email AND login_facts.service_name = conseq_logins.service_name
        GROUP BY 1, 2

      )
      -- select all relevant data from above temp tables
      SELECT
        conseq_logins.activity_timestamp_date AS activity_timestamp_date_time,
        conseq_logins.service_name  AS service_name,
        conseq_logins.principal_email  AS principal_email,
        conseq_logins.granted AS granted,
        conseq_logins.login_rank  AS login_rank,
        conseq_logins.login_grant_rank  AS login_grant_rank,
        conseq_logins.conseq_login_rank,
        login_facts.latest_successful_login AS max_granted_time,
        max_failed_login.max_failed_login_time AS max_not_granted_time,
        login_facts.max_not_granted_rank as max_not_granted_rank,
        conseq_logins.login_rank - conseq_logins.login_grant_rank as event_id,
        conseq_logins.event_id_timestamp as event_id_timestamp,
        conseq_logins.previous_login_time as previous_login_time
      FROM conseq_logins
      LEFT JOIN login_facts ON login_facts.principal_email = conseq_logins.principal_email AND login_facts.service_name = conseq_logins.service_name
      LEFT JOIN max_failed_login ON max_failed_login.principal_email = conseq_logins.principal_email AND max_failed_login.service_name = conseq_logins.service_name

     WHERE ((conseq_logins.conseq_login_rank >= {% parameter failed_login_threshold %} AND conseq_logins.granted = 'No') OR (conseq_logins.granted = 'Yes' AND conseq_logins.previous_login_time = max_failed_login.max_failed_login_time AND login_facts.max_not_granted_rank >= {% parameter failed_login_threshold %}))
       and login_facts.latest_successful_login >= max_failed_login.max_failed_login_time

      GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13
      ORDER BY 3,5;;
  }

  filter: date_filter {
    type: date
  }

  parameter: failed_login_threshold {
    type: number
    default_value: "3"
  }

  dimension_group: previous_login_timestamp {
    type: time
    sql: CAST(${TABLE}.previous_login_time AS TIMESTAMP) ;;
  }

  dimension_group: activity_timestamp_date_time {
    type: time
    timeframes: [millisecond, time, hour, date, month, quarter, year]
    sql: CAST(${TABLE}.activity_timestamp_date_time AS TIMESTAMP) ;;
  }

  dimension: service_name_raw {
    hidden: yes
    type: string
    sql: ${TABLE}.service_name ;;
  }

  dimension: event_id {
    type: number
    sql: ${TABLE}.event_id ;;
  }

  dimension: service_name {
    type: string
    sql: SUBSTR(${service_name_raw}, 0, STRPOS(${service_name_raw}, ".") -1)  ;;
  }

  dimension: principal_email {
    type: string
    sql: ${TABLE}.principal_email ;;
  }

  dimension: granted {
    type: string
    sql: CASE WHEN ${TABLE}.granted = 'Yes' THEN 'Granted'
          ELSE 'Denied' END ;;
     html:
    {% if value == 'Granted' %}
    <div style="background: #8BC34A; border-radius: 2px; color: #fff; display: inline-block; font-size: 11px; font-weight: bold; line-height: 1; padding: 3px 4px; width: 100%; text-align: center;">{{ rendered_value }}</div>
    {% elsif value == 'Denied' %}
    <div style="background:  #FF0000; border-radius: 2px; color: #fff; display: inline-block; font-size: 11px; font-weight: bold; line-height: 1; padding: 3px 4px; width: 100%; text-align: center;">{{ rendered_value }}</div>
    {% endif %} ;;
  }

  dimension: conseq_login_rank  {
    type: number
    sql: ${TABLE}.conseq_login_rank ;;
  }
  dimension: login_rank {
    type: number
    sql: ${TABLE}.login_rank ;;
  }

  dimension: login_grant_rank {
    type: number
    sql: ${TABLE}.login_grant_rank ;;
  }

  dimension_group: event_id_timestamp {
    type: time
    sql: CAST(${TABLE}.event_id_timestamp AS TIMESTAMP) ;;
  }

  dimension_group: max_granted_time {
    type: time
    sql: CAST(${TABLE}.max_granted_time AS TIMESTAMP) ;;
  }

  dimension_group: max_not_granted_time {
    type: time
    sql: CAST(${TABLE}.max_not_granted_time AS TIMESTAMP) ;;
  }

  dimension: max_not_granted_rank {
    label: "Max # of Consecutive Denies"
    type: number
    sql: ${TABLE}.max_not_granted_rank ;;
  }

  set: detail {
    fields: [
      activity_timestamp_date_time_time,
      service_name,
      principal_email,
      granted,
      login_rank,
      login_grant_rank,
      max_granted_time_time
      ]
  }
}
