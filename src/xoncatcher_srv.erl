-module(xoncatcher_srv).
-behaviour(gen_server).

-define(SERVER, ?MODULE).

%% API
-export([
    start_link/0,
    stop/0,
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

-record(state, {irc_client}).

stop()  ->
    gen_server:call(?MODULE, stop).

send_message_to_irc(Message) ->
    gen_server:call(?MODULE, {send_message_to_irc, Message}).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init(_Params) ->
    {ok, IrcClient} = ircbot_starter:start_ircbot(),
    {ok, #state{irc_client = IrcClient}}.

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

