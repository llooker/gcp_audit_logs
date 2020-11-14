view: activity {
  sql_table_name: `security_logs.cloudaudit_googleapis_com_activity`
    ;;

 #############
 ## DIMENSIONS

  dimension: log_name {
    type: string
    sql: ${TABLE}.logName ;;
  }

  dimension: severity {
    type: string
    sql: ${TABLE}.severity ;;
  }

  dimension: added_permissions {
    type: string
    # sql: TO_JSON_STRING(${TABLE}.protopayload_auditlog.servicedata_v1_iam_admin.permissionDelta.addedPermissions)  ;;
    sql: FORMAT("%T", ${TABLE}.protopayload_auditlog.servicedata_v1_iam_admin.permissionDelta.addedPermissions)  ;;
  }


  measure: count_services {
    label: "Services Count"
    type: count_distinct
    sql: ${service_name} ;;
    drill_fields: [drill1*]
  }

  measure: count_emails {
    label: "User Count"
    type: count_distinct
    sql:  ${activity_authentication_info.principal_email} ;;
    drill_fields: [drill1*]
  }

  # measure: ipv4_count {
  #   label: "IPv4 Count"
  #   type: count_distinct
  #   sql: ${caller_ipv4} ;;
  # }


  # measure: ipv6_count {
  #   label: "IPv6 Count"
  #   type: count_distinct
  #   sql: ${caller_ipv6} ;;
  # }

  dimension_group: timestamp {
    type: time
    timeframes: [
      raw,
      time,
      microsecond,
      millisecond,
      minute30,
      hour,
      date,
      day_of_month,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.timestamp ;;
  }

  dimension_group: receive {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.receiveTimestamp ;;
  }

  ###########
  ## DEMO FIELDS
  ## only used for demo purposes

  measure: access_denials_demo {
    group_label: "Demo Data"
    description: "Used to make demo data more spiky "
    label: "Access Denials"
    type: sum
    sql: CASE WHEN ${timestamp_day_of_month} IN (2, 16) THEN 3
         WHEN ${timestamp_day_of_month} IN (9, 29) THEN 1.7
         WHEN ${timestamp_day_of_month} IN (12, 22 ) THEN 0.4
         ELSE 1 END ;;
    filters: [activity_authorization_info.granted : "No"]
    drill_fields: [drill1*]
    }

  measure: access_grants_demo {
    group_label: "Demo Data"
    description: "Used to make demo data more spiky"
    label: "Access Grants"
    type: sum
    sql: CASE WHEN ${timestamp_day_of_month} IN (3, 17) THEN 2.3
         WHEN ${timestamp_day_of_month} IN (15, 27) THEN 0.7
         WHEN ${timestamp_day_of_month} IN (10, 20 ) THEN 1.75
         ELSE 1 END ;;
    filters: [activity_authorization_info.granted : "Yes"]
    drill_fields: [drill1*]
  }

  measure: percent_failed_logins_demo {
    group_label: "Demo Data"
    description: "Used to make demo data more spiky"
    label: "% Failed Logins"
    type: number
    value_format_name: percent_0
    sql: ${access_denials_demo} / ${count} ;;
    drill_fields: [drill1*]
  }


  ###########
  ## MEASURES

  measure: count {
    label: "Activity Count"
    type: count
    drill_fields: [drill1*]
  }


  measure: access_denials {
    description: "Count of Access Grants being Denied by a Service"
    type: count
    filters: [activity_authorization_info.granted : "No"]
    drill_fields: [drill1*]
    }

  measure: access_grants {
    description: "Count of Successful Access Grants"
    type: count
    filters: [activity_authorization_info.granted : "Yes"]
    drill_fields: [drill1*]
    }

  measure: percent_failed_logins {
    type: number
    value_format_name: percent_0
    sql: ${access_denials} / ${count} ;;
    drill_fields: [drill1*]
    }


  # measure: access_denials_demo {
  #   #hidden: yes
  #   description: "Used to make demo data more spiky"
  #   type: number
  #   sql: SUM(CASE WHEN ${timestamp_day_of_month} IN (2, 16, 29) THEN (9 * RAND())
  #       ELSE 1 END) ;;
  #   filters: [activity_authorization_info.granted : "No"]
  #   drill_fields: [authentication_info.principal_email, timestamp_time, service_name, access_denials]
  # }

measure: avg_denials_per_user {
  type: number
  value_format_name: decimal_1
  sql: ${access_denials} / ${activity.count_emails}  ;;
  drill_fields: [authentication_info.principal_email, timestamp_time, service_name, avg_denials_per_user]
}



  ###############
  ## JSON FIELDS

  ## http_request
  dimension: http_request {
    hidden: yes
    sql: ${TABLE}.httpRequest ;;
  }

  dimension: insert_id {
    type: string
    sql: ${TABLE}.insertId ;;
    primary_key: yes
  }

  dimension: labels {
    hidden: yes
    sql: ${TABLE}.labels ;;
  }

  dimension: operation {
    hidden: yes
    sql: ${TABLE}.operation ;;
  }

  dimension: protopayload_auditlog {
    hidden: yes
    sql: ${TABLE}.protopayload_auditlog ;;
  }


  dimension: requesttest {
    view_label: "Activity AuditLog"
    sql: ${TABLE}.protopayload_auditlog.request.name ;;
  }

  dimension: metadata_json {
    view_label: "Activity AuditLog"
    type: string
    sql: ${TABLE}.protopayload_auditlog.metadataJson ;;
  }

  dimension: method_name {
    view_label: "Activity AuditLog"
    type: string
    sql: ${TABLE}.protopayload_auditlog.methodName ;;
  }

  dimension: num_response_items {
    view_label: "Activity AuditLog"
    type: number
    sql: ${TABLE}.protopayload_auditlog.numResponseItems ;;
  }

  dimension: request_json {
    view_label: "Activity AuditLog"
    type: string
    sql: ${TABLE}.protopayload_auditlog.requestJson ;;
  }

  dimension: resource_name {
    view_label: "Activity AuditLog"
    type: string
    sql: ${TABLE}.protopayload_auditlog.resourceName ;;
  }

  dimension: table_name {
    view_label: "Activity AuditLog"
    type: string
    sql: REGEXP_EXTRACT(${TABLE}.protopayload_auditlog.resourceName, '^projects/[^/]+/datasets/[^/]+/tables/(.*)$')  ;;
  }

  dimension: resource {
    hidden: yes
    sql: ${TABLE}.resource ;;
  }

  dimension: resource_type {
    sql: ${TABLE}.resource.type ;;
  }

  dimension: status {
    hidden: yes
    sql: ${TABLE}.protopayload_auditlog.status ;;
  }

  dimension: code {
    view_label: "Activity AuditLog"
    group_label: "Status"
    type: number
    sql: ${TABLE}.protopayload_auditlog.status.code ;;
  }

  dimension: message {
    view_label: "Activity AuditLog"
    group_label: "Status"
    type: string
    sql: ${TABLE}.protopayload_auditlog.status.message ;;
  }

  dimension: caller_ip {
    view_label: "Activity AuditLog"
    group_label: "Request Metadata"
    type: string
    sql: ${TABLE}.protopayload_auditlog.requestMetadata.callerIp ;;
  }

  dimension: caller_ipv4 {
    view_label: "Activity AuditLog"
    group_label: "Request Metadata"
    type: number
    sql: CASE
         WHEN REGEXP_CONTAINS(${caller_ip}, r":") THEN 0
         WHEN REGEXP_CONTAINS(${caller_ip}, r"-") THEN 0
         ELSE NET.IPV4_TO_INT64(NET.SAFE_IP_FROM_STRING(${caller_ip}))
         END;;
#REGEXP_CONTAINS(${caller_ip}, r":") THEN null
#${caller_ip} LIKE '%:%' THEN NULL
  }

  # dimension: caller_ipv6 {
  #   view_label: "Activity AuditLog"
  #   group_label: "Request Metadata"
  #   sql: CASE WHEN REGEXP_CONTAINS(${caller_ip}, r":") THEN ${caller_ip} ELSE null END ;;

  # }

  dimension: class_b {
    # sql: TRUNC(NET.IPV4_TO_INT64(NET.SAFE_IP_FROM_STRING(${caller_ip}))/(256*256));;
    sql:
    CASE
         WHEN REGEXP_CONTAINS(${caller_ip}, r":") THEN 0
         WHEN REGEXP_CONTAINS(${caller_ip}, r"-") THEN 0
    ELSE TRUNC(NET.IPV4_TO_INT64(NET.IP_FROM_STRING(${caller_ip}))/(256*256))
    END     ;;
    hidden: yes
  }

  # dimension: class_bb {
  #   sql: NET.IPV4_TO_INT64(${class_b}) ;;
  # }



  dimension: caller_network {
    view_label: "Activity AuditLog"
    group_label: "Request Metadata"
    type: string
    sql: ${TABLE}.protopayload_auditlog.requestMetadata.callerNetwork ;;
  }

  dimension: caller_supplied_user_agent {
    view_label: "Activity AuditLog"
    group_label: "Request Metadata"
    type: string
    sql: ${TABLE}.protopayload_auditlog.requestMetadata.callerSuppliedUserAgent ;;
  }

  dimension: bucket_name {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.bucket_name ;;
  }

  dimension: client_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.client_id ;;
  }

  dimension: cluster_name {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.cluster_name ;;
  }

  dimension: crypto_key_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.crypto_key_id ;;
  }

  dimension: database_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.database_id ;;
  }

  dimension: dataset_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.dataset_id ;;
  }

  dimension: disk_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.disk_id ;;
  }

  dimension: email_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.email_id ;;
  }

  dimension: firewall_rule_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.firewall_rule_id ;;
  }

  dimension: instance_group_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.instance_group_id ;;
  }

  dimension: instance_group_manager_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.instance_group_manager_id ;;
  }

  dimension: instance_group_manager_name {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.instance_group_manager_name ;;
  }

  dimension: instance_group_name {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.instance_group_name ;;
  }

  dimension: instance_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.instance_id ;;
  }

  dimension: instance_template_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.instance_template_id ;;
  }

  dimension: instance_template_name {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.instance_template_name ;;
  }

  dimension: key_ring_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.key_ring_id ;;
  }

  dimension: location {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.location ;;
  }

  dimension: method {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.method ;;
  }

  dimension: resource_labels_name {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.name ;;
  }

  dimension: network_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.network_id ;;
  }

  dimension: nodepool_name {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.nodepool_name ;;
  }

  dimension: organization_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.organization_id ;;
  }

  dimension: policy_name {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.policy_name ;;
  }

  dimension: project_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.project_id ;;
  }

  dimension: region {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.region ;;
  }

  dimension: reserved_address_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.reserved_address_id ;;
  }

  dimension: role_name {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.role_name ;;
  }

  dimension: router_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.router_id ;;
  }

  dimension: resource_service {
    group_label: "Resource Labels"
    hidden: yes
    type: string
    sql: ${TABLE}.resource.labels.service ;;
  }

  dimension: subnetwork_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.subnetwork_id ;;
  }

  dimension: subnetwork_name {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.subnetwork_name ;;
  }

  dimension: target_pool_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.target_pool_id ;;
  }

  dimension: unique_id {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.unique_id ;;
  }

  dimension: version {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.version ;;
  }

  dimension: zone {
    group_label: "Resource Labels"
    type: string
    sql: ${TABLE}.resource.labels.zone ;;
  }

  dimension: source_location {
    hidden: yes
    sql: ${TABLE}.sourceLocation ;;
  }

  #############
  ## BIGQUERY FIELDS
  dimension: dataset_name {
    view_label: "BigQuery"
    type: string
    sql: REGEXP_EXTRACT(${TABLE}.protopayload_auditlog.resourceName, '^projects/[^/]+/datasets/([^/]+)/tables')  ;;
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

  dimension: bytes_billed {
    view_label: "BigQuery"
    type: number
    sql:  ${TABLE}.protopayload_auditlog.servicedata_v1_bigquery.jobCompletedEvent.job.jobStatistics.totalBilledBytes ;;
  }

  set: drill1 {
    fields: [service_name, timestamp_time, activity_authorization_info.granted, resource]
  }

  # can't use dot notation to get to fields within authorization info because it's an array
  dimension: perm2 {
    type: string
    sql: ${TABLE}.protopayload_auditlog.authorizationInfo.permission ;;
  }
}


  ##########
  ## ARRAYS and NESTING
  view: activity_auditlog {
    view_label: "Activity AuditLog"
    sql_table_name: `cloudaudit_googleapis_com_activity.protopayload_auditlog` ;;

    dimension: authorization_info {
      hidden: yes
      sql: ${TABLE}.authorizationInfo ;;
    }
    dimension: authentication_info {
      hidden: yes
      sql: ${TABLE}.authenticationInfo ;;
    }

    ### deal with the @ in the key name
    dimension: type {
      sql: json_extract_scalar(replace(protopayload_auditlog.requestJson, '@type', 'type'),"$.type") ;;
    }
  }


  view: activity_authorization_info {
    sql_table_name: `cloudaudit_googleapis_com_activity.protopayload_auditlog.authorization_info` ;;
    view_label: "Activity AuditLog"

    dimension: permission {
      group_label: "Authorization Info"
      type: string
      sql: ${TABLE}.permission ;;
    }

    dimension: resource {
      group_label: "Authorization Info"
      type: string
      sql: ${TABLE}.resource ;;
    }

    dimension: granted {
      group_label: "Authorization Info"
      type: yesno
      sql: ${TABLE}.granted ;;
    }

#     dimension: name {
#       group_label: "Protopayload Auditlog Auth Info Resource"
#       type: string
#       sql: ${TABLE}.protopayload_auditlog.authorization_info.resource_attributes.name ;;
#     }
#
#     dimension: service {
#       group_label: "Protopayload Auditlog Auth Info Resource"
#       type: string
#       sql: ${TABLE}.protopayload_auditlog.authorization_info.resource_attributes.service ;;
#     }
#
#     dimension: type {
#       group_label: "Protopayload Auditlog Auth Info Resource"
#       type: string
#       sql: ${TABLE}.protopayload_auditlog.authorization_info.resource_attributes.type ;;
#     }
    }

view: activity_authentication_info {
  sql_table_name: `cloudaudit_googleapis_com_activity.protopayload_auditlog.authentication_info` ;;
  view_label: "Activity AuditLog"
  dimension: authority_selector {
    group_label: "Authentication Info"
    type: string
    sql: ${TABLE}.authoritySelector ;;
  }

  dimension: principal_email {
    group_label: "Authentication Info"
    type: string
    sql: ${TABLE}.principalEmail ;;
    link: {
      label: "Account Investigation"
      url: "/dashboards-next/832?Principal+Email={{ value | encode_uri }}"
    }
  }

  dimension: principal_subject {
    group_label: "Authentication Info"
    type: string
    sql: ${TABLE}.principalSubject ;;
  }

}
