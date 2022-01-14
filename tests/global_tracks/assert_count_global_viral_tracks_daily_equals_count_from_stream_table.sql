-- Assert that count of global_viral_tracks_daily equals count of global_viral_tracks_daily_stream records that were 
-- synced most recently

select
    count(*)
from {{ ref('global_viral_tracks_daily') }}
having count(*) != (select count(*)
                    from {{ env_var('DBT_TARGET_SCHEMA') }}.global_viral_tracks_daily_stream
                    where synced_at = (select max(synced_at) from {{ env_var('DBT_TARGET_SCHEMA') }}.global_viral_tracks_daily_stream))