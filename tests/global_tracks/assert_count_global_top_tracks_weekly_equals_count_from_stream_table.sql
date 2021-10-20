-- Assert that count of global_top_tracks_weekly equals count of global_top_tracks_weekly_stream records that were 
-- synced most recently

select
    count(*)
from {{ ref('global_top_tracks_weekly') }}
having count(*) != (select count(*)
                    from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.global_top_tracks_weekly_stream
                    where synced_at = (select max(synced_at) from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.global_top_tracks_weekly_stream))