-- Assert that count of user_top_tracks_medium_term equals count of user_top_tracks_mt_stream records that were 
-- synced most recently

select
    count(*)
from {{ ref('user_top_tracks_medium_term') }}
having count(*) != (select count(*)
                    from {{ env_var('DBT_TARGET_SCHEMA') }}.user_top_tracks_mt_stream
                    where synced_at = (select max(synced_at) from {{ env_var('DBT_TARGET_SCHEMA') }}.user_top_tracks_mt_stream))