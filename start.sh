#!/bin/sh

exec erl -args_file env/bot.vmargs -config env/bot.config -pa ebin/ _build/default/lib/*/ebin