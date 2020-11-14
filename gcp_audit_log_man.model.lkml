connection: "thelook_daily_updates"
#"gcpsecurity-logs-bq"

# include all the views
include: "/views/**/*.view"

datagroup: daily_group {
  sql_trigger: SELECT CURRENT_DATE() ;;
}
explore: findings_log {}

explore: system_event {}

explore: setiampolicy_operation {}

explore: activity {
  always_filter: {
    filters: [activity.timestamp_date: "3 days"]
  }

  join: activity_auditlog {
    sql: LEFT JOIN UNNEST([${activity.protopayload_auditlog}]) as activity_auditlog ;;
    relationship: one_to_one
  }

  join: activity_authorization_info {
    relationship: one_to_many
    sql: LEFT JOIN UNNEST(${activity_auditlog.authorization_info}) as activity_authorization_info ;;
  }

  join: activity_authentication_info {
    sql: LEFT JOIN UNNEST([${activity_auditlog.authentication_info}]) as activity_authentication_info ;;
    relationship: one_to_one
  }

}

explore: access {
  join: access_auditlog {
    sql: LEFT JOIN UNNEST([${access.protopayload_auditlog}]) as access_auditlog ;;
    relationship: one_to_one
  }

  join: access_authorization_info {
    relationship: one_to_many
    sql: LEFT JOIN UNNEST(${access_auditlog.authorization_info}) as access_authorization_info ;;
  }

  join: access_authentication_info {
    sql: LEFT JOIN UNNEST([${access_auditlog.authentication_info}]) as access_authentication_info ;;
    relationship: one_to_one
  }

  join: resource_attributes {
    sql: LEFT JOIN UNNEST([${access_authorization_info.resource_attributes}]) as resource_attributes ;;
    relationship: one_to_one
  }
}

explore: failed_logins {
  always_filter: {
    filters: [failed_logins.date_filter: "last 7 days"]
  }
}

explore: security_logs {}
