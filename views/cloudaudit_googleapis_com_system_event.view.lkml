view: system_event {
  sql_table_name: `looker-private-demo.security_logs.cloudaudit_googleapis_com_system_event`
    ;;

  dimension: http_request {
    hidden: yes
    sql: ${TABLE}.httpRequest ;;
  }

  dimension: insert_id {
    type: string
    sql: ${TABLE}.insertId ;;
  }

  dimension: log_name {
    type: string
    sql: ${TABLE}.logName ;;
  }

  dimension: operation {
    hidden: yes
    sql: ${TABLE}.operation ;;
  }

  dimension: protopayload_auditlog {
    hidden: yes
    sql: ${TABLE}.protopayload_auditlog ;;
  }

  dimension_group: receive_timestamp {
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

  dimension: resource {
    hidden: yes
    sql: ${TABLE}.resource ;;
  }

  dimension: severity {
    type: string
    sql: ${TABLE}.severity ;;
  }

  dimension: source_location {
    hidden: yes
    sql: ${TABLE}.sourceLocation ;;
  }

  dimension: span_id {
    type: string
    sql: ${TABLE}.spanId ;;
  }

  dimension: text_payload {
    type: string
    sql: ${TABLE}.textPayload ;;
  }

  dimension_group: timestamp {
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
    sql: ${TABLE}.timestamp ;;
  }

  dimension: trace {
    type: string
    sql: ${TABLE}.trace ;;
  }

  dimension: trace_sampled {
    type: yesno
    sql: ${TABLE}.traceSampled ;;
  }

  measure: count {
    type: count
    drill_fields: [log_name]
  }
}

view: cloudaudit_googleapis_com_system_event__resource {
  dimension: labels {
    hidden: yes
    sql: ${TABLE}.labels ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }
}

view: cloudaudit_googleapis_com_system_event__resource__labels {
  dimension: dataset_id {
    type: string
    sql: ${TABLE}.dataset_id ;;
  }

  dimension: disk_id {
    type: string
    sql: ${TABLE}.disk_id ;;
  }

  dimension: instance_group_manager_id {
    type: string
    sql: ${TABLE}.instance_group_manager_id ;;
  }

  dimension: instance_group_manager_name {
    type: string
    sql: ${TABLE}.instance_group_manager_name ;;
  }

  dimension: instance_id {
    type: string
    sql: ${TABLE}.instance_id ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }

  dimension: method {
    type: string
    sql: ${TABLE}.method ;;
  }

  dimension: project_id {
    type: string
    sql: ${TABLE}.project_id ;;
  }

  dimension: service {
    type: string
    sql: ${TABLE}.service ;;
  }

  dimension: subscription_id {
    type: string
    sql: ${TABLE}.subscription_id ;;
  }

  dimension: zone {
    type: string
    sql: ${TABLE}.zone ;;
  }
}

view: cloudaudit_googleapis_com_system_event__http_request {
  dimension: cache_fill_bytes {
    type: number
    sql: ${TABLE}.cacheFillBytes ;;
  }

  dimension: cache_hit {
    type: yesno
    sql: ${TABLE}.cacheHit ;;
  }

  dimension: cache_lookup {
    type: yesno
    sql: ${TABLE}.cacheLookup ;;
  }

  dimension: cache_validated_with_origin_server {
    type: yesno
    sql: ${TABLE}.cacheValidatedWithOriginServer ;;
  }

  dimension: protocol {
    type: string
    sql: ${TABLE}.protocol ;;
  }

  dimension: referer {
    type: string
    sql: ${TABLE}.referer ;;
  }

  dimension: remote_ip {
    type: string
    sql: ${TABLE}.remoteIp ;;
  }

  dimension: request_method {
    type: string
    sql: ${TABLE}.requestMethod ;;
  }

  dimension: request_size {
    type: number
    sql: ${TABLE}.requestSize ;;
  }

  dimension: request_url {
    type: string
    sql: ${TABLE}.requestUrl ;;
  }

  dimension: response_size {
    type: number
    sql: ${TABLE}.responseSize ;;
  }

  dimension: server_ip {
    type: string
    sql: ${TABLE}.serverIp ;;
  }

  dimension: status {
    type: number
    sql: ${TABLE}.status ;;
  }

  dimension: user_agent {
    type: string
    sql: ${TABLE}.userAgent ;;
  }
}

view: cloudaudit_googleapis_com_system_event__source_location {
  dimension: file {
    type: string
    sql: ${TABLE}.file ;;
  }

  dimension: function {
    type: string
    sql: ${TABLE}.function ;;
  }

  dimension: line {
    type: number
    sql: ${TABLE}.line ;;
  }
}

view: cloudaudit_googleapis_com_system_event__protopayload_auditlog__request_metadata {
  dimension: caller_ip {
    type: string
    sql: ${TABLE}.callerIp ;;
  }

  dimension: caller_network {
    type: string
    sql: ${TABLE}.callerNetwork ;;
  }

  dimension: caller_supplied_user_agent {
    type: string
    sql: ${TABLE}.callerSuppliedUserAgent ;;
  }

  dimension: destination_attributes {
    hidden: yes
    sql: ${TABLE}.destinationAttributes ;;
  }

  dimension: request_attributes {
    hidden: yes
    sql: ${TABLE}.requestAttributes ;;
  }
}

view: cloudaudit_googleapis_com_system_event__protopayload_auditlog__request_metadata__request_attributes__headers {
  dimension: key {
    type: string
    sql: ${TABLE}.key ;;
  }

  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }
}

