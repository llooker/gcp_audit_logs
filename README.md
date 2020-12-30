### What can I do with this Looker Block?
**(1) Use pre-built dashboards to quickly analyze and alert on GCP Audit log data ** - Dashboards include an Admin Activity overview, an account investigation dashboard, and a dashboard that uses the MITRE ATT&CK framework to view activities that map to attack tactics.

**(2) Easily explore and query GCP Audit Log data ** - This block contains Explores for the Admin Activity and Data Access tables. These Explores allow you to build custom queries, build additional reports and dashboards, and set up threshold alerts on any of these fields or associated metrics.

**(3) Extend the model for further analysis ** - This project is likely a starting point for your own SOC. The model can be extended with metrics specific to your organization on the audit log data. It can also be extended to include analysis of any other log type. Looker can effectively be used as a SIEM tool for historical (vs real-time) analysis. Threshold alerts can be run at 5-minute increments and data can be queried as fast as it is landed in BigQuery.

**(4) Use as part of an Enterprise Data Platform** - Take advantage of Looker's data platform functionality, including [data actions](https://looker.com/platform/actions), scheduling, permissions, alerting, parameterization (each user can only see their own data), and more.


### GCP Security Data Structure

* GCP Audit Logs consist of Admin Activity, Data Access, System Events, and Policy Denied logs. This block is built on the mostlogs commonly used for analytics, Admin Activity and Data Access. Docs on these logs are [found here](https://cloud.google.com/logging/docs/audit).

* Information on sinking logs to BQ HERE (ASJAD)


### Block Structure

* The ``access`` and ``activity`` views are the foundation of this block and the other views are used for supplemental analysis: a derived table for IAM analysis, an IP geo lookup view, and derived tables used to identify failed access attempts followed by a grant. The model file defines some simple explores. This block uses some SQL specific to BQ to unnest and handle structs, arrays, and JSON data.

### What if I find an error? Suggestions for improvements?

Great! Blocks were designed for continuous improvement through the help of the entire Looker community, and we'd love your input. To log an error or improvement recommendations, simply create a "New Issue" in the corresponding [Github repo for this Block](https://github.com/llooker/google_ga360/issues). Please be as detailed as possible in your explanation, and we'll address it as quick as we can.

### Further analysis in consideration for a v2 of this block

* VPC Flow log model and content

* Data Access content

* Other high-value and broadly-applicable analytics use cases we identify in the field

### Notes and Other Known Issues
