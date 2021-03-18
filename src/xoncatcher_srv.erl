-module(xoncatcher_srv).
-behaviour(gen_server).

-define(SERVER, ?MODULE).

%% API
-export([
    start_link/0,
    stop/0,
    send_message_to_tele/2,
    register_new_user/2,
    add_to_watchlist/2,
    rm_from_watchlist/2,
    check_new_message/1,
    show_watchlist/1,
    send_message_to_irc/1
]).

%% gen_server callbacks
-export([
    init/1,
    handle_call/3,
    terminate/2,
    code_change/3,
    handle_cast/2,
    handle_info/2
]).

-include("tele.hrl").
-include("irc.hrl").

-record(state, {irc_client}).

stop()  ->
    gen_server:call(?MODULE, stop).

send_message_to_tele(ChatId, Message) ->
    gen_server:call(?MODULE, {send_message_to_tele, ChatId, Message}).

register_new_user(UserId, FirstName) ->
    gen_server:call(?MODULE, {register_new_user, UserId, FirstName}).

add_to_watchlist(UserId, PlayerNick) ->
    gen_server:call(?MODULE, {add_to_watchlist, UserId, PlayerNick}).

rm_from_watchlist(UserId, PlayerNick) ->
    gen_server:call(?MODULE, {rm_from_watchlist, UserId, PlayerNick}).

show_watchlist(UserId) ->
    gen_server:call(?MODULE, {show_watchlist, UserId}).

check_new_message(Message) ->
    gen_server:call(?MODULE, {check_new_message, Message}).

send_message_to_irc(Message) ->
    gen_server:call(?MODULE, {send_message_to_irc, Message}).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init(_Params) ->
    xoncatcher_db:create(),
    xoncatcher_db:start(),
    telebot_starter:set_webhook(),
    {ok, IrcClient} = ircbot_starter:start_ircbot(),
    {ok, #state{irc_client = IrcClient}}.

handle_call({send_message_to_tele, ChatId, Message}, _From, State) ->
    Reply = telebot_messages:send_message(ChatId, Message),
    {reply, Reply, State};

handle_call({register_new_user, UserId, FirstName}, _From, State) ->
    Reply = telebot_user_registration:registration_processing(UserId, FirstName),
    {reply, Reply, State};

handle_call({show_watchlist, UserId}, _From, State) ->
    {ok,[UserId, _, WatchList, _, _]} = xoncatcher_db:lookup(UserId),
    Reply = telebot_messages:send_message(UserId, WatchList),
    {reply, Reply, State};

handle_call({rm_from_watchlist, UserId, PlayerNick}, _From, State) ->
    Reply = xoncatcher_watchlist:rm_from_watchlist_processing(UserId, PlayerNick),
    {reply, Reply, State};

handle_call({add_to_watchlist, UserId, PlayerNick}, _From, State) ->
    Reply = xoncatcher_watchlist:add_to_watchlist_processing(UserId, PlayerNick),
    {reply, Reply, State};

handle_call({check_new_message, Message}, _From, State) ->
    Reply = xoncatcher_watchlist:check_message_processing(Message),
    {reply, Reply, State};

handle_call({send_message_to_irc, Message}, _From, #state{irc_client = IrcClient} = State) ->
    Reply = ircbot_messages:send_message_to_channel(IrcClient, Message),
    {reply, Reply, State};

handle_call(stop, _From, Tab) ->
    {stop, normal, stopped, Tab};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason,  State) ->
    xoncatcher_db:stop(),
    {ok, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

