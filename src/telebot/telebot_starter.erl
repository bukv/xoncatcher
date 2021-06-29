-module(telebot_starter).

%% API
-export([set_webhook/0]).

-include("tele.hrl").
-include("xoncatcher.hrl").

set_webhook() ->
    {ok, TeleWebHookAddress} = application:get_env(?APPLICATION, telegram_webhook_address),
    {ok, TeleTokenApi} = application:get_env(?APPLICATION, telegram_token_api),
    Url = string:join(?SET_WEBHOOK_URL, TeleTokenApi),
    UrlAndParam = Url ++ TeleWebHookAddress,
    Result = httpc:request(get, {UrlAndParam, []}, [], []),
    case Result of
        {ok, RespJson} ->
            io:format("Set webhook result: ~p", [RespJson]);
        {error, Reason} ->
            io:format("Set webhook ERROR: ~p", [Reason])
    end.