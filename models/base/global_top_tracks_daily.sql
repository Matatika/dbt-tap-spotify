{{ config(materialized='table') }}

with global_top_tracks_daily as (
    select 
        * 
    from "{{var('schema')}}".global_top_tracks_daily_stream
    where synced_at = (select max(synced_at) from "{{var('schema')}}".global_top_tracks_daily_stream)
),
artist_name_list as (
    select
        id
        , array_to_json(array_agg(items.name)) as artist_name
    from global_top_tracks_daily gttw, jsonb_to_recordset(gttw.artists) as items(name text)
    group by id
),
artist_name_list_to_string as (
    select
        id
        , string_agg(artist_name_string, ', ') as artist_name
    from artist_name_list, jsonb_array_elements_text(artist_name::jsonb) artist_name_string
    group by id
),
final as (
    select
        rank as rank
        , gttw.id as track_id
        , name as track_name
        , artist_name_list_to_string.artist_name as artist_name
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
    from global_top_tracks_daily gttw
    left join artist_name_list_to_string on artist_name_list_to_string.id = gttw.id
)
select * from final