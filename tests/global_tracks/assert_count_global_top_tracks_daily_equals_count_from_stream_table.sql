-- Assert that count of global_top_tracks_daily equals count of global_top_tracks_daily_stream

select
    count(*)
from {{ ref('global_top_tracks_daily') }}
having count(*) != (select count(*)
                    from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.global_top_tracks_daily_stream)