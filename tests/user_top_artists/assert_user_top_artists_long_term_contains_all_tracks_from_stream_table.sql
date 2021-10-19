-- Assert that all the artists in user_top_artists_long_term and user_top_artists_lt_stream exisit in both tables.

select
    artist_id
from {{ ref('user_top_artists_long_term') }}
where artist_id not in (select id
                    from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.user_top_artists_lt_stream)
union
select
    id
from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.user_top_artists_lt_stream
where id not in (select artist_id
                    from {{ ref('user_top_artists_long_term')}})
