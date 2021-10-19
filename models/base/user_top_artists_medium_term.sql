{{ config(materialized='table') }}

with user_top_artists_medium_term as (
    select * from "{{var('schema')}}".user_top_artists_mt_stream
),
final as (
    select
        id as artist_id
        , name as artist_name
        , genres as genres
        , popularity as popularity
        , followers__total as followers
    from user_top_artists_medium_term
)
select * from final