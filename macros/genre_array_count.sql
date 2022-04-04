{% macro genre_array_count() %}
  {{ return(adapter.dispatch('genre_array_count')()) }}
{% endmacro %}


{% macro default__genre_array_count() %}

    select
        g.value as genre
        , COUNT(g.value) as genre_count
    from user_top_artists_long_term utast, JSONB_ARRAY_ELEMENTS_TEXT(utast.genres) g
    group by g.value
    
{% endmacro %}


{# postgres should use default #}
{% macro postgres__genre_array_count() %}

    {{ return(default__genre_array_count()) }}

{% endmacro %}



{% macro snowflake__genre_array_count() %}

    select
        g.value as genre
        , count(g.value) as genre_count
    from user_top_artists_long_term utast, lateral flatten(input => parse_json(utast.genres)) g
    group by g.value

{% endmacro %}