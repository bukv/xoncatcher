-module(telebot_handler).
-author("bukv").

-include("tele.hrl").

%% API
-export([init/2]).

init(Req0=#{method := <<"POST">>}, State) ->
    {ok, Json, _R} = cowboy_req:read_body(Req0),
    DataFromJson = jsx:decode(Json,[return_maps]),
    message_processing(DataFromJson),
    Req = cowboy_req:reply(200, #{
        <<"content-type">> => <<"text/plain">>
    }, <<"ok">>, Req0),
    {ok, Req, State};
init(Req0, State) ->
    Req = cowboy_req:reply(405, #{
        <<"allow">> => <<"POST">>
    }, Req0),
    {ok, Req, State}.

%% internal functions
message_processing(#{<<"message">> := #{<<"text">> := <<"/start">>, <<"from">> := From}}) ->
    UserId = maps:get(<<"id">>, From),
    UserFirstName = maps:get(<<"first_name">>, From),
    telebot_user_registration:registration_processing(UserId, UserFirstName);

message_processing(#{<<"message">> := #{<<"text">> := <<"/ping">>, <<"from">> := From}}) ->
    UserId = maps:get(<<"id">>, From),
    telebot_messages:send_message(UserId, <<"Pong!">>);

message_processing(#{<<"message">> := #{<<"text">> := <<"/help">>, <<"from">> := From}}) ->
    UserId = maps:get(<<"id">>, From),
    telebot_messages:send_message(UserId, ?HELP_MESSAGE);

message_processing(#{<<"message">> := #{<<"text">> := <<"/watchlist">>, <<"from">> := From}}) ->
    UserId = maps:get(<<"id">>, From),
    case xoncatcher_db:lookup(UserId) of
        {ok,[UserId, _, WatchList, _, _]} ->
            telebot_messages:send_message(UserId, WatchList);
        Response ->
            logger:error("Failed to get watchlist from DB: ~p", [Response]),
            telebot_messages:send_message(UserId, ?FAILED_GET_WATCHLIST)
    end;

message_processing(#{<<"message">> := #{<<"text">> := <<_Head:0/binary, "/add_key "/utf8, Nick/binary>>, <<"from">> := From}}) ->
    UserId = maps:get(<<"id">>, From),
    xoncatcher_watchlist:add_to_watchlist_processing(UserId, Nick);

message_processing(#{<<"message">> := #{<<"text">> := <<_Head:0/binary, "/rm_key "/utf8, Nick/binary>>, <<"from">> := From}}) ->
    UserId = maps:get(<<"id">>, From),
    xoncatcher_watchlist:rm_from_watchlist_processing(UserId, Nick);

message_processing(#{<<"message">> := #{<<"text">> := <<_Head:0/binary, "/to_irc "/utf8, BinMessage/binary>>}}) ->
    Message = binary_to_list(BinMessage),
    xoncatcher_srv:send_message_to_irc(Message);

message_processing(#{<<"message">> := #{<<"text">> := <<"/me">>}}) ->
    Message = <<"ok">>, % TODO get all users settings: irc nick, send all status, watchlist
    xoncatcher_srv:send_message_to_irc(Message);

message_processing(#{<<"message">> := #{<<"from">> := From}}) ->
    UserId = maps:get(<<"id">>, From),
    telebot_messages:send_message(UserId, <<"Uh?">>);

message_processing(Some) ->
    logger:error("Can't process message: ~p", [Some]).
