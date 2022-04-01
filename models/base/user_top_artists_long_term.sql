{{ config(materialized='table') }}

with user_top_artists_long_term as (
    select
        * 
    from {{ source('spotify_source', 'user_top_artists_lt_stream')}}
    where synced_at = (select max(synced_at) from {{ source('spotify_source', 'user_top_artists_lt_stream')}})
),
final as (
    select
        id as artist_id
        , rank as rank
        , name as artist_name
        , genres as genres
        , popularity as popularity
        , followers__total as followers
    from user_top_artists_long_term
)
select * from final