-- Assert that count of user_top_tracks_short_term equals count of user_top_tracks_st_stream

select
    count(*)
from {{ ref('user_top_tracks_short_term') }}
having count(*) != (select count(*)
                    from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.user_top_tracks_st_stream)