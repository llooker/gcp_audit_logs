**Disclaimer:** This analysis is written in BigQuery. Some SQL functions may need to be altered if you are using a different dialect. The goal of this article is to give you the necessary building blocks so that you can implement this within your Looker instance.

## Summary

**Problem:**

**Dataset:** Our dataset has four columns: Login Time, Service Name, User Email, and Login Granted (Y/N). Your data may vary depending on what logs you are collecting but we will use these four columns as the basis of our anaysis.

**Solution:** Using a derived table with user inputs (parameters), we can construct a query to help identify security threats. Scheduling this query to alert you when certain criteria are met can help you stay on top of your security threats without having to manually check logs.

Our solution uses four [CTEs](https://www.essentialsql.com/introduction-common-table-expressions-ctes/) to calculate all of the necessary fields needed to identify threats. Below, we will dissect each CTE used in our analysis.

## CTE Breakdown

**rank_logins CTE:** The first CTE in our derived table is used to calculate two new columns, Login Rank and Login Grant Rank.

<details>
  <summary>Click to expand!</summary>

    rank_login_sq AS (
      SELECT
      activity.activity_timestamp AS activity_timestamp_date,
      activity.service_name AS service_name,
      activity.principal_email AS principal_email,
      activity.granted,
      ROW_NUMBER() OVER(PARTITION BY activity.principal_email ORDER BY activity.principal_email, activity.activity_timestamp, activity.service_name) AS login_rank,
      ROW_NUMBER() OVER(PARTITION BY activity.principal_email, activity.service_name, granted ORDER BY activity.principal_email,activity.activity_timestamp,activity.service_name) AS login_grant_rank

      from ${security_logs.SQL_TABLE_NAME} AS activity

      -- Only include logins for a given timeframe (variable that user needs to input)
      WHERE CAST(activity.activity_timestamp AS TIMESTAMP) >= {% date_start date_filter %} AND CAST(activity.activity_timestamp AS TIMESTAMP ) < {% date_end date_filter %}
      -- OPTIONAL - only included users with a certain email
      -- AND   authentication_info.principalEmail LIKE '%@google.com'
      GROUP BY 1,2,3,4
      ORDER BY 3,5)

</details>

1. Login Rank - What number login is this for a given user? This rank is cumulative as time progresses and increases by one each login regardless of whether or not the user had a successful login.
2. Login Grant Rank - What number login is this for a given user but paritioned by whether or not it was a successful login. Again, this rank increases by one for each new login but in this case we rank the successful logins separately from the unsuccessful logins.

Both of these ranks are calculated using the [ROW_NUMBER](https://cloud.google.com/bigquery/docs/reference/standard-sql/numbering_functions#row_number) number function from BigQuery.

Using [date parameters](https://docs.looker.com/reference/liquid-variables#usage_of_date_start_and_date_end), we will grab the start and end date based on a user's filter selection to only capture logs within a given timeframe. This timeframe can be relative (last 24 hours) or absolute (between 2020-10-01 and 2020-10-15).

There is an optional filter if you'd only like to capture logs from certain users (e.g. only look at logs for users with an @company.com email).

**conseq_logins CTE:** Our second CTE in our derived table is used to calculate one new column, Conseq Login Rank

[details="Conseq Logins CTE"]
conseq_logins AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY principal_email, service_name, granted, login_rank - login_grant_rank ORDER BY principal_email,login_rank) AS conseq_login_rank
FROM rank_logins
ORDER BY principal_email, login_rank
)
[/details]

1. Conseq Login Rank - How many cumulative logins is this for a given user and service assuming we start the count over whenever we switch between a successful and unsuccessful login (and vice-versa). If you have four successful logins following by three unsuccessful logins following by two successful logins, we would rank these: 1, 2, 3, 4, 1, 2, 3, 1, 2

Again, we use the ROW_NUMBER number function from BigQuery to calculate this.

**login_facts CTE:** Our third CTE in our derived table is used to calculate two new "facts" about our logins, Max Granted Login Time and Max # of Failed Consecutive Logins

[details="Login Facts CTE"]
login_facts AS (
SELECT
principal_email,
service_name,
MAX(CASE WHEN granted='Yes' THEN activity_timestamp_date ELSE NULL END) AS max_granted_timestamp_date,
MAX(CASE WHEN granted='No' THEN conseq_login_rank ELSE NULL END) as max_not_granted_rank
FROM conseq_logins
GROUP BY 1,2
)
[/details]

1. Max Granted Login Time - When was our last successful login (within the given timeframe from the first CTE)?
2. Max # of Failed Consecutive Logins - What was the max number of consequetive unsuccessful logins?

These columns are calculated for a given user and service.

**max_failed_login CTE:** The last CTE in our derived table is used to calculate one new column, Max Failed Login Time

[details="Max Failed Login CTE"]
max_failed_login AS (
SELECT
conseq_logins.principal_email,
conseq_logins.service_name,
MAX(CASE WHEN max_not_granted_rank = conseq_login_rank AND granted = 'No' THEN activity_timestamp_date ELSE NULL END) as max_not_granted_timestamp_date
FROM conseq_logins
LEFT JOIN login_facts ON login_facts.principal_email = conseq_logins.principal_email AND login_facts.service_name = conseq_logins.service_name
GROUP BY 1, 2
)
[/details]

1. Max Failed Login Time - What is the max time associated with the most consecutive failed logins. Note: This is not just our most recent failed login time. We specifically want the max time associated with the max number of consecutive unsuccessful logins.

This column is calculated for a given user and service.

## Putting It All Together

Now that we have all of the necessary calculations, we will join the CTEs together to complete our analysis. In this final table, we will add a few filters to ensure we only pull back security threats that are relevant.

1. Filter for events where the max successful login time is greater than the max failed login time. We only want to capture those events where an individual was able to gain access to our system after several unsuccessful logins.
2. Filter for failed logins above our threshold. One of the filters required for this analysis is a failed_login_threshold. This tells us how many consecutive failed logins are required before we consider something to be suspicious. For example, if you set this threshold at five, the analysis will only return events that had at least five failed logins in a row for a given service and where there was a successful login after that fifth (or higher) unsuccessful login.

[details="Failed Logins Derived Table"]
include: "/views/**/*.view"

view: failed_logins {
  derived_table: {
    sql:
     -- Create a temp table that has all logins by date, service, and email and number/rank them by date
    and date, granted per user
      WITH rank_logins AS (
       SELECT
         activity.activity_timestamp AS activity_timestamp_date,
         activity.service_name AS service_name,
         activity.principal_email AS principal_email,
         activity.granted,
         ROW_NUMBER() OVER(PARTITION BY activity.principal_email ORDER BY activity.principal_email,
      activity.activity_timestamp, activity.service_name) AS login_rank,
           ROW_NUMBER() OVER(PARTITION BY activity.principal_email, activity.service_name, granted
      ORDER BY activity.principal_email,activity.activity_timestamp,activity.service_name) AS
        login_grant_rank
      from ${security_logs.SQL_TABLE_NAME} AS activity

      -- Only include logins for a given timeframe (variable that user needs to input)
      WHERE CAST(activity.activity_timestamp AS TIMESTAMP) >= {% date_start date_filter %} AND CAST(activity.activity_timestamp AS TIMESTAMP ) < {% date_end date_filter %}
      -- OPTIONAL - only included users with a certain email
      -- AND   authentication_info.principalEmail LIKE '%@google.com'
      GROUP BY 1,2,3,4
      ORDER BY 3,5),

      -- Working off above temp table, rank/number subsequent logins split by successful and unsuccessful logins.
      conseq_logins AS
      (
          SELECT *,
            ROW_NUMBER() OVER(PARTITION BY principal_email, service_name, granted, login_rank - login_grant_rank ORDER BY principal_email,login_rank) AS conseq_login_rank
          FROM rank_logins
          ORDER BY principal_email, login_rank
      ),

      -- get last successful and unsuccessful login
      login_facts AS (
        SELECT
          principal_email,
          service_name,
          MAX(CASE WHEN granted='Yes' THEN activity_timestamp_date ELSE NULL END) AS latest_successful_login,
          MAX(CASE WHEN granted='No' THEN conseq_login_rank ELSE NULL END) as max_not_granted_rank
        FROM conseq_logins
        GROUP BY 1,2
            ),

      max_failed_login AS (
        SELECT
          conseq_logins.principal_email,
          conseq_logins.service_name,
          MAX(CASE WHEN max_not_granted_rank = conseq_login_rank AND granted = 'No' THEN activity_timestamp_date ELSE NULL END) as max_failed_login_time
        FROM conseq_logins
        LEFT JOIN login_facts ON login_facts.principal_email = conseq_logins.principal_email AND login_facts.service_name = conseq_logins.service_name
        GROUP BY 1, 2

      )
      -- select all relevant data from above temp tables
      SELECT
        conseq_logins.activity_timestamp_date AS activity_timestamp_date_time,
        conseq_logins.service_name  AS service_name,
        conseq_logins.principal_email  AS principal_email,
        conseq_logins.granted AS granted,
        conseq_logins.login_rank  AS login_rank,
        conseq_logins.login_grant_rank  AS login_grant_rank,
        conseq_logins.conseq_login_rank,
        login_facts.latest_successful_login AS max_granted_time,
        max_failed_login.max_failed_login_time AS max_not_granted_time,
        login_facts.max_not_granted_rank as max_not_granted_rank

      FROM conseq_logins
      LEFT JOIN login_facts ON login_facts.principal_email = conseq_logins.principal_email AND login_facts.service_name = conseq_logins.service_name
      LEFT JOIN max_failed_login ON max_failed_login.principal_email = conseq_logins.principal_email AND max_failed_login.service_name = conseq_logins.service_name

      -- Only keep users/attemps where we had a successful login last (didnt end on a string of unsuccessful logins)
      WHERE login_facts.latest_successful_login >= max_failed_login.max_failed_login_time
      -- Make sure that successful login was within our timeframe that we want
      AND (login_facts.latest_successful_login ) >= {% date_start date_filter %} AND (login_facts.latest_successful_login ) < {% date_end date_filter %}
      -- add in a threshold for number of consecutive failed login attemps
      AND login_facts.max_not_granted_rank >= {% parameter failed_login_threshold %}

      GROUP BY 1,2,3,4,5,6,7,8,9,10
      ORDER BY 3,5;;
  }

  filter: date_filter {
    type: date
  }

  parameter: failed_login_threshold {
    type: number
    default_value: "2"
  }


  dimension_group: activity_timestamp_date_time {
    type: time
    timeframes: [millisecond, time, hour, date, month, quarter, year]
    sql: CAST(${TABLE}.activity_timestamp_date_time AS TIMESTAMP) ;;
  }

  dimension: service_name {
    type: string
    sql: ${TABLE}.service_name ;;
  }

  dimension: principal_email {

    type: string
    sql: ${TABLE}.principal_email ;;
  }

  dimension: granted {
    type: string
    sql: CASE WHEN ${TABLE}.granted = 'Yes' THEN 'Granted'
      ELSE 'Denied' END ;;
    html:
       {% if value == 'Granted' %}
        <div style="background: #8BC34A; border-radius: 2px; color: #fff; display: inline-block; font-size:
     11px; font-weight: bold; line-height: 1; padding: 3px 4px; width: 100%; text-align: center;">{{
      rendered_value }}</div>
       {% elsif value == 'Denied' %}
        <div style="background:  #FF0000; border-radius: 2px; color: #fff; display: inline-block; font-size:
     11px; font-weight: bold; line-height: 1; padding: 3px 4px; width: 100%; text-align: center;">{{
     rendered_value }}</div>
        {% endif %} ;;

    }

    dimension: conseq_login_rank  {
      type: number
      sql: ${TABLE}.conseq_login_rank ;;
    }
    dimension: login_rank {
      type: number
      sql: ${TABLE}.login_rank ;;
    }

    dimension: login_grant_rank {
      type: number
      sql: ${TABLE}.login_grant_rank ;;
    }

    dimension_group: max_granted_time {
      type: time
      sql: CAST(${TABLE}.max_granted_time AS TIMESTAMP) ;;
    }

    dimension_group: max_not_granted_time {
      type: time
      sql: CAST(${TABLE}.max_not_granted_time AS TIMESTAMP) ;;
    }

    dimension: max_not_granted_rank {
      label: "Max # of Consecutive Denies"
      type: number
      sql: ${TABLE}.max_not_granted_rank ;;
    }
  }

  [/details]




