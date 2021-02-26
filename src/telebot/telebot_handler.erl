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
    xoncatcher_srv:register_new_user(UserId, UserFirstName);

message_processing(#{<<"message">> := #{<<"text">> := <<"/ping">>, <<"from">> := From}}) ->
    UserId = maps:get(<<"id">>, From),
    xoncatcher_srv:send_message_to_tele(UserId, <<"Pong!">>);

message_processing(#{<<"message">> := #{<<"text">> := <<"/help">>, <<"from">> := From}}) ->
    UserId = maps:get(<<"id">>, From),
    xoncatcher_srv:send_message_to_tele(UserId, ?HELP_MESSAGE);

message_processing(#{<<"message">> := #{<<"text">> := <<"/watchlist">>, <<"from">> := From}}) ->
    UserId = maps:get(<<"id">>, From),
    xoncatcher_srv:show_watchlist(UserId);

message_processing(#{<<"message">> := #{<<"text">> := <<_Head:0/binary, "/add_nick "/utf8, Nick/binary>>, <<"from">> := From}}) ->
    UserId = maps:get(<<"id">>, From),
    xoncatcher_srv:add_to_watchlist(UserId, Nick);

message_processing(#{<<"message">> := #{<<"text">> := <<_Head:0/binary, "/rm_nick "/utf8, Nick/binary>>, <<"from">> := From}}) ->
    UserId = maps:get(<<"id">>, From),
    xoncatcher_srv:rm_from_watchlist(UserId, Nick);

message_processing(#{<<"message">> := #{<<"from">> := From}}) ->
    UserId = maps:get(<<"id">>, From),
    xoncatcher_srv:send_message_to_tele(UserId, <<"Uh?">>);

message_processing(Some) ->
    io:format("\n~p",[Some]).
