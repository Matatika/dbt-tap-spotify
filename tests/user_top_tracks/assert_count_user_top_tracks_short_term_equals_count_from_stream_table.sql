-- Assert that count of user_top_tracks_short_term equals count of user_top_tracks_st_stream records that were 
-- synced most recently

select
    count(*)
from {{ ref('user_top_tracks_short_term') }}
having count(*) != (select count(*)
                    from {{ env_var('DBT_TARGET_SCHEMA') }}.user_top_tracks_st_stream
                    where synced_at = (select max(synced_at) from {{ env_var('DBT_TARGET_SCHEMA') }}.user_top_tracks_st_stream))