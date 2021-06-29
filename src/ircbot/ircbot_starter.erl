-module(ircbot_starter).

%% API
-export([start_ircbot/0]).

-include("xoncatcher.hrl").

start_ircbot() ->
    {ok, Client} = eirc:start_client(mybot, [{bots, [{xoncatcher_ircbot, ircbot_handler, []}]}]),
    {ok, IrcNetwork} = application:get_env(?APPLICATION, irc_network),
    {ok, IrcNetworkPort} = application:get_env(?APPLICATION, irc_network_port),
    {ok, IrcNick} = application:get_env(?APPLICATION, irc_nick),
    {ok, IrcChannel} = application:get_env(?APPLICATION, irc_channel),
    eirc:connect_and_logon(Client, IrcNetwork, IrcNetworkPort, IrcNick),
    timer:sleep(10000),
    eirc:join(Client, IrcChannel),
    {ok, Client}.