- dashboard: mitre_attck_gcp_analysis
  title: MITRE ATT&CK GCP Analysis
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Total MITRE ATT&CK Tactics Activity
    name: Total MITRE ATT&CK Tactics Activity
    model: gcp_security
    explore: activity
    type: single_value
    fields: [activity.total_mitre_api_calls]
    filters: {}
    limit: 500
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Timeframe: activity.timestamp_date
    row: 0
    col: 1
    width: 21
    height: 2
  - title: Collection
    name: Collection
    model: gcp_security
    explore: activity
    type: single_value
    fields: [activity.collection_total]
    filters: {}
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Timeframe: activity.timestamp_date
    row: 6
    col: 15
    width: 7
    height: 4
  - title: Credential Access
    name: Credential Access
    model: gcp_security
    explore: activity
    type: single_value
    fields: [activity.credential_access_total]
    filters: {}
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Timeframe: activity.timestamp_date
    row: 6
    col: 8
    width: 7
    height: 4
  - title: Defense Evasion
    name: Defense Evasion
    model: gcp_security
    explore: activity
    type: single_value
    fields: [activity.defense_evasion_total]
    filters: {}
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Timeframe: activity.timestamp_date
    row: 10
    col: 1
    width: 7
    height: 4
  - title: Discovery
    name: Discovery
    model: gcp_security
    explore: activity
    type: single_value
    fields: [activity.discovery_total]
    filters: {}
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Timeframe: activity.timestamp_date
    row: 14
    col: 8
    width: 7
    height: 4
  - title: Exfiltration
    name: Exfiltration
    model: gcp_security
    explore: activity
    type: single_value
    fields: [activity.exfiltration_total]
    filters: {}
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Timeframe: activity.timestamp_date
    row: 6
    col: 1
    width: 7
    height: 4
  - title: Initial Access
    name: Initial Access
    model: gcp_security
    explore: activity
    type: single_value
    fields: [activity.initial_access_total]
    filters: {}
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Timeframe: activity.timestamp_date
    row: 10
    col: 15
    width: 7
    height: 4
  - title: Persistence
    name: Persistence
    model: gcp_security
    explore: activity
    type: single_value
    fields: [activity.persistence_total]
    filters: {}
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Timeframe: activity.timestamp_date
    row: 10
    col: 8
    width: 7
    height: 4
  - title: Privilege Escalation
    name: Privilege Escalation
    model: gcp_security
    explore: activity
    type: single_value
    fields: [activity.privilege_escalation_total]
    filters: {}
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Timeframe: activity.timestamp_date
    row: 14
    col: 1
    width: 7
    height: 4
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: ''
    row: 20
    col: 15
    width: 7
    height: 4
  - title: MITRE ATT&CK Tactics Activity
    name: MITRE ATT&CK Tactics Activity
    model: gcp_security
    explore: activity
    type: looker_line
    fields: [activity.timestamp_week, activity.total_mitre_api_calls]
    filters:
      activity.method_name: google.admin.AdminService.createRole,google.admin.AdminService.createUser,google.admin.AdminService.assignRole,google.admin.AdminService.addGroupMember
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    x_axis_gridlines: false
    y_axis_gridlines: false
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
    y_axes: [{label: '', orientation: left, series: [{axisId: activity.count, id: activity.count,
            name: Activity Count}], showLabels: false, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    hide_legend: true
    series_types: {}
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Timeframe: activity.timestamp_date
    row: 2
    col: 1
    width: 21
    height: 4
  - title: Accounts With MITRE ATT&CK Activity
    name: Accounts With MITRE ATT&CK Activity
    model: gcp_security
    explore: activity
    type: looker_grid
    fields: [activity.total_mitre_api_calls, activity_authentication_info.principal_email]
    filters:
      activity.timestamp_date: 365 days
    sorts: [activity.total_mitre_api_calls desc]
    limit: 10
    column_limit: 50
    query_timezone: America/Los_Angeles
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
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    defaults_version: 1
    series_types: {}
    row: 14
    col: 15
    width: 7
    height: 6
  filters:
  - name: Timeframe
    title: Timeframe
    type: field_filter
    default_value: 365 day
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
