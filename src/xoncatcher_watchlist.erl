-module(xoncatcher_watchlist).

%% API
-export([add_to_watchlist_processing/2]).
-export([rm_from_watchlist_processing/2]).
-export([check_message_processing/1]).

-include("tele.hrl").
-include("irc.hrl").

add_to_watchlist_processing(UserId, KeyWord) ->
    insert_into_watchlist(UserId, KeyWord),
    Message = <<?NICK_ADDED/binary, KeyWord/binary>>,
    telebot_messages:send_message(UserId, Message).

rm_from_watchlist_processing(UserId, KeyWord) ->
    remove_from_watchlist(UserId, KeyWord),
    Message = <<?NICK_REMOVED/binary, KeyWord/binary>>,
    telebot_messages:send_message(UserId, Message).

check_message_processing(MessageText) ->
    AllWatchlists = xoncatcher_db:lookup_all_users_and_watchlists(),
    find_matching_keywords(MessageText, AllWatchlists).

%% Internal functions

insert_into_watchlist(UserId, PlayerNick) ->
    {ok,[UserId, FirstName, OldWatchList, _, _]} = xoncatcher_db:lookup(UserId),
    NewWatchList = [PlayerNick | OldWatchList],
    xoncatcher_db:insert(UserId, FirstName, NewWatchList).

remove_from_watchlist(UserId, PlayerNick) ->
    {ok,[UserId, FirstName, OldWatchList, _, _]} = xoncatcher_db:lookup(UserId),
    NewWatchList = lists:delete(PlayerNick, OldWatchList),
    xoncatcher_db:insert(UserId, FirstName, NewWatchList).

find_matching_keywords(_MessageText, []) ->
    ok;

find_matching_keywords(MessageText, [{UserId,Watchlist} | RestWatchlists]) ->
    lists:foreach(fun(Elem) ->
        Pos = string:rstr(MessageText, binary_to_list(Elem)),
        case Pos of
            Pos when is_integer(Pos), Pos =/= 0 ->
                BinMessage = message_to_binary(MessageText),
                telebot_messages:send_message(UserId, BinMessage);
            0 ->
                false;
            Err ->
                io:format("\n =======> Error find_matching_keywords: ~p", [Err]),
                false
        end
                  end, Watchlist),
    find_matching_keywords(MessageText, RestWatchlists).

message_to_binary(MessageText) when is_binary(MessageText) ->
    MessageText;
message_to_binary(MessageText) when is_list(MessageText) ->
    list_to_binary(MessageText);
message_to_binary(_) ->
    <<"!!! Failed message, please contact to administrator">>.