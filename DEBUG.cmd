@ECHO OFF
setlocal enabledelayedexpansion

REM Запуск программ для отладки в лог файл.
REM V 1.0.0 - первая эксплуатационная версия.

REM==================================================
REM Установка переменных
SET RUNDIR=%~dp0
REM CD "%RUNDIR%"|| ECHO %date% %time% - ERROR CD %RUNDIR%

REM==================================================
REM Запуск программы с записью логов.
REM Здесь исправить имя комадного файла и файла лога.
CALL %RUNDIR%START-MONITOR.cmd >> "%RUNDIR%DEBUG_LOG.txt"

REM==================================================
REM Выход без ошибки.
EXIT /B 0