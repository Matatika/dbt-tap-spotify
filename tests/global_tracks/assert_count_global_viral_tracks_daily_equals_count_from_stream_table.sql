-- Assert that count of global_viral_tracks_daily equals count of global_viral_tracks_daily_stream

select
    count(*)
from {{ ref('global_viral_tracks_daily') }}
having count(*) != (select count(*)
                    from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.global_viral_tracks_daily_stream)