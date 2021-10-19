-- Assert that count of user_top_tracks_medium_term equals count of user_top_tracks_mt_stream

select
    count(*)
from {{ ref('user_top_tracks_medium_term') }}
having count(*) != (select count(*)
                    from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.user_top_tracks_mt_stream)