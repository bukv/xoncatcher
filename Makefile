PROJECT = xoncatcher
PROJECT_DESCRIPTION = irc2telegram bot
PROJECT_VERSION = 0.0.1

REBAR = ./rebar3

co: compile

compile:
	$(REBAR) compile