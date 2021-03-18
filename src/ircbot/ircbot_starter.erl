-module(ircbot_starter).

%% API
-export([start_ircbot/0]).

-include("irc.hrl").

start_ircbot() ->
    {ok, Client} = eirc:start_client(mybot, [{bots, [{xoncatcher_ircbot, ircbot_handler, []}]}]),
    eirc:connect_and_logon(Client, ?IRC_NETWORK, ?IRC_NETWORK_PORT, ?NICK),
    timer:sleep(10000),
    eirc:join(Client, ?IRC_CHANNEL),
    {ok, Client}.