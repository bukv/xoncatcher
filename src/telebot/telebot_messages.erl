-module(telebot_messages).
-author("bukv").

-include("tele.hrl").

%% API
-export([send_message/2]).
-export([send_message_to_all/1]).

send_message(ChatId, MessageText) ->
    Message = [{chat_id, ChatId},{text,MessageText}],
    JsonMessage = jsx:encode(Message),
    Url = string:join(?SEND_MSG_URL, ?TOKEN_API),
    httpc:request(post, {Url, [], "application/json", JsonMessage}, [], []).

send_message_to_all(_MessageText) ->
    ok.