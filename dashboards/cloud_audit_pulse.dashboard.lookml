- dashboard: cloud_audit_pulse
  title: Cloud Audit Pulse
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Accounts Accessing Many Services in an hour
    name: Accounts Accessing Many Services in an hour
    model: gcp_security
    explore: activity
    type: looker_grid
    fields: [activity.count_services, activity.timestamp_hour, activity_authentication_info.principal_email]
    filters:
      activity.count_services: ">2"
      activity_authentication_info.principal_email: "%@google.com%"
    sorts: [activity.count_services desc]
    limit: 500
    column_limit: 50
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: transparent
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      activity.count_services:
        is_active: true
        palette:
          palette_id: 69808085-f4d1-13f5-262f-c97620a83fe4
          collection_id: google
          custom_colors:
          - "#FBBC04"
          - "#EA8600"
          - "#EA4335"
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#4285F4",
        font_color: !!null '', color_application: {collection_id: google, palette_id: google-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
    x_axis_gridlines: false
    y_axis_gridlines: false
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: bottom, series: [{axisId: activity.count_services,
            id: activity.count_services, name: Services Count}], showLabels: true,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    defaults_version: 1
    hidden_fields: [activity.timestamp_hour]
    note_state: collapsed
    note_display: hover
    note_text: Potential indicator of a hijacked account attempting to gain unauthorized
      access to multiple services.
    listen:
      Date: activity.timestamp_date
    row: 4
    col: 0
    width: 8
    height: 9
  - title: Failed Access Attempts
    name: Failed Access Attempts
    model: gcp_security
    explore: activity
    type: looker_line
    fields: [activity.timestamp_date, activity.service_name, activity.access_denials]
    pivots: [activity.service_name]
    filters:
      activity_authorization_info.granted: 'No'
    sorts: [activity.timestamp_date desc, activity.service_name]
    limit: 500
    query_timezone: America/Los_Angeles
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
    interpolation: monotone
    y_axes: [{label: Failed Access Attempts, orientation: left, series: [{axisId: activity.count,
            id: appengine.googleapis.com - activity.count, name: appengine.googleapis.com},
          {axisId: activity.count, id: compute.googleapis.com - activity.count, name: compute.googleapis.com},
          {axisId: activity.count, id: container.googleapis.com - activity.count,
            name: container.googleapis.com}, {axisId: activity.count, id: k8s.io -
              activity.count, name: k8s.io}, {axisId: activity.count, id: servicemanagement.googleapis.com
              - activity.count, name: servicemanagement.googleapis.com}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: log}]
    hidden_series: [k8s.io - activity.count]
    series_types: {}
    defaults_version: 1
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields: []
    note_state: collapsed
    note_display: hover
    note_text: 'Provides a visual representation of failed attempts per day over a
      time range; helps monitor access trends and identify unusual activity. '
    listen:
      Date: activity.timestamp_date
    row: 4
    col: 8
    width: 16
    height: 9
  - title: Failed Logins
    name: Failed Logins
    model: gcp_security
    explore: activity
    type: looker_map
    fields: [ip_to_geography_lookup.location, activity.count, ip_to_geography_lookup.is_unexpected_country]
    pivots: [ip_to_geography_lookup.is_unexpected_country]
    fill_fields: [ip_to_geography_lookup.is_unexpected_country]
    filters:
      activity.timestamp_date: 2 days
      activity_authorization_info.granted: 'No'
    sorts: [activity.count desc 0, ip_to_geography_lookup.is_unexpected_country desc]
    limit: 500
    query_timezone: America/Los_Angeles
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: dark
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_view_names: false
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    map_marker_radius_min: 200000
    map_marker_radius_max: 600000
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen: {}
    row: 13
    col: 0
    width: 24
    height: 10
  - title: Brute-Force Attacks
    name: Brute-Force Attacks
    model: gcp_security
    explore: failed_logins
    type: single_value
    fields: [failed_logins.brute_force_attacks]
    filters:
      failed_logins.date_filter: 3 weeks
      failed_logins.failed_login_threshold: '5'
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
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen: {}
    row: 0
    col: 18
    width: 6
    height: 4
  - title: Failed Logins
    name: Failed Logins (2)
    model: gcp_security
    explore: activity
    type: single_value
    fields: [activity.access_denials, activity.timestamp_date]
    fill_fields: [activity.timestamp_date]
    filters:
      activity.timestamp_date: 2 days ago for 2 days
    sorts: [activity.timestamp_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: prior_day, label: Prior Day, expression: "(${activity.access_denials}\
          \ - offset(${activity.access_denials}, 1)) / offset(${activity.access_denials},\
          \ 1)", value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Failed Logins Today
    comparison_label: from prior day
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
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen: {}
    row: 0
    col: 0
    width: 6
    height: 4
  - title: "% Failed Logins Today"
    name: "% Failed Logins Today"
    model: gcp_security
    explore: activity
    type: single_value
    fields: [activity.percent_failed_logins]
    filters:
      activity.timestamp_date: 1 days ago for 1 days
    limit: 500
    dynamic_fields: [{table_calculation: failed_logins_today, label: Failed Logins
          Today, expression: "${activity.percent_failed_logins} *353", value_format: !!null '',
        value_format_name: percent_2, _kind_hint: measure, _type_hint: number}, {
        table_calculation: failed_logins_yesterday, label: Failed Logins Yesterday,
        expression: "${activity.percent_failed_logins} * 101", value_format: !!null '',
        value_format_name: percent_2, _kind_hint: measure, _type_hint: number}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    comparison_label: prior day
    hidden_fields: [activity.percent_failed_logins]
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
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    y_axes: []
    listen: {}
    row: 0
    col: 6
    width: 6
    height: 4
  - title: IAM Elevations
    name: IAM Elevations
    model: gcp_security
    explore: setiampolicy_operation
    type: single_value
    fields: [setiampolicy_operation.count, setiampolicy_operation.timestamp_date]
    fill_fields: [setiampolicy_operation.timestamp_date]
    filters:
      setiampolicy_operation.role: roles/iam.serviceAccountKeyAdmin,roles/bigquery.dataEditor,roles/bigquery.dataOwner,roles/owner,roles/editor
      setiampolicy_operation.timestamp_date: 2 days ago for 2 days
    sorts: [setiampolicy_operation.count desc]
    limit: 10
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
    show_null_points: true
    interpolation: linear
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen: {}
    row: 0
    col: 12
    width: 6
    height: 4
  - title: Access Elevations by Day
    name: Access Elevations by Day
    model: gcp_security
    explore: setiampolicy_operation
    type: looker_area
    fields: [setiampolicy_operation.count, setiampolicy_operation.timestamp_date]
    fill_fields: [setiampolicy_operation.timestamp_date]
    filters:
      setiampolicy_operation.role: roles/iam.serviceAccountKeyAdmin,roles/bigquery.dataEditor,roles/bigquery.dataOwner,roles/owner,roles/editor
      setiampolicy_operation.timestamp_date: 30 days
    sorts: [setiampolicy_operation.count desc]
    limit: 10
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
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: monotone
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: Access Elevations, orientation: left, series: [{axisId: setiampolicy_operation.count,
            id: setiampolicy_operation.count, name: Setiampolicy Operation}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    series_colors:
      setiampolicy_operation.count: "#4285F4"
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    ordering: none
    show_null_labels: false
    defaults_version: 1
    hidden_fields: []
    listen: {}
    row: 25
    col: 0
    width: 24
    height: 7
  - title: Critical Elevations by Granter
    name: Critical Elevations by Granter
    model: gcp_security
    explore: setiampolicy_operation
    type: looker_grid
    fields: [setiampolicy_operation.count, setiampolicy_operation.granter_email]
    filters:
      setiampolicy_operation.role: roles/iam.serviceAccountKeyAdmin,roles/bigquery.dataEditor,roles/bigquery.dataOwner,roles/owner,roles/editor
      setiampolicy_operation.timestamp_date: 30 days
    sorts: [setiampolicy_operation.count desc]
    limit: 10
    column_limit: 50
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      setiampolicy_operation.count:
        is_active: true
        palette:
          palette_id: 62603ba7-104f-8023-70ed-cc056cc0be18
          collection_id: google
          custom_colors:
          - "#c9e6ff"
          - "#4285F4"
          - "#185ABC"
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
    show_null_points: true
    interpolation: linear
    hidden_fields: []
    y_axes: []
    listen: {}
    row: 32
    col: 12
    width: 12
    height: 6
  - title: Critical Elevations by Grantee
    name: Critical Elevations by Grantee
    model: gcp_security
    explore: setiampolicy_operation
    type: looker_grid
    fields: [setiampolicy_operation.count, setiampolicy_operation.grantee_email]
    filters:
      setiampolicy_operation.role: roles/iam.serviceAccountKeyAdmin,roles/bigquery.dataEditor,roles/bigquery.dataOwner,roles/owner,roles/editor
      setiampolicy_operation.timestamp_date: 30 days
    sorts: [setiampolicy_operation.count desc]
    limit: 10
    column_limit: 50
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      setiampolicy_operation.count:
        is_active: true
        palette:
          palette_id: 264bbb81-58c9-c942-cce9-21641b2a271e
          collection_id: google
          custom_colors:
          - "#c9e6ff"
          - "#4285F4"
          - "#185ABC"
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
    show_null_points: true
    interpolation: linear
    hidden_fields: []
    y_axes: []
    listen: {}
    row: 32
    col: 0
    width: 12
    height: 6
  - name: <font color="#000000" size="45" weight="bold"><strong> Cloud Audit </strong>
      <font color= "#4285F4"size="45"> IAM Access Elevations </font>
    type: text
    title_text: <font color="#000000" size="4.5" weight="bold"><strong> Cloud Audit
      </strong> <font color= "#4285F4"size="4.5"> IAM Access Elevations </font>
    subtitle_text: ''
    body_text: ''
    row: 23
    col: 0
    width: 24
    height: 2
  filters:
  - name: Date
    title: Date
    type: field_filter
    default_value: 14 day
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
