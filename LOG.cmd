@ECHO OFF
setlocal

REM Регистрация событий.
REM V 1.0.0 - первая эксплуатационная версия.

REM использование LOG.cmd "MESSAGE_SOURCE" "STATUS" "MESSAGE"

REM ==================================================
REM Установка переменных

REM Имя модуля.
SET MODUL_NAME=LOG

REM Каталог запуска скрипта.
SET RUN_DIR=%~dp0

REM Источник сообщение.
SET MESSAGE_SOURCE=%~1

REM Сообщение.
SET STATUS=%~2

REM Сообщение.
SET MESSAGE=%~3

REM ==================================================
REM Если источник сообщения не передан 1-ым параметром коммандной строки, то выход.
IF "%MESSAGE_SOURCE%"=="" (
ECHO %date% %time% - %MODUL_NAME%, MESSAGE SOURCE IS EMPTY
EXIT /B 1
)

REM ==================================================
REM Если статус сообщения не передан 2-ым параметром коммандной строки, то выход.
IF "%STATUS%"=="" (
ECHO %date% %time% - %MODUL_NAME%, STATUS IS EMPTY
EXIT /B 1
)

REM ==================================================
REM Проверка допустимости статуса.
for %%A in ("ERROR" "WARNING" "INFO" "error" "warning" "info") do if "%STATUS%"==%%A GOTO NEXT
ECHO %date% %time% - %MODUL_NAME%, STATUS %STATUS% NOT ALLOWED, SET STATUS = INFO
SET "STATUS=INFO" || EXIT /B 1

:NEXT
REM ==================================================
REM Если сообщение не передано 3-им параметром коммандной строки, то выход.
IF "%MESSAGE%"=="" (
ECHO %date% %time% - %MODUL_NAME%, MESSAGE IS EMPTY
EXIT /B 1
)

IF NOT EXIST "%RUN_DIR%WRITE-LOG-TO-FILE.cmd" (
ECHO %date% %time% - %MODUL_NAME%, %RUN_DIR%WRITE-LOG-TO-FILE.cmd NOT EXIST
)

REM ==================================================
REM Выбор сценария работы в зависимости от статуса сообщения.
IF "%STATUS%"=="ERROR" GOTO ERROR
IF "%STATUS%"=="error" GOTO ERROR
IF "%STATUS%"=="WARNING" GOTO WARNING
IF "%STATUS%"=="warning" GOTO WARNING
IF "%STATUS%"=="INFO" GOTO INFO
IF "%STATUS%"=="info" GOTO INFO

:ERROR
REM ==================================================
REM Отправка сообщение на почту.
CALL "%RUN_DIR%SEND-INF-TO-EMAIL.cmd" "%STATUS%" "%MESSAGE%" || (
ECHO %date% %time% - %MODUL_NAME%, ERROR CALL %RUN_DIR%SEND-INF-TO-EMAIL.cmd
)

:WARNING
REM ==================================================
REM Отправка сообщение по сети.
CALL "%RUN_DIR%SEND-INF-TO-NET.cmd" "%STATUS% - %MESSAGE%" || (
ECHO %date% %time% - %MODUL_NAME%, ERROR CALL %RUN_DIR%SEND-INF-TO-NET.cmd
)

:INFO
REM ==================================================
REM Показать сообщение в консоли.
ECHO %date% %time% - %MESSAGE_SOURCE% %STATUS% %MESSAGE%

REM ==================================================
REM Записать сообщение в лог-файл.
CALL "%RUN_DIR%WRITE-LOG-TO-FILE.cmd" "%MESSAGE_SOURCE%, %STATUS%, %MESSAGE%" || (
ECHO %date% %time% - %MODUL_NAME%, ERROR CALL WRITE-LOG-TO-FILE.cmd
)

REM ==================================================
REM Отправка сообщения на сервер.
call cscript.exe "%RUN_DIR%SEND-INF-TO-SERVER.js" "http://10.104.4.43:8080/?program=%MESSAGE_SOURCE%&status=%STATUS%&message=%MESSAGE%" || (
ECHO %date% %time% - %MODUL_NAME%, ERROR CALL cscript.exe %RUN_DIR%SEND-INF-TO-SERVER.js
REM CALL WRITE-LOG-TO-FILE.cmd "%MODUL_NAME%, ERROR CALL cscript.exe"
)

EXIT /B 0