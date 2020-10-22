view: failed_logins {
  derived_table: {
    sql:

    -- Create a temp table that has all logins by date, service, and email and number/rank them by date and date, granted per user
    WITH rank_login_sq AS (SELECT
        activity.timestamp AS activity_timestamp_date,
        activity.protopayload_auditlog.serviceName  AS service_name,
        authentication_info.principalEmail  AS principal_email,
        authorization_info.granted,
        -- number each login attempt by date and user, if same date and same user, sort by service
        ROW_NUMBER() OVER(PARTITION BY authentication_info.principalEmail ORDER BY authentication_info.principalEmail,activity.timestamp,activity.protopayload_auditlog.serviceName) RN1,
        -- number each login attempt by date, user, and whether it was successful. If same date and same user, sort by service
        ROW_NUMBER() OVER(PARTITION BY authentication_info.principalEmail, activity.protopayload_auditlog.serviceName, granted ORDER BY authentication_info.principalEmail,activity.timestamp,activity.protopayload_auditlog.serviceName) RN2
      FROM `looker-private-demo.security_logs.cloudaudit_googleapis_com_activity`
           AS activity
      LEFT JOIN UNNEST([activity.protopayload_auditlog]) as auditlog
      LEFT JOIN UNNEST(auditlog.authorizationInfo) as authorization_info
      LEFT JOIN UNNEST([auditlog.authenticationInfo]) as authentication_info

      -- Capture time range input by end user
      WHERE (activity.timestamp ) >= {% date_start date_filter %} AND (activity.timestamp ) < {% date_end date_filter %}
      -- only look at people with a google email
      AND   authentication_info.principalEmail LIKE '%@google.com'

      GROUP BY 1,2,3, 4

      ORDER BY 3,5),

      -- Working off above temp table, rank/number subsequent logins split by successful and unsuccessful logins.
      CTE2 AS
      (
          SELECT *, RN1 - RN2 as row_diff, ROW_NUMBER() OVER(PARTITION BY principal_email, service_name, granted, RN1 - RN2 ORDER BY principal_email,RN1) AS max_conseq_login_attempts
          FROM rank_login_sq
          ORDER BY principal_email, RN1
      ),

      -- get last successful login
      max_granted_time AS (SELECT
                principal_email,
                service_name,
                MAX(activity_timestamp_date) AS max_activity_timestamp_date
            FROM CTE2
            WHERE granted
            GROUP BY 1,2
            ),
      -- get last unsuccessful login and number of unsuccessful login attemps in a row
      max_not_granted_time AS (SELECT
                principal_email,
                service_name,
                MAX(activity_timestamp_date) AS max_activity_timestamp_date,
                MAX(max_conseq_login_attempts) as max_not_granted_rank
            FROM CTE2
            WHERE granted IS NULL
            GROUP BY 1,2
            )
      -- select all relevant data from above temp tables
      SELECT
        CTE2.activity_timestamp_date AS activity_timestamp_date_time,
        CTE2.service_name  AS service_name,
        CTE2.principal_email  AS principal_email,
        CASE WHEN CTE2.granted THEN 'Yes' ELSE 'No' END AS granted,
        CTE2.RN1  AS RN1,
        CTE2.RN2  AS RN2,
        CTE2.row_diff,
        CTE2.max_conseq_login_attempts,
        max_granted_time.max_activity_timestamp_date AS max_granted_time,
        max_not_granted_time.max_activity_timestamp_date AS max_not_granted_time,
        max_not_granted_time.max_not_granted_rank as max_not_granted_rank

      FROM CTE2
      LEFT JOIN max_not_granted_time ON max_not_granted_time.principal_email = CTE2.principal_email AND max_not_granted_time.service_name = CTE2.service_name
      LEFT JOIN max_granted_time ON max_granted_time.principal_email = CTE2.principal_email AND max_granted_time.service_name = CTE2.service_name

      -- Only keep users/attemps where we had a successful login last (didn't end on a string of unsuccessful logins)
      WHERE max_granted_time.max_activity_timestamp_date >= max_not_granted_time.max_activity_timestamp_date
      -- Make sure that successful login was within our timeframe that we want
      AND (max_granted_time.max_activity_timestamp_date ) >= {% date_start date_filter %} AND (max_granted_time.max_activity_timestamp_date ) < {% date_end date_filter %}
      -- add in a threshold for number of consecutive failed login attemps
      AND max_not_granted_time.max_not_granted_rank >= {% parameter failed_login_threshold %}
      GROUP BY 1,2,3,4,5,6,7,8,9,10,11
      ORDER BY 3,5;;
  }

  filter: date_filter {
    type: date
  }

  parameter: failed_login_threshold {
    type: number
    default_value: "2"
  }


  dimension_group: activity_timestamp_date_time {
    type: time
    timeframes: [millisecond, time, hour, date, month, quarter, year]
    sql: ${TABLE}.activity_timestamp_date_time ;;
  }

  dimension: service_name_raw {
    hidden: yes
    type: string
    sql: ${TABLE}.protopayload_auditlog.serviceName ;;
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

  dimension: rn1 {
    type: number
    sql: ${TABLE}.RN1 ;;
  }

  dimension: rn2 {
    type: number
    sql: ${TABLE}.RN2 ;;
  }

  dimension_group: max_granted_time {
    type: time
    sql: ${TABLE}.max_granted_time ;;
  }

  dimension_group: max_granted_time {
    type: time
    timeframes: [millisecond]
    sql: ${TABLE}.max_granted_time ;;
  }

  dimension_group: max_not_granted_time {
    type: time
    timeframes: [millisecond]
    sql: ${TABLE}.max_not_granted_time ;;
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
      rn1,
      rn2,
      max_granted_time_time
      ]
  }
}
