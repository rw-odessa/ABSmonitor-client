@ECHO OFF
setlocal

REM Проверка наличия нескольких процессов в памяти.
REM V 1.0.0 - первая эксплуатационная версия.

REM ==================================================
REM Установка переменных

REM Имя модуля.
SET MODUL_NAME=CHECK-PROCESSES

REM Каталог запуска скрипта.
SET RUN_DIR=%~dp0

REM Список получателей сообщений.
SET "PROCESSES_LIST=%RUN_DIR%PROCESSES_LIST.txt"

REM ==================================================
REM Если список получателей не найден, то завершаем работу.
IF NOT EXIST "%PROCESSES_LIST%" (
ECHO %date% %time% - MESSAGE RECIPIENTS LIST %PROCESSES_LIST% NOT FOUND
EXIT /B 1
)

REM ==================================================
REM Если список процессов не найден, то завершаем работу.
IF NOT EXIST "%RUN_DIR%CHECK-PROCESS.cmd" (
ECHO %date% %time% - CHECK-PROCESS.cmd NOT FOUND
EXIT /B 1
)

REM ==================================================
REM Читаем список процессов из файла PROCESSES_LIST, и проверяем их наличие.
FOR /F %%G IN (%PROCESSES_LIST%) DO (
CALL "%RUN_DIR%CHECK-PROCESS.cmd" "%%G" || EXIT /B 1
)
EXIT /B 0