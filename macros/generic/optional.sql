{%- macro optional(relation, optional_column, data_type) -%}

{# When the relation is not defined (optional tables), set the columns and relation to empty #}
{%- if load_relation(relation) is none -%}
    {%- set columns = [] -%}
    {%- set relation = null -%}
{%- else -%}
    {%- set columns = adapter.get_columns_in_relation(relation) -%}
{%- endif -%}

{# Create list of column names.#}
{%- set column_names = [] -%}
{%- for column in columns -%}
    {%- set column_names = column_names.append(column.name) -%}
{%- endfor -%}

{# When the column is in the list, use the column, otherwise create the column with null values.#}
{%- if optional_column in column_names -%}
    {% set column_value = optional_column -%}
{%- else -%}
    {% set column_value = 'null' -%}
{%- endif -%}

{%- if data_type == 'boolean' -%}
    {{ pm_utils.to_boolean(column_value, relation) }}
{%- elif data_type == 'date' -%}
    {{ pm_utils.to_date(column_value, relation) }}
{%- elif data_type == 'double' -%}
    {{ pm_utils.to_double(column_value, relation) }}
{%- elif data_type == 'integer' -%}
    {{ pm_utils.to_integer(column_value, relation) }}
{%- elif data_type == 'time' -%}
    {{ pm_utils.to_time(column_value, relation) }}
{%- elif data_type == 'datetime' -%}
    {{ pm_utils.to_timestamp(column_value, relation) }}
{%- elif data_type == 'text' -%}
    {{ pm_utils.to_varchar(column_value) }}
{%- elif data_type == 'id' -%}
    {% if optional_column in column_names %}
        {{ pm_utils.to_integer(column_value, relation) }}
    {% else %}
        row_number() over (order by (select null))
    {% endif%}
{%- else -%}
    {{ pm_utils.to_varchar(column_value) }}
{%- endif -%}

{%- endmacro -%}
