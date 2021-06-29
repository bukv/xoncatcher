-module(xoncatcher).

%% API
-export([start/0, stop/0]).

-include("xoncatcher.hrl").

start() ->
    {ok, _} = application:ensure_all_started(?APPLICATION, permanent).

stop() ->
    application:stop(?APPLICATION).