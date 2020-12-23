connection: "looker-private-demo"
label: "GCP Security"

include: "/views/**/*.view"

datagroup: daily_group {
  sql_trigger: SELECT CURRENT_DATE() ;;
}

explore: setiampolicy_operation {
  label: "IAM Policy"
}

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
  join: ip_to_geography_lookup {
    view_label: "Admin Activity"
    type: inner
    relationship: many_to_one
    # note: this only works for IPv4 address right now, not IPv6
    sql_on:
    ${ip_to_geography_lookup.class_b} = ${activity.class_b} AND
    ${activity.caller_ipv4} BETWEEN ${ip_to_geography_lookup.start_ipv4_to_int64}
    and ${ip_to_geography_lookup.end_ipv4_int64};;
  }
}

explore: access {
  view_label: "Data Access"
  join: access_auditlog {
    sql: LEFT JOIN UNNEST([${access.protopayload_auditlog}]) as access_auditlog ;;
    relationship: one_to_one
  }
  join: access_authorization_info {
    view_label: "Data Access"
    relationship: one_to_many
    sql: LEFT JOIN UNNEST(${access_auditlog.authorization_info}) as access_authorization_info ;;
  }
  join: access_authentication_info {
    view_label: "Data Access"
    sql: LEFT JOIN UNNEST([${access_auditlog.authentication_info}]) as access_authentication_info ;;
    relationship: one_to_one
  }
  join: resource_attributes {
    view_label: "Data Access"
    sql: LEFT JOIN UNNEST([${access_authorization_info.resource_attributes}]) as resource_attributes ;;
    relationship: one_to_one
  }
}

explore: failed_logins {
  always_filter: {
    filters: [failed_logins.date_filter: "last 7 days"]
  }
}
