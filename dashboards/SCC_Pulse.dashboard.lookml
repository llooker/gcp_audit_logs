- dashboard: scc_pulse
  title: SCC Pulse
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
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
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: false
    table_theme: transparent
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '16'
    rows_font_size: '16'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      findings_log.create_date: Compromised Date
    series_column_widths:
      findings_log.compromised_account: 838
      findings_log.create_date: 208
    header_font_color: ''
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
    hidden_fields: []
    hidden_points_if_no: []
    columnOrder: {}
    listen: {}
    row: 17
    col: 2
    width: 20
    height: 4
  - title: Malware
    name: Malware
    model: gcp_audit_log_man
    explore: findings_log
    type: single_value
    fields: [findings_log.count, findings_log.category]
    filters:
      findings_log.state: ACTIVE
      findings_log.category: 'Malware: Bad IP'
    sorts: [findings_log.count desc]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Malware
    conditional_formatting: [{type: greater than, value: 0, background_color: "#EA4335",
        font_color: "#030101", color_application: {collection_id: google, palette_id: google-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}, {type: equal
          to, value: 0, background_color: '', font_color: "#137333", color_application: {
          collection_id: google, palette_id: google-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    row: 2
    col: 2
    width: 4
    height: 4
  - title: IAM Abuse
    name: IAM Abuse
    model: gcp_audit_log_man
    explore: findings_log
    type: single_value
    fields: [findings_log.count, findings_log.category]
    filters:
      findings_log.state: ACTIVE
      findings_log.category: 'Persistence: IAM Anomalous Grant'
    sorts: [findings_log.count desc]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: ''
    conditional_formatting: [{type: greater than, value: 0, background_color: "#EA4335",
        font_color: "#000000", color_application: {collection_id: google, palette_id: google-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
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
    row: 2
    col: 18
    width: 4
    height: 4
  - title: Bruteforce SSH
    name: Bruteforce SSH
    model: gcp_audit_log_man
    explore: findings_log
    type: single_value
    fields: [findings_log.count, findings_log.category]
    filters:
      findings_log.state: ACTIVE
      findings_log.category: 'Brute Force: SSH'
    sorts: [findings_log.count desc]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: ''
    conditional_formatting: [{type: greater than, value: 0, background_color: "#EA4335",
        font_color: "#080808", color_application: {collection_id: google, palette_id: google-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
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
    note_state: collapsed
    note_display: above
    listen:
      Source: findings_log.source_display_name
    row: 6
    col: 6
    width: 4
    height: 4
  - title: Leaked Credentials
    name: Leaked Credentials
    model: gcp_audit_log_man
    explore: findings_log
    type: single_value
    fields: [findings_log.count, findings_log.category]
    filters:
      findings_log.state: ACTIVE
      findings_log.category: '"account_has_leaked_credentials"'
    sorts: [findings_log.count desc]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Leaked Credentials
    conditional_formatting: [{type: greater than, value: 0, background_color: "#EA4335",
        font_color: "#030303", color_application: {collection_id: google, palette_id: google-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
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
    row: 6
    col: 18
    width: 4
    height: 4
  - title: Cryptomining
    name: Cryptomining
    model: gcp_audit_log_man
    explore: findings_log
    type: single_value
    fields: [findings_log.count]
    filters:
      findings_log.state: ACTIVE
      findings_log.category: cryptomining
    sorts: [findings_log.count desc]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: ''
    conditional_formatting: [{type: greater than, value: 0, background_color: "#EA4335",
        font_color: "#050505", color_application: {collection_id: google, palette_id: google-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
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
    row: 2
    col: 6
    width: 4
    height: 4
  - title: IAM UEBA
    name: IAM UEBA
    model: gcp_audit_log_man
    explore: findings_log
    type: single_value
    fields: [findings_log.count]
    filters:
      findings_log.state: ACTIVE
      findings_log.category: cryptomining
    sorts: [findings_log.count desc]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: ''
    conditional_formatting: [{type: greater than, value: 0, background_color: "#EA4335",
        font_color: "#000000", color_application: {collection_id: google, palette_id: google-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
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
    row: 2
    col: 14
    width: 4
    height: 4
  - title: Outgoing DoS
    name: Outgoing DoS
    model: gcp_audit_log_man
    explore: findings_log
    type: single_value
    fields: [findings_log.count]
    filters:
      findings_log.state: ACTIVE
      findings_log.category: cryptomining
    sorts: [findings_log.count desc]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: ''
    conditional_formatting: [{type: greater than, value: 0, background_color: "#EA4335",
        font_color: "#030303", color_application: {collection_id: google, palette_id: google-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
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
    row: 6
    col: 2
    width: 4
    height: 4
  - title: To Exit Node Access
    name: To Exit Node Access
    model: gcp_audit_log_man
    explore: findings_log
    type: single_value
    fields: [findings_log.count]
    filters:
      findings_log.state: ACTIVE
      findings_log.category: cryptomining
    sorts: [findings_log.count desc]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: ''
    conditional_formatting: [{type: greater than, value: 0, background_color: "#EA4335",
        font_color: "#000000", color_application: {collection_id: google, palette_id: google-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
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
    row: 6
    col: 10
    width: 4
    height: 4
  - title: BQ Data Exfil
    name: BQ Data Exfil
    model: gcp_audit_log_man
    explore: findings_log
    type: single_value
    fields: [findings_log.count]
    filters:
      findings_log.state: ACTIVE
      findings_log.category: cryptomining
    sorts: [findings_log.count desc]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: ''
    conditional_formatting: [{type: greater than, value: 0, background_color: "#EA4335",
        font_color: "#000000", color_application: {collection_id: google, palette_id: google-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
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
    row: 6
    col: 14
    width: 4
    height: 4
  - title: New Tile
    name: New Tile
    model: gcp_audit_log_man
    explore: findings_log
    type: single_value
    fields: [findings_log.scc_logo]
    sorts: [findings_log.scc_logo]
    limit: 500
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_view_names: false
    defaults_version: 1
    series_types: {}
    listen: {}
    row: 2
    col: 10
    width: 4
    height: 4
  - title: New Threats by Date
    name: New Threats by Date
    model: gcp_audit_log_man
    explore: findings_log
    type: looker_column
    fields: [findings_log.create_date, findings_log.count, findings_log.category]
    pivots: [findings_log.category]
    fill_fields: [findings_log.create_date]
    filters:
      findings_log.create_date: 30 days
      findings_log.state: ACTIVE
      findings_log.source_display_name: Cloud Anomaly Detection,Event Threat Detection
    sorts: [findings_log.create_date desc, findings_log.category]
    limit: 500
    column_limit: 50
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#000000"
    color_application:
      collection_id: google
      palette_id: google-categorical-0
      options:
        steps: 5
    y_axes: [{label: Findings, orientation: left, series: [{axisId: 'Brute Force:
              SSH - findings_log.count', id: 'Brute Force: SSH - findings_log.count',
            name: 'Brute Force: SSH'}, {axisId: 'Malware: Bad IP - findings_log.count',
            id: 'Malware: Bad IP - findings_log.count', name: 'Malware: Bad IP'},
          {axisId: 'Persistence: IAM Anomalous Grant - findings_log.count', id: 'Persistence:
              IAM Anomalous Grant - findings_log.count', name: 'Persistence: IAM Anomalous
              Grant'}], showLabels: true, showValues: true, minValue: 0.09, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types: {}
    series_colors: {}
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen: {}
    row: 10
    col: 2
    width: 20
    height: 7
  - name: '<font color="#000000" size="45" weight="bold"><strong> Security Command
      Center </strong> <font color= "#4285F4"size="45"> Vulnerabilities </font> '
    type: text
    title_text: '<font color="#000000" size="4.5" weight="bold"><strong> Security
      Command Center </strong> <font color= "#4285F4"size="4.5"> Vulnerabilities </font> '
    subtitle_text: ''
    body_text: ''
    row: 21
    col: 2
    width: 20
    height: 2
  - name: <font color="#000000" size="45" weight="bold"><strong> Security Command
      Center </strong> <font color= "#4285F4"size="45"> Threats </font>
    type: text
    title_text: <font color="#000000" size="4.5" weight="bold"><strong> Security Command
      Center </strong> <font color= "#4285F4"size="4.5"> Threats </font>
    subtitle_text: ''
    body_text: ''
    row: 0
    col: 2
    width: 20
    height: 2
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
    default_value: Event Threat Detection,Cloud Anomaly Detection
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: gcp_audit_log_man
    explore: findings_log
    listens_to_filters: []
    field: findings_log.source_display_name
