%% Telegram-bot config
-define(WEBHOOK_ADDRESS, "").              % https://some-address.net
-define(TOKEN_API, "").   % your bot token API

%% API urls
-define(SEND_MSG_URL, ["https://api.telegram.org/bot","/sendMessage"]).
-define(SET_WEBHOOK_URL, ["https://api.telegram.org/bot","/setWebhook?url="]).

%% System messages
-define(GREETING, <<"Hello! ">>).
-define(ALREADY_REGISTERED, <<"You are already registered!">>).
-define(HELP_MESSAGE, <<
    "/start - getting started \n "
    "/help - information about bot commands \n "
    "/ping - checking connection with the bot \n "
    "/add_nick NICK - add nick to your watchlist \n "
    "/rm_nick NICK - remove nick from your watchlist \n "
    "/watchlist - show your watchlist \n "
>>).
-define(NICK_ADDED, <<"Added to your watchlist: ">>).
-define(NICK_REMOVED, <<"Removed from your watchlist: ">>).
-define(JOIN_MESSAGE, <<"+ join: ">>).
-define(PART_MESSAGE, <<"- part: ">>).

