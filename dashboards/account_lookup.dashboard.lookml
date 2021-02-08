- dashboard: account_lookup
  title: Account Lookup
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Denies and Grants by Day
    name: Denies and Grants by Day
    model: gcp_security
    explore: activity
    type: looker_line
    fields: [activity.access_denials, activity.access_grants, activity.timestamp_date]
    fill_fields: [activity.timestamp_date]
    filters: {}
    sorts: [activity.timestamp_date desc]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    color_application:
      collection_id: google
      palette_id: google-categorical-0
      options:
        steps: 5
        reverse: false
    y_axes: [{label: !!null '', orientation: left, series: [{axisId: activity.access_grants,
            id: activity.access_grants, name: Access Grants}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: '', orientation: right, series: [{axisId: activity.access_denials, id: activity.access_denials,
            name: Access Denials}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_colors:
      activity.access_denials: "#EA4335"
      activity.access_grants: "#34A853"
    defaults_version: 1
    hidden_fields: []
    listen:
      Principal Email: activity_authentication_info.principal_email
      Timestamp Date: activity.timestamp_date
    row: 0
    col: 0
    width: 24
    height: 8
  - title: Access Activity
    name: Access Activity
    model: gcp_security
    explore: activity
    type: looker_grid
    fields: [activity.timestamp_time, activity_authorization_info.granted, activity_authorization_info.permission,
      activity.service_name, activity_authorization_info.resource]
    filters: {}
    sorts: [activity.timestamp_time desc]
    limit: 500
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    color_application:
      collection_id: google
      palette_id: google-categorical-0
      options:
        steps: 5
        reverse: false
    y_axes: [{label: !!null '', orientation: left, series: [{axisId: activity.access_grants,
            id: activity.access_grants, name: Access Grants}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: '', orientation: right, series: [{axisId: activity.access_denials, id: activity.access_denials,
            name: Access Denials}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_colors:
      activity.access_denials: "#EA4335"
      activity.access_grants: "#34A853"
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    listen:
      Principal Email: activity_authentication_info.principal_email
      Timestamp Date: activity.timestamp_date
    row: 8
    col: 0
    width: 24
    height: 8
  - title: Identities Created by Principal Email
    name: Identities Created by Principal Email
    model: gcp_security
    explore: activity
    type: table
    fields: [activity.email_id]
    filters:
      activity.email_id: "-NULL"
    sorts: [activity.email_id]
    limit: 500
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Principal Email: activity_authentication_info.principal_email
      Timestamp Date: activity.timestamp_date
    row: 16
    col: 0
    width: 6
    height: 6
  - title: Identity That Created This Principal Email
    name: Identity That Created This Principal Email
    model: gcp_security
    explore: activity
    type: table
    fields: [activity_authentication_info.principal_email, activity.timestamp_date]
    filters:
      activity.timestamp_date: 3 years
    sorts: [activity_authentication_info.principal_email]
    limit: 500
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Principal Email: activity.email_id
    row: 16
    col: 6
    width: 8
    height: 6
  filters:
  - name: Principal Email
    title: Principal Email
    type: string_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
  - name: Timestamp Date
    title: Timestamp Date
    type: field_filter
    default_value: 7 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: gcp_security
    explore: activity
    listens_to_filters: []
    field: activity.timestamp_date