view: cloudaudit_googleapis_com_system_event__protopayload_auditlog__request_metadata__request_attributes {
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: auth {
    hidden: yes
    sql: ${TABLE}.auth ;;
  }

  dimension: headers {
    hidden: yes
    sql: ${TABLE}.headers ;;
  }

  dimension: host {
    type: string
    sql: ${TABLE}.host ;;
  }

  dimension: method {
    type: string
    sql: ${TABLE}.method ;;
  }

  dimension: path {
    type: string
    sql: ${TABLE}.path ;;
  }

  dimension: protocol {
    type: string
    sql: ${TABLE}.protocol ;;
  }

  dimension: query {
    type: string
    sql: ${TABLE}.query ;;
  }

  dimension: reason {
    type: string
    sql: ${TABLE}.reason ;;
  }

  dimension: scheme {
    type: string
    sql: ${TABLE}.scheme ;;
  }

  dimension: size {
    type: number
    sql: ${TABLE}.size ;;
  }

  dimension_group: time {
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
    sql: ${TABLE}.time ;;
  }
}

view: cloudaudit_googleapis_com_system_event__protopayload_auditlog__request_metadata__request_attributes__auth {
  dimension: access_levels {
    type: string
    sql: ${TABLE}.accessLevels ;;
  }

  dimension: audiences {
    type: string
    sql: ${TABLE}.audiences ;;
  }

  dimension: presenter {
    type: string
    sql: ${TABLE}.presenter ;;
  }

  dimension: principal {
    type: string
    sql: ${TABLE}.principal ;;
  }
}

view: cloudaudit_googleapis_com_system_event__protopayload_auditlog__request_metadata__destination_attributes {
  dimension: ip {
    type: string
    sql: ${TABLE}.ip ;;
  }

  dimension: labels {
    hidden: yes
    sql: ${TABLE}.labels ;;
  }

  dimension: port {
    type: number
    sql: ${TABLE}.port ;;
  }

  dimension: principal {
    type: string
    sql: ${TABLE}.principal ;;
  }

  dimension: region_code {
    type: string
    sql: ${TABLE}.regionCode ;;
  }
}

view: cloudaudit_googleapis_com_system_event__protopayload_auditlog__request_metadata__destination_attributes__labels {
  dimension: key {
    type: string
    sql: ${TABLE}.key ;;
  }

  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }
}

