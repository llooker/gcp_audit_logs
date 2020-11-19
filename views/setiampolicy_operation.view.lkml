
view: setiampolicy_operation {
  derived_table: {
    sql: with iam_operations as
        (SELECT
          resource.labels.project_id AS projectId,
          protopayload_auditlog.serviceName AS serviceName,
          protopayload_auditlog.methodName AS methodName,
          protopayload_auditlog.authenticationInfo.principalEmail AS granterEmail,
          json_extract_scalar(replace(protopayload_auditlog.requestJson, '@type', 'type'),"$.type") AS type,
          ARRAY(
          SELECT
            STRUCT(
                  ARRAY(SELECT json_extract_scalar(members,'$') FROM UNNEST(json_extract_array(bindings, '$.members')) members) AS members,
                  json_extract_scalar(bindings,'$.role') AS role
              )
            FROM UNNEST(json_extract_array(protopayload_auditlog.requestJson,'$.policy.bindings')) bindings
          ) AS access_list,
          timestamp
        FROM `security_logs.cloudaudit_googleapis_com_activity`
        where lower(protopayload_auditlog.methodName) like '%setiampolicy%' AND (((timestamp ) >= ((TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -29 DAY))) AND (timestamp ) < ((TIMESTAMP_ADD(TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -29 DAY), INTERVAL 30 DAY)))))
        )
        select
        projectId, serviceName,methodName,granterEmail, type, timestamp, members as grantee_email, access_list.role
        from
        iam_operations iamop,
        unnest(iamop.access_list) access_list,
        unnest(access_list.members) members
       ;;
    #persist_for:"4 hours"
    }

    measure: count {
      type: count
      drill_fields: [granter_email, grantee_email, role, timestamp_minute]
    }

    measure: project_count {
      type: count_distinct
      sql: ${project_id} ;;
      drill_fields: [project_id,granter_email,timestamp_date]
    }
    measure: project_list {
      list_field: project_id
      type: list
    }
    measure: user_count {
      type: count_distinct
      sql: ${grantee_email} ;;
      drill_fields: [grantee_email]
    }
    dimension: project_id {
      type: string
      sql: ${TABLE}.projectId ;;
      link: {
        label: "Revoke access to {{value}}"
        url: "https://console.cloud.google.com/iam-admin/iam?project={{value}}"
        icon_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Google-Cloud-IAM-Logo.svg/1200px-Google-Cloud-IAM-Logo.svg.png"
      }
    }
    dimension: service_name {
      type: string
      sql: ${TABLE}.serviceName ;;
    }

    dimension: method_name {
      type: string
      sql: ${TABLE}.methodName ;;
    }

    dimension: granter_email {
      type: string
      sql: ${TABLE}.granterEmail ;;
      # action: {
      #   label: "Investigate Elevated Access Privileges"
      #   url: "https://desolate-refuge-53336.herokuapp.com/posts"
      #   icon_url: "https://sendgrid.com/favicon.ico"
      #   param: {
      #     name: "some_auth_code"
      #     value: "abc123456"
      #   }
      #   form_param: {
      #     name: "Subject"
      #     required: yes
      #     default: "Investigating {{ setiampolicy_operation.grantee_email_clean._value }}'s Elevated Access"
      #   }
      #   form_param: {
      #     name: "Body"
      #     type: textarea
      #     required: yes
      #     default: "Dear {{ value }},

      #     We noticed that you have granted {{ setiampolicy_operation.grantee_email_clean._value }}elevated access to the following projects:
      #     {{ setiampolicy_operation.project_id._value }}

      #     Please explain why this access was given, instead of using service account as dictated by standard policy."
      #   }
      # }
    }

    dimension: type {
      type: string
      sql: ${TABLE}.type ;;
    }

    dimension_group: timestamp {
      type: time
      sql: ${TABLE}.timestamp ;;
    }

    dimension: grantee_email {
      # action: {
      #   label: "Investigate Elevated Access Privileges"
      #   url: "https://desolate-refuge-53336.herokuapp.com/posts"
      #   icon_url: "https://sendgrid.com/favicon.ico"
      #   param: {
      #     name: "some_auth_code"
      #     value: "abc123456"
      #   }
      #   form_param: {
      #     name: "Subject"
      #     required: yes
      #     default: "Investigating {{ setiampolicy_operation.grantee_email_clean._value }}'s Elevated Access"
      #   }
      #   form_param: {
      #     name: "Body"
      #     type: textarea
      #     required: yes
      #     default: "Dear {{ setiampolicy_operation.grantee_email_clean._value }},

      #     We noticed that you have elevated access to the following projects:
      #     {{ setiampolicy_operation.project_list._value }}

      #     Please explain why this access was given, instead of using service account as dictated by standard policy."
      #   }
      # }
      type: string
      sql: ${TABLE}.grantee_email ;;
    }

    dimension: grantee_email_clean {
      type: string
      hidden: yes
      sql: SUBSTR(${grantee_email},STRPOS(${grantee_email},':')+1) ;;
    }

    dimension: role {
      type: string
      sql: ${TABLE}.role ;;
    }

    set: detail {
      fields: [
        project_id,
        service_name,
        method_name,
        granter_email,
        type,
        timestamp_time,
        grantee_email,
        role
      ]
    }
  }
