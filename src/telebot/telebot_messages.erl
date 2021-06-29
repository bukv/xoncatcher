-module(telebot_messages).
-author("bukv").

-include("tele.hrl").
-include("xoncatcher.hrl").

%% API
-export([send_message/2]).
-export([send_message_to_all/1]).

send_message(ChatId, MessageText) ->
    {ok, TeleTokenApi} = application:get_env(?APPLICATION, telegram_token_api),
    Message = [{chat_id, ChatId},{text,MessageText}],
    JsonMessage = jsx:encode(Message),
    Url = string:join(?SEND_MSG_URL, TeleTokenApi),
    httpc:request(post, {Url, [], "application/json", JsonMessage}, [], []).

send_message_to_all(_MessageText) ->
    ok.