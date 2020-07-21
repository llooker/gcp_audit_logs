view: activity {
  sql_table_name: `allofthelogs.cloudaudit_googleapis_com_activity`
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

  ###########
  ## MEASURES

  measure: count {
    type: count
    drill_fields: [log_name]
  }



  ###############
  ## JSON FIELDS

  ## http_request
  dimension: http_request {
    hidden: yes
    sql: ${TABLE}.httpRequest ;;
  }

  dimension: cache_fill_bytes {
    type: number
    sql: ${TABLE}.httpRequest.cacheFillBytes ;;
  }

  dimension: cache_hit {
    type: yesno
    sql: ${TABLE}.httpRequest.cacheHit ;;
  }

  dimension: cache_lookup {
    type: yesno
    sql: ${TABLE}.httpRequest.cacheLookup ;;
  }

  dimension: cache_validated_with_origin_server {
    type: yesno
    sql: ${TABLE}.httpRequest.cacheValidatedWithOriginServer ;;
  }

  dimension: protocol {
    type: string
    sql: ${TABLE}.httpRequest.protocol ;;
  }

  dimension: referer {
    type: string
    sql: ${TABLE}.httpRequest.referer ;;
  }

  dimension: remote_ip {
    type: string
    sql: ${TABLE}.httpRequest.remoteIp ;;
  }

  dimension: request_method {
    type: string
    sql: ${TABLE}.httpRequest.requestMethod ;;
  }

  dimension: request_size {
    type: number
    sql: ${TABLE}.httpRequest.requestSize ;;
  }

  dimension: request_url {
    type: string
    sql: ${TABLE}.httpRequest.requestUrl ;;
  }

  dimension: response_size {
    type: number
    sql: ${TABLE}.httpRequest.responseSize ;;
  }

  dimension: server_ip {
    type: string
    sql: ${TABLE}.httpRequest.serverIp ;;
  }

  dimension: status {
    type: number
    sql: ${TABLE}.httpRequest.status ;;
  }

  dimension: user_agent {
    type: string
    sql: ${TABLE}.httpRequest.userAgent ;;
  }

########
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

  dimension: resource {
    hidden: yes
    sql: ${TABLE}.resource ;;
  }

  dimension: source_location {
    hidden: yes
    sql: ${TABLE}.sourceLocation ;;
  }

#   dimension: granted {
#     type: yesno
#     sql: ${authorization_info.granted} ;;
#   }

#   dimension_group: receive_timestamp {
#     type: time
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: ${TABLE}.receiveTimestamp ;;
#   }
#

# Doesn't work
# dimension: test_granted {
#   sql: ${auditlog.authorization_info}.granted ;;
# }

}


  ##########
  ## ARRAYS and NESTING
  view: auditlog {
    sql_table_name: `cloudaudit_googleapis_com_activity.protopayload_auditlog` ;;

    dimension: authorization_info {
      hidden: yes
      sql: ${TABLE}.authorizationInfo ;;
    }
  }


  view: authorization_info {
    sql_table_name: `cloudaudit_googleapis_com_activity.protopayload_auditlog.authorization_info` ;;

  dimension: granted {
    type: yesno
    sql: ${TABLE}.granted ;;
  }


  }
