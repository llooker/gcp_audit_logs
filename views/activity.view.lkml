view: activity {
  sql_table_name: `security_logs.cloudaudit_googleapis_com_activity`
    ;;
  label: "Admin Activity"

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
    hidden: yes
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
    value_format_name: percent_2
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
    value_format_name: percent_2
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
    sql: ${TABLE}.protopayload_auditlog.request.name ;;
  }

  dimension: metadata_json {
    type: string
    sql: ${TABLE}.protopayload_auditlog.metadataJson ;;
  }

  dimension: method_name {
    type: string
    sql: ${TABLE}.protopayload_auditlog.methodName ;;
  }

  dimension: num_response_items {
    type: number
    sql: ${TABLE}.protopayload_auditlog.numResponseItems ;;
  }

  dimension: request_json {
    type: string
    sql: ${TABLE}.protopayload_auditlog.requestJson ;;
  }

  dimension: resource_name {
    type: string
    sql: ${TABLE}.protopayload_auditlog.resourceName ;;
  }

  dimension: table_name {
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
    group_label: "Status"
    type: number
    sql: ${TABLE}.protopayload_auditlog.status.code ;;
  }

  dimension: message {
    group_label: "Status"
    type: string
    sql: ${TABLE}.protopayload_auditlog.status.message ;;
  }

  dimension: caller_ip {
    group_label: "Request Metadata"
    type: string
    sql: ${TABLE}.protopayload_auditlog.requestMetadata.callerIp ;;
  }

  dimension: caller_ipv4 {
    group_label: "Request Metadata"
    type: number
    sql: CASE
         WHEN REGEXP_CONTAINS(${caller_ip}, r":") THEN 0
         WHEN REGEXP_CONTAINS(${caller_ip}, r"-") THEN 0
         ELSE NET.IPV4_TO_INT64(NET.SAFE_IP_FROM_STRING(${caller_ip}))
         END;;
  }

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

  dimension: caller_network {
    group_label: "Request Metadata"
    type: string
    sql: ${TABLE}.protopayload_auditlog.requestMetadata.callerNetwork ;;
  }

  dimension: caller_supplied_user_agent {
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
  ## MITRE ATT&CK FIELDS

    measure: persistence_cloud_identity {
      label: "Persistence - Cloud Identity"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "google.admin.AdminService.createRole, google.admin.AdminService.createUser, google.admin.AdminService.assignRole, google.admin.AdminService.addGroupMember"
      ]
      drill_fields: [mitre*]
    }

    measure: persistence_gce {
      label: "Persistence - GCE"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "v1.compute.disks.createSnapshot, Beta.compute.instances.insert, instances.setMetadata"
      ]
      drill_fields: [mitre*]
    }

    measure: persistence_iam {
      label: "Persistence - IAM"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "google.iam.admin.v1.CreateServiceAccountKey, google.iam.admin.v1.SetIAMPolicy, CreateServiceAccount"
      ]
      drill_fields: [mitre*]
    }

    measure: persistence_cloud_functions {
      label: "Persistence - Cloud Functions"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "google.cloud.functions.v1.CloudFunctionsService.CreateFunction, google.cloud.functions.v1.CloudFunctionsService.UpdateFunction"
      ]
      drill_fields: [mitre*]
    }

    measure: initial_access_console_cli {
      label: "Initial Access - Console/CLI"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "LoginService.loginSuccess, LoginService.loginFailure"
      ]
      drill_fields: [mitre*]
    }

    measure: privilege_escalation_cloud_identity {
      label: "Privilege Escalation - Cloud Identity"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "google.admin.AdminService.addGroupMember, google.admin.AdminService.updateAccessLevelV2, google.admin.AdminService.assignRole, google.admin.AdminService.createAccessLevelV2, google.admin.AdminService.createRole, google.admin.AdminService.changeGroupSetting"
      ]
      drill_fields: [mitre*]
    }

    measure: privilege_escalation_iam {
      label: "Privilege Escalation - IAM"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "google.iam.admin.v1.UpdateRole, google.iam.admin.v1.SetIAMPolicy, google.iam.admin.v1.CreateRole"
      ]
      drill_fields: [mitre*]
    }

    measure: privilege_escalation_access_context_manager {
      label: "Privilege Escalation - Access Context Manager"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "google.identity.accesscontextmanager.v1.AccessContextManager.UpdateAccessLevel, google.identity.accesscontextmanager.v1.AccessContextManager.UpdateServicePerimeter, google.identity.accesscontextmanager.v1.AccessContextManager.CreateAccessLevel"
      ]
      drill_fields: [mitre*]
    }

    measure: defense_evasion_GCE {
      label: "Defense Evasion - GCE"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "V1.compute.firewalls.delete, V1.compute.firewalls.update, Beta.compute.instances.delete, v1.compute.disks.createSnapshot"
      ]
      drill_fields: [mitre*]
    }

    measure: defense_evasion_cloud_resource_manager {
      label: "Defense Evasion - Cloud Resource Manager"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "ClearOrgPolicy, DeleteProject"
      ]
      drill_fields: [mitre*]
    }

    measure: credential_access_secrets_manager{
      label: "Credential Access - Secrets Manager"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "google.cloud.secretmanager.v1.SecretManagerService.AddSecretVersion, google.cloud.secretmanager.v1.SecretManagerService.ListSecrets, google.cloud.secretmanager.v1.SecretManagerService.GetSecret"
      ]
      drill_fields: [mitre*]
    }

    measure: credential_access_iam{
      label: "Credential Access - IAM"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "google.iam.admin.v1.CreateServiceAccountKey"
      ]
      drill_fields: [mitre*]
    }

    measure: discovery_gcp_services {
      label: "Discovery - GCP Services"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "GET*, LIST*"
      ]
      drill_fields: [mitre*]
    }

    measure: collection_gcs {
      label: "Collection - GCS"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "Storage.objects.get, storage.buckets.get"
      ]
      drill_fields: [mitre*]
    }

    measure: collection_bigquery {
      label: "Collection - BigQuery"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "Jobservice.insert, google.cloud.bigquery.v2.JobService.InsertJob"
      ]
      drill_fields: [mitre*]
    }

    measure: exfiltration_gcs {
      label: "Exfiltration - GCS"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "Storage.objects.get, storage.buckets.get"
      ]
      drill_fields: [mitre*]
    }

    measure: exfiltration_bigquery {
      label: "Exfiltration - BigQuery"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "Jobservice.insert, google.cloud.bigquery.v2.JobService.InsertJob"
      ]
      drill_fields: [mitre*]
    }

    measure: exfiltration_gce {
      label: "Exfiltration - GCE"
      group_label: "MITRE ATT&CK Metrics"
      type: count
      filters: [
        method_name: "v1.compute.disks.createSnapshot"
      ]
      drill_fields: [mitre*]
    }

    measure: exfiltration_total {
      label: "Exfiltration - Total"
      group_label: "MITRE ATT&CK Totals"
      type: number
      sql:  ${exfiltration_bigquery} + ${exfiltration_gce} + ${exfiltration_gcs} ;;
      drill_fields: [exfiltration_bigquery, exfiltration_gce, exfiltration_gcs]
    }

    measure: collection_total {
      label: "Collection - Total"
      group_label: "MITRE ATT&CK Totals"
      type: number
      sql:  ${collection_bigquery} + ${collection_gcs}  ;;
      drill_fields: [collection_bigquery, collection_gcs]
    }

    measure: discovery_total {
      label: "Discovery - Total"
      group_label: "MITRE ATT&CK Totals"
      type: number
      sql: ${discovery_gcp_services}  ;;
      drill_fields: [discovery_gcp_services]
    }

    measure: credential_access_total {
      label: "Credential Access - Total"
      group_label: "MITRE ATT&CK Totals"
      type: number
      sql: ${credential_access_iam} + ${credential_access_secrets_manager}  ;;
      drill_fields: [credential_access_iam, credential_access_secrets_manager]
    }

    measure: defense_evasion_total {
      label: "Defense Evasion - Total"
      group_label: "MITRE ATT&CK Totals"
      type: number
      sql: ${defense_evasion_GCE} + ${defense_evasion_cloud_resource_manager}  ;;
      drill_fields: [defense_evasion_cloud_resource_manager]
    }

    measure: privilege_escalation_total {
      label: "Privilege Escalation - Total"
      group_label: "MITRE ATT&CK Totals"
      type: number
      sql: ${privilege_escalation_cloud_identity} + ${privilege_escalation_iam} + ${privilege_escalation_access_context_manager} ;;
      drill_fields: [privilege_escalation_access_context_manager, privilege_escalation_cloud_identity, privilege_escalation_iam]
    }

    measure: initial_access_total {
      label: "Initial Access - Total"
      group_label: "MITRE ATT&CK Totals"
      type: number
      sql: ${initial_access_console_cli} ;;
      drill_fields: [initial_access_console_cli]
    }

    measure: persistence_total {
      label: "Persistence - Total"
      group_label: "MITRE ATT&CK Totals"
      type: number
      sql: ${persistence_cloud_identity} + ${persistence_gce} + ${persistence_iam} + ${persistence_cloud_functions} ;;
      drill_fields: [persistence_cloud_functions, persistence_gce, persistence_iam, persistence_cloud_identity]
    }

    measure: total_mitre_api_calls {
      label: "Total MITRE API Calls"
      group_label: "MITRE ATT&CK Totals"
      type: number
      sql: ${collection_total} + ${credential_access_total} + ${discovery_total} + ${defense_evasion_total} + ${exfiltration_total} + ${initial_access_total} + ${persistence_total} + ${privilege_escalation_total} ;;
      drill_fields: [collection_total, credential_access_total, discovery_total, defense_evasion_total, exfiltration_total, initial_access_total, persistence_total, privilege_escalation_total]
    }

  #############
  ## BIGQUERY FIELDS
  dimension: dataset_name {
    view_label: "BigQuery"
    type: string
    sql: REGEXP_EXTRACT(${TABLE}.protopayload_auditlog.resourceName, '^projects/[^/]+/datasets/([^/]+)/tables')  ;;
    hidden: yes
  }

  dimension: service_name_raw {
    hidden: yes
    type: string
    sql: ${TABLE}.protopayload_auditlog.serviceName ;;
  }


 dimension: service_name {
    type: string
    sql: SUBSTR(${service_name_raw}, 0, STRPOS(${service_name_raw}, ".") -1)  ;;
    # hidden: yes
  }

  dimension: bytes_billed {
    view_label: "BigQuery"
    type: number
    sql:  ${TABLE}.protopayload_auditlog.servicedata_v1_bigquery.jobCompletedEvent.job.jobStatistics.totalBilledBytes ;;
    hidden: yes
  }

  set: drill1 {
    fields: [service_name, timestamp_time, activity_authorization_info.granted, resource_name]
  }
  set: mitre {
    fields: [method_name, service_name, timestamp_time, activity_authentication_info.principal_email]
  }
}


  ##########
  ## ARRAYS and NESTING
  view: activity_auditlog {
    view_label: "Admin Activity"
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

    dimension: account_id {
      sql: json_extract_scalar(protopayload_auditlog.requestJson,"$.account_id") ;;
    }
  }


  view: activity_authorization_info {
    sql_table_name: `cloudaudit_googleapis_com_activity.protopayload_auditlog.authorization_info` ;;
    view_label: "Admin Activity"

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
      html:
      {% if value == 'Yes' %}
      <div style="background: #8BC34A; border-radius: 2px; color: #fff; display: inline-block; font-size: 11px; font-weight: bold; line-height: 1; padding: 3px 4px; width: 100%; text-align: center;">{{ rendered_value }}</div>
      {% elsif value == 'No' %}
      <div style="background:  #FF0000; border-radius: 2px; color: #fff; display: inline-block; font-size: 11px; font-weight: bold; line-height: 1; padding: 3px 4px; width: 100%; text-align: center;">{{ rendered_value }}</div>
      {% endif %} ;;
    }
  }

view: activity_authentication_info {
  sql_table_name: `cloudaudit_googleapis_com_activity.protopayload_auditlog.authentication_info` ;;
  view_label: "Admin Activity"
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
    action: {
      label: "Email This Principal Email Address"
      url: "https://desolate-refuge-53336.herokuapp.com/posts"
      icon_url: "https://sendgrid.com/favicon.ico"
      param: {
        name: "some_auth_code"
        value: "abc123456"
      }
      form_param: {
        name: "Subject"
        required: yes
        default: ""
      }
      form_param: {
        name: "Body"
        type: textarea
        required: yes
        default:
        ""
      }
    }
  }

  dimension: principal_subject {
    group_label: "Authentication Info"
    type: string
    sql: ${TABLE}.principalSubject ;;
  }

}
