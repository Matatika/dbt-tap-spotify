-- Assert that all the tracks in global_top_tracks_daily and global_top_tracks_daily_stream exisit in both tables.

select
    track_id
from {{ ref('global_top_tracks_daily') }}
where track_id not in (select id
                    from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.global_top_tracks_daily_stream)
union
select
    id
from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.global_top_tracks_daily_stream
where id not in (select track_id
                    from {{ ref('global_top_tracks_daily')}})

