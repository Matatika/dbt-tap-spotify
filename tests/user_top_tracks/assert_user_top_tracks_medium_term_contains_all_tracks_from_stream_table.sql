-- Assert that all the tracks in user_top_tracks_medium_term and user_top_tracks_mt_stream exisit in both tables.

select
    track_id
from {{ ref('user_top_tracks_medium_term') }}
where track_id not in (select id
                    from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.user_top_tracks_mt_stream)
union
select
    id
from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.user_top_tracks_mt_stream
where id not in (select track_id
                    from {{ ref('user_top_tracks_medium_term')}})

