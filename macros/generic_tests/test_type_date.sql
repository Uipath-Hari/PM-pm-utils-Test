{% macro test_type_date(model, column_name, table, column) %}

select *
from Information_schema.Columns
where Information_schema.Columns."TABLE_SCHEMA" = '{{ var("schema") }}'
    and Information_schema.Columns."TABLE_NAME" = {{ table }}
    and Information_schema.Columns."COLUMN_NAME" = {{ column }}
{% if target.type == 'snowflake' %}
    and Information_schema.Columns."DATA_TYPE" <> 'DATE'
{% elif target.type == 'sqlserver' %}
    and Information_schema.Columns."DATA_TYPE" <> 'date'
{% endif %}

{% endmacro %}
