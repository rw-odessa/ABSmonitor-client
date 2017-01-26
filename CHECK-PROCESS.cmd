@ECHO OFF
setlocal

REM Проверка наличия процесса в памяти.
REM V 1.0.0 - первая эксплуатационная версия.

REM использование CHECK-PROCESS.cmd PROCESS_NAME

REM ==================================================
REM Установка переменных

REM Имя модуля.
SET MODUL_NAME=CHECK-PROCESS

REM Каталог запуска скрипта.
SET RUN_DIR=%~dp0

REM Сообщение.
SET PROCESS_NAME=%~1

REM ==================================================
REM Если сообщение не передано 1-ым параметром коммандной строки, то выход.
IF "%PROCESS_NAME%"=="" (
ECHO %date% %time% - PROCESS NAME IS EMPTY
EXIT /B 1
)

REM ==================================================
REM Пароверим наличие утилиты tasklist
IF NOT EXIST "%windir%/system32/tasklist.exe" (
ECHO %date% %time% - tasklist.exe NOT FOUND
EXIT /B 1
)

REM ==================================================
REM Пароверим наличие утилиты find
IF NOT EXIST "%windir%/system32/find.exe" (
ECHO %date% %time% - find.exe NOT FOUND
EXIT /B 1
)

REM ==================================================
REM Проверка существования процесса в памяти.
CALL "%windir%/system32/tasklist.exe" /NH /FI "IMAGENAME eq %PROCESS_NAME%.exe" | "%windir%/system32/find.exe" /I "%PROCESS_NAME%.exe" && (
ECHO %date% %time% - FOUND PROCESS %PROCESS_NAME%
EXIT /B 0
)

REM ==================================================
REM Если процесса в памяти не найдено.
ECHO %date% %time% - PROCESS %PROCESS_NAME% NOT FOUND
EXIT /B 1