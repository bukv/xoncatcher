-module(telebot_starter).

%% API
-export([set_webhook/0]).

-include("tele.hrl").

set_webhook() ->
    Url = string:join(?SET_WEBHOOK_URL, ?TOKEN_API),
    UrlAndParam = Url ++ ?WEBHOOK_ADDRESS,
    Result = httpc:request(get, {UrlAndParam, []}, [], []),
    case Result of
        {ok, RespJson} ->
            io:format("Set webhook result: ~p", [RespJson]);
        {error, Reason} ->
            io:format("Set webhook ERROR: ~p", [Reason])
    end.