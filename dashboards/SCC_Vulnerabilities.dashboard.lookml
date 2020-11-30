- dashboard: scc_vulnerabilities
  title: SCC Vulnerabilities
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Findings by Severity
    name: Findings by Severity
    model: gcp_audit_log_man
    explore: findings_log
    type: looker_column
    fields: [findings_log.severity, findings_log.count, findings_log.event_date]
    pivots: [findings_log.severity]
    fill_fields: [findings_log.event_date]
    filters:
      findings_log.state: ACTIVE
    sorts: [findings_log.severity, findings_log.event_date desc]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      Source: findings_log.source_display_name
      Event Date: findings_log.event_date
    row: 0
    col: 1
    width: 22
    height: 8
  - title: Assets with High Severity Findings
    name: Assets with High Severity Findings
    model: gcp_audit_log_man
    explore: findings_log
    type: looker_grid
    fields: [findings_log.count, findings_log.asset_name]
    filters:
      findings_log.severity: 3 - High
    sorts: [findings_log.count desc]
    limit: 10
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
    show_x_axis_label: true
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    listen:
      Source: findings_log.source_display_name
      Event Date: findings_log.event_date
    row: 15
    col: 1
    width: 22
    height: 6
  - title: New Findings by Date
    name: New Findings by Date
    model: gcp_audit_log_man
    explore: findings_log
    type: looker_column
    fields: [findings_log.create_date, findings_log.count]
    fill_fields: [findings_log.create_date]
    filters:
      findings_log.create_date: 30 days
      findings_log.state: ACTIVE
    sorts: [findings_log.create_date desc]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    listen:
      Source: findings_log.source_display_name
      Event Date: findings_log.event_date
    row: 8
    col: 1
    width: 22
    height: 7
  - title: Active Compromised Accounts
    name: Active Compromised Accounts
    model: gcp_audit_log_man
    explore: findings_log
    type: looker_grid
    fields: [findings_log.compromised_account, findings_log.create_date]
    filters:
      findings_log.compromised_account: "-NULL"
      findings_log.state: ACTIVE
    sorts: [findings_log.compromised_account]
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
    show_x_axis_label: true
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    listen: {}
    row: 21
    col: 1
    width: 8
    height: 6
  filters:
  - name: Event Date
    title: Event Date
    type: field_filter
    default_value: 30 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: gcp_audit_log_man
    explore: findings_log
    listens_to_filters: []
    field: findings_log.event_date
  - name: Source
    title: Source
    type: field_filter
    default_value: Security Health Analytics,Web Security Scanner
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: gcp_audit_log_man
    explore: findings_log
    listens_to_filters: []
    field: findings_log.source_display_name
