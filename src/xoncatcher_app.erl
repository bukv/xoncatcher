%%%-------------------------------------------------------------------
%% @doc xoncatcher public API
%% @end
%%%-------------------------------------------------------------------

-module(xoncatcher_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", telebot_handler, []}
        ]}
    ]),
    {ok, _Pid} = cowboy:start_clear(http, [{port, 3000}], #{env => #{dispatch => Dispatch}}),
    xoncatcher_db:create(),
    xoncatcher_db:start(),
    telebot_starter:set_webhook(),
    xoncatcher_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
