-- Assert that count of user_top_artists_long_term equals count of user_top_artists_lt_stream

select
    count(*)
from {{ ref('user_top_artists_long_term') }}
having count(*) != (select count(*)
                    from {{ env_var('TARGET_POSTGRES_SCHEMA') }}.user_top_artists_lt_stream)