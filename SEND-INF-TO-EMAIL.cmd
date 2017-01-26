@ECHO OFF
setlocal

REM Рассылка сообщений по електронной почте.
REM V 1.0.0 - первая эксплуатационная версия.

REM ==================================================
REM Установка переменных

REM Имя модуля.
SET MODUL_NAME=SEND-INF-TO-NET

REM Каталог запуска скрипта.
SET "RUN_DIR=%~dp0"

REM Статус ообщения.
SET "STATUS=%~1"

REM Сообщение.
SET "MESSAGE=%~2"

REM Список получателей сообщений.
SET "EMAIL_RECIPIENTS=%RUN_DIR%EMAIL_RECIPIENTS.txt"

REM Утилита предачи сообщений.
SET "EMAIL_SEND=%RUN_DIR%mailsend1-16.exe"

REM Каталог размещения лог-файлов.
SET LOG_DIR=%RUN_DIR%

REM Маска поиска лог-файлов.
SET FILES_TYPE=*log*.txt

REM ==================================================
REM Если список получателей не найден, то завершаем работу.
IF NOT EXIST "%EMAIL_RECIPIENTS%" (
ECHO %date% %time% - EMAIL RECIPIENTS LIST %EMAIL_RECIPIENTS% NOT FOUND
EXIT /B 1
)

REM ==================================================
REM Если статуc сообщение не передано 1-ым параметром коммандной строки, то выход.
IF "%STATUS%"=="" (
ECHO %date% %time% - STATUS IS EMPTY
EXIT /B 1
)

REM ==================================================
REM Если сообщение передано 1-ым параметром коммандной строки, значит статус не предавался.
IF "%MESSAGE%"=="" (
SET "MESSAGE=%STATUS%"
SET "STATUS=INFO"
)

REM ==================================================
REM Пароверим наличие утилиты передачи сообщений
IF NOT EXIST "%EMAIL_SEND%" (
ECHO %date% %time% - %EMAIL_SEND% NOT FOUND 
EXIT /B 1
)

REM==================================================
REM Найдем самый свежий лог файл 
for /f %%a IN ('dir /o:-d /a:-d /s /b "%LOG_DIR%%FILES_TYPE%"') do (
SET "LOG_FILE=%%a"
GOTO 1
)

:1 
REM ==================================================
REM Пароверим наличие лог-файла.
IF NOT EXIST "%LOG_FILE%" (
SET "ATTACH="
) ELSE (
ECHO %date% %time% - FOUND LOG-FILE - %LOG_FILE%
SET "ATTACH=-attach %LOG_FILE%,text/plain"
)

REM ==================================================
REM Читаем список получателей из файла MESSAGE_RECIPIENTS, и отправляем им сообщение MESSAGE
FOR /F %%G IN (%EMAIL_RECIPIENTS%) DO (
CALL "%EMAIL_SEND%" -d mtbnet -smtp 10.104.1.4 -t %%G -f INFO@marfinbank.ua -cs "CP866" -sub "%STATUS%" -M "%MESSAGE%" %ATTACH%|| ECHO %date% %time% - ERROR SEND MESSAGE TO %%G
)
EXIT /B 0