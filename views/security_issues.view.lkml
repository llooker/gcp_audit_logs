view: security_issues {
  derived_table: {
    sql: WITH login_ranks AS (SELECT
        activity.timestamp AS activity_timestamp_date,
        activity.protopayload_auditlog.serviceName  AS service_name,
        authentication_info.principalEmail  AS principal_email,
        authorization_info.granted as granted,
        RANK() OVER (PARTITION BY authentication_info.principalEmail, authorization_info.granted  ORDER BY activity.timestamp ASC) as granted_rank,

      FROM `allofthelogs.cloudaudit_googleapis_com_activity`
           AS activity
      LEFT JOIN UNNEST([activity.protopayload_auditlog]) as auditlog
      LEFT JOIN UNNEST(auditlog.authorizationInfo) as authorization_info
      LEFT JOIN UNNEST([auditlog.authenticationInfo]) as authentication_info
      WHERE (activity.timestamp ) >= {% date_start date_filter %} AND (activity.timestamp ) < {% date_end date_filter %}
      --AND   authentication_info.principalEmail LIKE 'pskulkarni@google.com'
      AND   authentication_info.principalEmail LIKE '%@google.com'

      GROUP BY 1,2,3, 4

      ORDER BY 3,1
       )
  ,  max_granted_time AS (SELECT
          principal_email,
          MAX(activity_timestamp_date) AS max_activity_timestamp_date
      FROM login_ranks
      WHERE granted
      GROUP BY 1
      )
 ,  max_not_granted_time AS (SELECT
          principal_email,
          MAX(activity_timestamp_date) AS max_activity_timestamp_date,
          MAX(granted_rank) as max_not_granted_rank
      FROM login_ranks
      WHERE granted IS NULL
      GROUP BY 1
       )

SELECT
  login_ranks.activity_timestamp_date AS activity_timestamp_date_time,
  login_ranks.service_name  AS service_name,
  login_ranks.principal_email  AS principal_email,
  CASE WHEN login_ranks.granted THEN 'Yes' ELSE 'No' END AS granted,
  login_ranks.granted_rank  AS granted_rank,
  max_granted_time.max_activity_timestamp_date AS max_granted_time,
  max_not_granted_time.max_activity_timestamp_date AS max_not_granted_time,
  max_not_granted_time.max_not_granted_rank as max_not_granted_rank
FROM login_ranks
LEFT JOIN max_not_granted_time ON max_not_granted_time.principal_email = login_ranks.principal_email
LEFT JOIN max_granted_time ON max_granted_time.principal_email = login_ranks.principal_email
WHERE max_granted_time.max_activity_timestamp_date > max_not_granted_time.max_activity_timestamp_date
AND max_granted_time.max_activity_timestamp_date >= {% date_start date_filter %}  AND max_granted_time.max_activity_timestamp_date < {% date_end date_filter %}
AND max_not_granted_time.max_not_granted_rank >= {% parameter failed_login_threshold %}
-- AND max_not_granted_time.max_not_granted_rank = login_ranks.granted_rank
-- and login_ranks.granted IS NULL

GROUP BY 1,2,3,4,5,6,7,8
ORDER BY 3, 1 ASC
 ;;
  }

  filter: date_filter {
    type: date
  }

  parameter: failed_login_threshold {
    type: number
    default_value: "5"
  }

  dimension_group: activity_timestamp_date_time {
    type: time
    timeframes: [millisecond, time, hour, date, month, quarter, year]
    sql: ${TABLE}.activity_timestamp_date_time ;;
  }

  dimension: service_name {
    type: string
    sql: ${TABLE}.service_name ;;
  }

  dimension: principal_email {
    type: string
    sql: ${TABLE}.principal_email ;;
  }

  dimension: granted {
    type: string
    sql: ${TABLE}.granted ;;
  }

  dimension: granted_rank {
    type: number
    hidden: yes
    sql: ${TABLE}.granted_rank ;;
  }

  dimension: max_not_granted_rank {
    label: "# of Failed Logins Before a Successful Login"
    type: number
#     hidden: yes
    sql: ${TABLE}.max_not_granted_rank ;;
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
}
