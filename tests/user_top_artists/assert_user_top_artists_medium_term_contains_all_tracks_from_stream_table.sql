-- Assert that all the artists in user_top_artists_medium_term and user_top_artists_mt_stream, where the synced at
-- is most recent, exisit in both tables.

select
    artist_id
from {{ ref('user_top_artists_medium_term') }}
where artist_id not in (select id
                    from {{ env_var('DBT_TARGET_SCHEMA') }}.user_top_artists_mt_stream
                    where synced_at = (select max(synced_at) from {{ env_var('DBT_TARGET_SCHEMA') }}.user_top_artists_mt_stream))
union
select
    id
from {{ env_var('DBT_TARGET_SCHEMA') }}.user_top_artists_mt_stream
where synced_at = (select max(synced_at) from {{ env_var('DBT_TARGET_SCHEMA') }}.user_top_artists_mt_stream)
and id not in (select artist_id
                    from {{ ref('user_top_artists_medium_term')}})

