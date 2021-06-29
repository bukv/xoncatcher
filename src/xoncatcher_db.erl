-module(xoncatcher_db).
% API
-export([
    start/0,
    stop/0,
    create/0,
    insert/3,
    lookup/1,
    lookup_all_users_and_watchlists/0
]).

-include("db.hrl").
-include_lib("stdlib/include/qlc.hrl").

create() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(?TABLE_USERS,   [{attributes, record_info(fields, user_data)},{disc_only_copies, [node()]},{record_name, user_data}]),
    mnesia:stop().

start() ->
    mnesia:start(),
    mnesia:wait_for_tables([?TABLE_USERS], 20000).

stop() ->
    mnesia:stop().

insert(UserId, FirstName, WatchList) ->
    Row = #user_data{user_id = UserId, first_name = FirstName, watchlist = WatchList},
    WriteFun = fun() ->
        mnesia:write(?TABLE_USERS, Row, write)
               end,
    {atomic,Status} = mnesia:transaction(WriteFun),
    Status.

lookup(UserId) ->
    F = fun() -> qlc:e(qlc:q([X || X <- mnesia:table(?TABLE_USERS),
        X#user_data.user_id =:= UserId]))
            end,
    {atomic,Result} = mnesia:transaction(F),
    case Result of
        [{_Table, UserId, FirstName, WatchList, IrcNick, SendAll}] ->
            {ok,[UserId, FirstName, WatchList, IrcNick, SendAll]};
        _ ->
            {ok,[]}
    end.

lookup_all_users_and_watchlists() ->
    F = fun() -> qlc:e(qlc:q([{X#user_data.user_id,X#user_data.watchlist} || X <- mnesia:table(?TABLE_USERS)])) end,
    {atomic, ResultList} = mnesia:transaction(F),
    ResultList.
