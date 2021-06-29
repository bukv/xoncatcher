XONCATCHER
=====
Небольшой бот, отправляющий уведомления в telegram, когда на сервер Xonotic заходят игроки, которые находятся в списке для отслеживания.

Нужные события достаются из лога в IRC канале, связанном с игровым сервером. 
Так что по сути, это irc2telegram бот.
__________________________
![example_1.png](https://raw.githubusercontent.com/bukv/xoncatcher/master/screenshots/example_1.png "Bot interface")
__________________________

Конфиг
-----
В env/bot.config следует указать

- IRC сеть (irc_network)
- Порт IRC сервера (irc_network_port)
- Канал, на который зайдет бот (irc_channel)
- Ник бота (irc_nick)
- Токен телеграм бота (telegram_token_api)
- Вебхук адрес для телеграма (telegram_webhook_adress)

В данный момент бот не поддерживает работу через https (необходимо телеграму для вебхука), поэтому можно воспользоваться ngrok для проброса сервиса в интернет.

Сборка
-----

    $ make
_Рекомендуется использовать Erlang/OTP 23_

Запуск
-----

    $ ./start.sh

Сторонние библиотеки, использованные в проекте
-----
- https://github.com/mazenharake/eirc
- https://github.com/talentdeficit/jsx
- https://github.com/ninenines/cowboy
