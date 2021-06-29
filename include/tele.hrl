%% API urls
-define(SEND_MSG_URL, ["https://api.telegram.org/bot","/sendMessage"]).
-define(SET_WEBHOOK_URL, ["https://api.telegram.org/bot","/setWebhook?url="]).

%% System messages
-define(GREETING, <<"Hello! ">>).
-define(ALREADY_REGISTERED, <<"You are already registered!">>).
-define(HELP_MESSAGE, <<
    "/start - getting started \n "
    "/help - information about bot commands \n "
    "/me - information about your current settings \n "
    "/ping - checking connection with the bot \n "
    "/add_key KEYWORD - add keyword to your watchlist \n "
    "/rm_key KEYWORD - remove keyword from your watchlist \n "
    "/watchlist - show your watchlist \n "
>>).
-define(NICK_ADDED, <<"Added to your watchlist: ">>).
-define(NICK_REMOVED, <<"Removed from your watchlist: ">>).
-define(WATCHLIST_IS_CLEAR, <<"Your watchlist is clear">>).
-define(FAILED_GET_WATCHLIST, <<"failed to get watchlist, sry...">>).