view: cloudaudit_googleapis_com_system_event__protopayload_auditlog__authentication_info {
  dimension: authority_selector {
    type: string
    sql: ${TABLE}.authoritySelector ;;
  }

  dimension: principal_email {
    type: string
    sql: ${TABLE}.principalEmail ;;
  }

  dimension: principal_subject {
    type: string
    sql: ${TABLE}.principalSubject ;;
  }

  dimension: service_account_delegation_info {
    hidden: yes
    sql: ${TABLE}.serviceAccountDelegationInfo ;;
  }

  dimension: service_account_key_name {
    type: string
    sql: ${TABLE}.serviceAccountKeyName ;;
  }
}

view: cloudaudit_googleapis_com_system_event__protopayload_auditlog__authentication_info__service_account_delegation_info__first_party_principal {
  dimension: principal_email {
    type: string
    sql: ${TABLE}.principalEmail ;;
  }
}

view: cloudaudit_googleapis_com_system_event__protopayload_auditlog__authorization_info {
  dimension: granted {
    type: yesno
    sql: ${TABLE}.granted ;;
  }

  dimension: permission {
    type: string
    sql: ${TABLE}.permission ;;
  }

  dimension: resource {
    type: string
    sql: ${TABLE}.resource ;;
  }

  dimension: resource_attributes {
    hidden: yes
    sql: ${TABLE}.resourceAttributes ;;
  }
}

view: cloudaudit_googleapis_com_system_event__protopayload_auditlog__authorization_info__resource_attributes {
  dimension: labels {
    hidden: yes
    sql: ${TABLE}.labels ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: service {
    type: string
    sql: ${TABLE}.service ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }
}

view: cloudaudit_googleapis_com_system_event__protopayload_auditlog__authorization_info__resource_attributes__labels {
  dimension: key {
    type: string
    sql: ${TABLE}.key ;;
  }

  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }
}

view: cloudaudit_googleapis_com_system_event__protopayload_auditlog {
  dimension: authentication_info {
    hidden: yes
    sql: ${TABLE}.authenticationInfo ;;
  }

  dimension: authorization_info {
    hidden: yes
    sql: ${TABLE}.authorizationInfo ;;
  }

  dimension: metadata_json {
    type: string
    sql: ${TABLE}.metadataJson ;;
  }

  dimension: method_name {
    type: string
    sql: ${TABLE}.methodName ;;
  }

  dimension: num_response_items {
    type: number
    sql: ${TABLE}.numResponseItems ;;
  }

  dimension: request_json {
    type: string
    sql: ${TABLE}.requestJson ;;
  }

  dimension: request_metadata {
    hidden: yes
    sql: ${TABLE}.requestMetadata ;;
  }

  dimension: resource_location {
    hidden: yes
    sql: ${TABLE}.resourceLocation ;;
  }

  dimension: resource_name {
    type: string
    sql: ${TABLE}.resourceName ;;
  }

  dimension: response_json {
    type: string
    sql: ${TABLE}.responseJson ;;
  }

  dimension: service_name {
    type: string
    sql: ${TABLE}.serviceName ;;
  }

  dimension: status {
    hidden: yes
    sql: ${TABLE}.status ;;
  }
}

view: cloudaudit_googleapis_com_system_event__protopayload_auditlog__resource_location {
  dimension: current_locations {
    type: string
    sql: ${TABLE}.currentLocations ;;
  }

  dimension: original_locations {
    type: string
    sql: ${TABLE}.originalLocations ;;
  }
}

view: cloudaudit_googleapis_com_system_event__protopayload_auditlog__status {
  dimension: code {
    type: number
    sql: ${TABLE}.code ;;
  }

  dimension: message {
    type: string
    sql: ${TABLE}.message ;;
  }
}

view: cloudaudit_googleapis_com_system_event__operation {
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: first {
    type: yesno
    sql: ${TABLE}.first ;;
  }

  dimension: last {
    type: yesno
    sql: ${TABLE}.last ;;
  }

  dimension: producer {
    type: string
    sql: ${TABLE}.producer ;;
  }
}

view: cloudaudit_googleapis_com_system_event__protopayload_auditlog__authentication_info__service_account_delegation_info {
  dimension: first_party_principal {
    hidden: yes
    sql: ${TABLE}.firstPartyPrincipal ;;
  }
}
