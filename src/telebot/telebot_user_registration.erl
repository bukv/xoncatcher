-module(telebot_user_registration).

%% API
-export([registration_processing/2]).

-include("tele.hrl").

registration_processing(UserId, FirstName) ->
    case xoncatcher_db:lookup(UserId) of
        {ok,[]} ->
            start_registration(UserId, FirstName);
        {ok,[UserId, FirstName, _, _, _]} ->
            telebot_messages:send_message(UserId, ?ALREADY_REGISTERED);
        Err ->
            io:format("\nError registration_processing: ~p", [Err])
    end.

%% Internal functions

start_registration(UserId, FirstName) ->
    Status = xoncatcher_db:insert(UserId, FirstName, []),
    io:format("\nRegistration ~p, result: ~p", [UserId, Status]),
    Message = <<?GREETING/binary, FirstName/binary>>,
    telebot_messages:send_message(UserId, Message),
    telebot_messages:send_message(UserId, ?HELP_MESSAGE).