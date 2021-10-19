{{ config(materialized='table') }}

with user_top_tracks_short_term as (
    select * from "{{var('schema')}}".user_top_tracks_st_stream
),
artist_name_list as (
    select
        id
        , array_to_json(array_agg(items.name)) as artist_name
    from user_top_tracks_short_term uttst, jsonb_to_recordset(uttst.artists) as items(name text)
    group by id
),
final as (
    select
        utt.id as track_id
        , name as track_name
        , artist_name_list.artist_name as artist_name
        , album__album_type as type
        , album__name as album_name
        , popularity as popularity
        , duration_ms as duration_ms
        , explicit as explicit
        , track_number as track_number
        , case when album__release_date_precision = 'day' then album__release_date::date
        when album__release_date_precision = 'month' then to_date(album__release_date::text, 'yyyy-mm')
        when album__release_date_precision = 'year' then to_date(album__release_date::text, 'yyyy')
        else null end as release_date
        , album__release_date_precision as album_release_date_precision
    from user_top_tracks_short_term utt
    left join artist_name_list on artist_name_list.id = utt.id
)
select * from final