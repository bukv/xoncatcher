-module(xoncatcher_watchlist).

%% API
-export([add_to_watchlist_processing/2]).
-export([rm_from_watchlist_processing/2]).
-export([check_message_processing/1]).

-include("tele.hrl").
-include("irc.hrl").

add_to_watchlist_processing(UserId, PlayerNick) ->
    insert_into_watchlist(UserId, PlayerNick),
    Message = <<?NICK_ADDED/binary, PlayerNick/binary>>,
    telebot_messages:send_message(UserId, Message).

rm_from_watchlist_processing(UserId, PlayerNick) ->
    remove_from_watchlist(UserId, PlayerNick),
    Message = <<?NICK_REMOVED/binary, PlayerNick/binary>>,
    telebot_messages:send_message(UserId, Message).

check_message_processing(Text) ->
    case is_join_or_part_message(Text) of
        {join,_} ->
            AllWatchlists = xoncatcher_db:lookup_all_users_and_watchlists(),
            find_matching_nicknames(?JOIN_MESSAGE, Text, AllWatchlists);
        {_,part} ->
            AllWatchlists = xoncatcher_db:lookup_all_users_and_watchlists(),
            find_matching_nicknames(?PART_MESSAGE, Text, AllWatchlists);
        {false,false} ->
            ok
    end.


%% Internal functions

is_join_or_part_message(Text) ->
    Join = is_join_message(Text),
    Part = is_part_message(Text),
    {Join,Part}.

insert_into_watchlist(UserId, PlayerNick) ->
    {ok,[UserId, FirstName, OldWatchList, _, _]} = xoncatcher_db:lookup(UserId),
    NewWatchList = [PlayerNick | OldWatchList],
    xoncatcher_db:insert(UserId, FirstName, NewWatchList).

remove_from_watchlist(UserId, PlayerNick) ->
    {ok,[UserId, FirstName, OldWatchList, _, _]} = xoncatcher_db:lookup(UserId),
    NewWatchList = lists:delete(PlayerNick, OldWatchList),
    xoncatcher_db:insert(UserId, FirstName, NewWatchList).

find_matching_nicknames(_MessageType, _Text, []) ->
    ok;

find_matching_nicknames(MessageType, Text, [{UserId,Watchlist} | RestWatchlists]) ->
    lists:foreach(fun(Elem) ->
            Pos = string:rstr(Text, binary_to_list(Elem)),
            case Pos of
                Pos when is_integer(Pos), Pos =/= 0 ->
                    telebot_messages:send_message(UserId, <<MessageType/binary, Elem/binary>>);
                0 ->
                    false;
                Err ->
                    io:format("\n =======> Error find_matching_nicknames: ~p", [Err]),
                    false
            end
                  end, Watchlist),
    find_matching_nicknames(MessageType, Text, RestWatchlists).

is_join_message(Text) ->
    Pos = string:rstr(Text, ?JOIN_IRC_MSG),
    case Pos of
        Pos when is_integer(Pos), Pos =/= 0 ->
            join;
        0 ->
            false;
        Err ->
            io:format("\n =======> Error is_join_message: ~p", [Err]),
            false
    end.

is_part_message(Text) ->
    Pos = string:rstr(Text, ?PART_IRC_MSG),
    case Pos of
        Pos when is_integer(Pos), Pos =/= 0 ->
            part;
        0 ->
            false;
        Err ->
            io:format("\n =======> Error is_part_message: ~p", [Err]),
            false
    end.