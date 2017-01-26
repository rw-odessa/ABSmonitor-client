@ECHO OFF
setlocal

REM Рассылка сообщений по сети.
REM V 1.0.0 - первая эксплуатационная версия.

REM ==================================================
REM Установка переменных

REM Имя модуля.
SET MODUL_NAME=DEL-OLD-LOGS

REM Каталог запуска скрипта.
SET RUN_DIR=%~dp0

REM Сообщение.
SET MESSAGE=%~1

REM Список получателей сообщений.
SET "MESSAGE_RECIPIENTS=%RUN_DIR%MESSAGE_RECIPIENTS.txt"

REM Утилита предачи сообщений.
SET NET_SEND=net.exe

REM ==================================================
REM Если список получателей не найден, то завершаем работу.
IF NOT EXIST "%MESSAGE_RECIPIENTS%" (
ECHO %date% %time% - MESSAGE RECIPIENTS LIST %MESSAGE_RECIPIENTS% NOT FOUND
EXIT /B 1
)

REM ==================================================
REM Если сообщение не передано 1-ым параметром коммандной строки, то выход.
IF "%MESSAGE%"=="" (
ECHO %date% %time% - MESSAGE IS EMPTY
EXIT /B 1
)

REM ==================================================
REM Пароверим наличие утилиты передачи сообщений
IF NOT EXIST "NET_SEND" (
ECHO %date% %time% - %NET_SEND% NOT FOUND 
EXIT /B 1
)

REM ==================================================
REM Читаем список получателей из файла MESSAGE_RECIPIENTS, и отправляем им сообщение MESSAGE
FOR /F %%G IN (%MESSAGE_RECIPIENTS%) DO (
net.exe send %%G "%MESSAGE%" || ECHO %date% %time% - ERROR SEND MESSAGE TO %%G
)

EXIT /B 0