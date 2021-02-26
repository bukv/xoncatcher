-record(user_data, {
    user_id,
    first_name,
    watchlist,
    is_admin,
    secret_auth
}).
-define(TABLE_USERS, table_users).