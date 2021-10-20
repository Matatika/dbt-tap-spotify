-- Assert that all the tracks in user_top_tracks_short_term and user_top_tracks_st_stream, where the synced at
-- is most recent, exisit in both tables.

select
    track_id
from {{ ref('user_top_tracks_short_term') }}
where track_id not in (select id
                    from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.user_top_tracks_st_stream
                    where synced_at = (select max(synced_at) from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.user_top_tracks_st_stream))
union
select
    id
from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.user_top_tracks_st_stream
where synced_at = (select max(synced_at) from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.user_top_tracks_st_stream)
and id not in (select track_id
                    from {{ ref('user_top_tracks_short_term')}})

