-- Assert that count of global_top_tracks_weekly equals count of global_top_tracks_weekly_stream

select
    count(*)
from {{ ref('global_top_tracks_weekly') }}
having count(*) != (select count(*)
                    from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.global_top_tracks_weekly_stream)