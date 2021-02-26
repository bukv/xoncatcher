%%%-------------------------------------------------------------------
%% @doc xoncatcher top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(xoncatcher_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    SupFlags = #{strategy => one_for_one, intensity => 1, period => 5},
    ChildSpecs = [#{id => xoncatcher_srv,
        start => {xoncatcher_srv, start_link, []},
        restart => permanent,
        shutdown => brutal_kill,
        type => worker,
        modules => [xoncatcher_srv]}],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
