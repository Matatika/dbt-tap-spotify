-- Assert that all the tracks in global_viral_tracks_daily and global_viral_tracks_daily_stream, where the synced at
-- is most recent, exisit in both tables.

select
    track_id
from {{ ref('global_viral_tracks_daily') }}
where track_id not in (select id
                    from {{ env_var('DBT_TARGET_SCHEMA') }}.global_viral_tracks_daily_stream
                    where synced_at = (select max(synced_at) from {{ env_var('DBT_TARGET_SCHEMA') }}.global_viral_tracks_daily_stream))
union
select
    id
from {{ env_var('DBT_TARGET_SCHEMA') }}.global_viral_tracks_daily_stream
where synced_at = (select max(synced_at) from {{ env_var('DBT_TARGET_SCHEMA') }}.global_viral_tracks_daily_stream)
and id not in (select track_id
                    from {{ ref('global_viral_tracks_daily')}})
