-- macros/my_macros.sql

{% macro calculate_workdays(start_datetime, end_datetime, workday_start, workday_end) %}
  {{
    config(
      materialized='view',
      unique='false',
      tags=['workday_calculation']
    )
  }}

  WITH date_time_range AS (
    SELECT
      CONVERT(DATETIME, '{{ start_datetime }}') AS start_datetime,
      CONVERT(DATETIME, '{{ end_datetime }}') AS end_datetime
  )

  SELECT
    start_datetime,
    end_datetime,
    DATEDIFF(DAY, start_datetime, end_datetime) + 1
    - DATEDIFF(WEEK, start_datetime, end_datetime) * 2
    - CASE
        WHEN DATENAME(DW, start_datetime) = 'Sunday' THEN 1
        WHEN DATENAME(DW, end_datetime) = 'Saturday' THEN 1
      ELSE 0 END
      * (CASE WHEN DATEDIFF(DAY, start_datetime, end_datetime) >= 0 THEN 1 ELSE -1 END) -- Adjust sign based on direction
      * (
        (
          DATEDIFF(HOUR, 
            CASE WHEN CAST(start_datetime AS TIME) < workday_start THEN CAST(DATEADD(DAY, DATEDIFF(DAY, 0, start_datetime), 0) AS DATETIME) + CAST(workday_start AS DATETIME)
            ELSE start_datetime
          END,
            CASE WHEN CAST(end_datetime AS TIME) > workday_end THEN CAST(DATEADD(DAY, DATEDIFF(DAY, 0, end_datetime), 0) AS DATETIME) + CAST(workday_end AS DATETIME)
            ELSE end_datetime
          END
        ) / 24
      ) / CAST((workday_end - workday_start) AS FLOAT)
      AS workdays
  FROM date_time_range
{% endmacro %}
