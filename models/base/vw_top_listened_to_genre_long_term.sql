{{ config(materialized='table') }}

with user_top_artists_long_term as (
    select
        * 
    from {{ ref('user_top_artists_long_term')}}
),
genre_counts as (
    {{ genre_array_count() }}
),
final as (
    select
        genre
        , genre_count
    from genre_counts
    order by genre_count desc
)
select * from final