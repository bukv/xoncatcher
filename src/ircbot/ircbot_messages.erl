-module(ircbot_messages).

%% API
-export([send_message_to_channel/2]).

-include_lib("eirc/include/eirc.hrl").
-include("xoncatcher.hrl").

send_message_to_channel(Client, Message) ->
    {ok, IrcChannel} = application:get_env(?APPLICATION, irc_channel),
    eirc_cl:msg(Client, privmsg, IrcChannel, Message).
