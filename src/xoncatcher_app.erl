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
    {ok, _Pid} = cowboy:start_tls(https, [
        {port, 8443},
        {cacertfile, "priv/ssl/cowboy-ca.crt"},
        {certfile, "priv/ssl/server.crt"},
        {keyfile, "priv/ssl/server.key"}
    ], #{env => #{dispatch => Dispatch}}),
    xoncatcher_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
