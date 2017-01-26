@ECHO OFF
setlocal

REM Скрипт проверки выходного и праздничного дня
REM V 1.0.0 - первая эксплуатационная версия.

REM ==================================================
REM Установка переменных

REM Имя модуля.
SET MODUL_NAME=CHECK-WORKING-HOURS

REM Каталог запуска скрипта.
SET RUNDIR=%~dp0

REM Рабочее время.
SET START_TIME=8
SET END_TIME=18

REM ==================================================
ECHO .
ECHO ==================================================
ECHO %date% %time% - START %MODUL_NAME% V 1.0.0

REM ==================================================
REM Определим текущее время
set HH=%time:~0,2%
REM set HH=3
IF %HH%=="" (
ECHO %date% %time% - WARNING, CANNOT RECOGNIZE CURRENT TIME
EXIT /B 1
)
ECHO %date% %time% - OK, CURRENT HOUR %HH%

REM ==================================================
REM Определим текущее время
IF %HH% LSS %START_TIME% (
ECHO %date% %time% - WARNING, CURRENT TIME LSS %START_TIME%
EXIT /B 1
)
IF %HH% GTR %END_TIME% (
ECHO %date% %time% - WARNING, CURRENT TIME GTR %END_TIME%
EXIT /B 1
)

REM ==================================================
REM Сегодня рабочий день, работаем.
ECHO %date% %time% - OK, NOW IS WORKING TIME
EXIT /B 0