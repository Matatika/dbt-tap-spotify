-- Assert that all the tracks in global_top_tracks_weekly and global_top_tracks_weekly_stream, where the synced at
-- is most recent, exisit in both tables.

select
    track_id
from {{ ref('global_top_tracks_weekly') }}
where track_id not in (select id
                    from {{ env_var('DBT_TARGET_SCHEMA') }}.global_top_tracks_weekly_stream
                    where synced_at = (select max(synced_at) from {{ env_var('DBT_TARGET_SCHEMA') }}.global_top_tracks_weekly_stream))
union
select
    id
from {{ env_var('DBT_TARGET_SCHEMA') }}.global_top_tracks_weekly_stream
where synced_at = (select max(synced_at) from {{ env_var('DBT_TARGET_SCHEMA') }}.global_top_tracks_weekly_stream)
and id not in (select track_id
                    from {{ ref('global_top_tracks_weekly')}})

