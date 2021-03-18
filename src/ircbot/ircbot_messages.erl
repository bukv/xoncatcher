-module(ircbot_messages).

%% API
-export([send_message_to_channel/2]).

-include("irc.hrl").
-include_lib("eirc/include/eirc.hrl").

send_message_to_channel(Client, Message) ->
    eirc_cl:msg(Client, privmsg, ?IRC_CHANNEL, Message).
