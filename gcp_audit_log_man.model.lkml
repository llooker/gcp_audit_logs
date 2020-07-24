connection: "gcpsecurity-logs-bq"

# include all the views
include: "/views/**/*.view"


explore: activity {


  join: auditlog {
    sql: LEFT JOIN UNNEST([${activity.protopayload_auditlog}]) as auditlog ;;
    relationship: one_to_one
  }


  join: authorization_info {
    relationship: one_to_many
    sql: LEFT JOIN UNNEST(${auditlog.authorization_info}) as authorization_info ;;
  }

  join: authentication_info {
    sql: LEFT JOIN UNNEST([${auditlog.authentication_info}]) as authentication_info ;;
    relationship: one_to_one
  }


}
