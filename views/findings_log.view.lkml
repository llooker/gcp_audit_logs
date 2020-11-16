view: findings_log {
  sql_table_name: `looker-private-demo.security_logs.findings_log`
    ;;

# alternatively use Shad's view: https://googlecloud.looker.com/projects/scc_findings/files/findings_log.view.lkml

  dimension: asset {
    hidden: yes
    sql: ${TABLE}.asset ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension_group: create {
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
    sql: ${TABLE}.createTime ;;
  }

  dimension_group: event {
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
    sql: ${TABLE}.eventTime ;;
  }

  dimension: external_uri {
    type: string
    sql: ${TABLE}.externalUri ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: parent {
    type: string
    sql: ${TABLE}.parent ;;
  }

  dimension: resource_name {
    type: string
    sql: ${TABLE}.resourceName ;;
    action: {
      label: "Email Resource Owner"
      url: "https://desolate-refuge-53336.herokuapp.com/posts"
      icon_url: "https://sendgrid.com/favicon.ico"
      param: {
        name: "some_auth_code"
        value: "abc123456"
      }
      form_param: {
        name: "Subject"
        required: yes
        default: "[URGENT] - Resource vulnerabilities identified"
      }
      form_param: {
        name: "Body"
        type: textarea
        required: yes
        default:
        "Resource {{ value }} is out of compliance and needs to be addressed. Please resolve or contact sre@mycompany.com ASAP"
      }
    }
  }

  dimension: security_marks {
    hidden: yes
    sql: ${TABLE}.securityMarks ;;
  }

  dimension: source {
    hidden: yes
    sql: ${TABLE}.source ;;
  }

  dimension: source_display_name {
    type: string
    sql: ${TABLE}.source.displayName ;;
  }


  dimension: source_properties {
    hidden:no
    type: string
    sql: ${TABLE}.sourceProperties ;;
  }

  # dimension: compromised_account {
  #   type: string
  #   sql: ${TABLE}.sourceProperties.compromisedAccount ;;
  # }

  dimension: compromised_account {
    type: string
    sql: JSON_EXTRACT_SCALAR(${TABLE}.sourceProperties, "$.compromised_account") ;;
    link: {
      label: "Account Investigation"
      url: "/dashboards-next/832?Principal+Email={{ value | encode_uri }}"
    }
  }

  dimension: severity {
    type: string
    sql:
      CASE JSON_EXTRACT_SCALAR(${TABLE}.sourceProperties, "$.SeverityLevel")
        WHEN "Low" THEN "1 - Low"
        WHEN "Medium" THEN "2 - Medium"
        WHEN "High" THEN "3 - High"
        WHEN "Critical" THEN "4 - Critical"
        ELSE COALESCE(JSON_EXTRACT_SCALAR(${TABLE}.sourceProperties, "$.SeverityLevel"), "0 - Unknown")
      END ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  measure: count {
    type: count
    drill_fields: [source_display_name, category, severity, compromised_account, resource_name]
  }


  dimension: marks {
    type: string
    sql: ${TABLE}.securityMarks.marks ;;
  }

  dimension: security_marks_name {
    type: string
    sql: ${TABLE}.securityMarks.name ;;
  }

  dimension_group: security_marks_create {
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
    sql: ${TABLE}.asset.createTime ;;
  }

  dimension: iam_policy_blob {
    type: string
    sql: ${TABLE}.asset.iamPolicyBlob ;;
  }

  dimension: asset_name {
    type: string
    sql: ${TABLE}.asset.name ;;
  }

  dimension: resource_properties {
    type: string
    sql: ${TABLE}.asset.resourceProperties ;;
  }

  dimension: security_center_properties {
    hidden: yes
    sql: ${TABLE}.asset.securityCenterProperties ;;
  }

  dimension: asset_security_marks {
    hidden: yes
    sql: ${TABLE}.asset.securityMarks ;;
  }



  dimension_group: update {
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
    sql: ${TABLE}.asset.updateTime ;;
  }

  dimension: asset_security_marks_marks {
    type: string
    sql: ${TABLE}.asset.securityMarks.marks ;;
  }

  dimension: asset_security_name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: resource_display_name {
    type: string
    sql: ${TABLE}.asset.securityCenterProperties.resourceDisplayName ;;
  }

  dimension: asset_sc_properties_resource_name {
    type: string
    sql: ${TABLE}.asset.securityCenterProperties.resourceName ;;
  }

#   dimension: resource_owners {
#     type: string
#     sql: ${TABLE}.asset.securityCenterProperties.resourceOwners ;;
#   }

  dimension: resource_parent {
    type: string
    sql: ${TABLE}.asset.securityCenterProperties.resourceParent ;;
  }

  dimension: resource_parent_display_name {
    type: string
    sql: ${TABLE}.asset.securityCenterProperties.resourceParentDisplayName ;;
  }

  dimension: resource_project {
    type: string
    sql: ${TABLE}.asset.securityCenterProperties.resourceProject ;;
  }

  dimension: resource_project_display_name {
    type: string
    sql: ${TABLE}.asset.securityCenterProperties.resourceProjectDisplayName ;;
  }

  dimension: resource_type {
    type: string
    sql: ${TABLE}.asset.securityCenterProperties.resourceType ;;
  }

  dimension: scc_logo {
    hidden: yes
    type: number
    sql: 1 ;;
    html: <img src="https://res.cloudinary.com/stackrox/w_400,dpr_3.0,c_scale,fl_lossy,f_auto/v1579719223/Cloud-Security-Command-Center-1_spuod2.jpg"
           height="150" width="150";;

  }

}
