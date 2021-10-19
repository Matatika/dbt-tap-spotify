{{ config(materialized='table') }}

with global_viral_tracks_daily as (
    select * from "{{var('schema')}}".global_viral_tracks_daily_stream
),
artist_name_list as (
    select
        id
        , array_to_json(array_agg(items.name)) as artist_name
    from global_viral_tracks_daily gvtd, jsonb_to_recordset(gvtd.artists) as items(name text)
    group by id
),
final as (
    select
        gvtd.id as track_id
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
    from global_viral_tracks_daily gvtd
    left join artist_name_list on artist_name_list.id = gvtd.id
)
select * from final