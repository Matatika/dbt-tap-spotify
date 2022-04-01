{% macro artist_array_pivot(table_name) %}
  {{ return(adapter.dispatch('artist_array_pivot')(table_name)) }}
{% endmacro %}


{% macro default__artist_array_pivot(table_name) %}

    select
        id
        , string_agg(artist_name_string, ', ') as artist_name
    from (select
            id
            , array_to_json(array_agg(items.name)) as artist_name
        from {{ table_name }}, jsonb_to_recordset({{ table_name }}.artists) as items(name text)
        group by id) as t
        , jsonb_array_elements_text(artist_name::jsonb) artist_name_string
    group by id
    
{% endmacro %}


{# postgres should use default #}
{% macro postgres__artist_array_pivot(table_name) %}

    {{ return(default__artist_array_pivot(table_name)) }}

{% endmacro %}



{% macro snowflake__artist_array_pivot(table_name) %}

    select 
        id,
        array_to_string(array_agg(artist.value:name), ', ') as artist_name
    from {{ table_name }}, lateral flatten(input => parse_json("ARTISTS")) as artist
    group by id

{% endmacro %}