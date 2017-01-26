@ECHO OFF
setlocal

REM Скрипт проверки выходного и праздничного дня
REM V 1.0.0 - первая эксплуатационная версия.

REM ==================================================
REM Установка переменных

REM Имя модуля.
SET MODUL_NAME=CHECK-HOLIDAY

REM Каталог запуска скрипта.
SET RUNDIR=%~dp0

REM ==================================================
ECHO .
ECHO ==================================================
ECHO %date% %time% - START %MODUL_NAME% V 1.0.0

REM ==================================================
REM Пароверим наличие утилиты find
IF NOT EXIST "%windir%/system32/find.exe" (
ECHO %date% %time% - find.exe NOT FOUND
EXIT /B 1
)

REM ==================================================
REM Пароверим наличие утилиты wmic
IF NOT EXIST "%windir%/system32/wbem/wmic.exe" (
ECHO %date% %time% - wmic.exe NOT FOUND
EXIT /B 1
)

REM ==================================================
REM Определим текущий год YYYY
set YYYY=%date:~6,4%
REM set YYYY=2100
IF %YYYY%=="" (
ECHO %date% %time% - WARNING, CANNOT RECOGNIZE CURRENT YEAR
EXIT /B 1
)
ECHO %date% %time% - OK, CURRENT YEAR %YYYY%

REM ==================================================
REM Проверим текущий год YYYY
IF %YYYY% LSS 2017 (
ECHO %date% %time% - WARNING, CURRENT YEAR LSS 2017
EXIT /B 1
)
IF %YYYY% GTR 2099 (
ECHO %date% %time% - WARNING, CURRENT YEAR GTR 2099
EXIT /B 1
)

REM ==================================================
REM Проверка cуществования файла WORKING-DAY_YYYY
IF EXIST "%RUNDIR%WORKING-DAY_%YYYY%.txt" (
ECHO %date% %time% - OK, FILE "%RUNDIR%WORKING-DAY_%YYYY%.txt", EXIST
REM Проверка наличия текущей даты в файле рабочих дней, WORKING-DAY_YYYY
CALL find /i "%date%" "%RUNDIR%WORKING-DAY_%YYYY%.txt" && (
ECHO %date% %time% - DATE %date%, FOUND IN FILE "%RUNDIR%HOLIDAY_%YYYY%.txt", TODAY IS WORKING DAY, OK
EXIT /B 0
)
) ELSE (
ECHO %date% %time% - FILE "%RUNDIR%WORKING-DAY_%YYYY%.txt", NOT FOUND
)

REM ==================================================
REM Проверка cуществования файла HOLIDAY_YYYY
IF EXIST "%RUNDIR%HOLIDAY_%YYYY%.txt" (
ECHO %date% %time% - OK, FILE "%RUNDIR%HOLIDAY_%YYYY%.txt", EXIST
REM Проверка наличия текущей даты в файле праздничных дней, HOLIDAY_YYYY
CALL find /i "%date%" "%RUNDIR%HOLIDAY_%YYYY%.txt" && (
ECHO %date% %time% - DATE %date%, FOUND IN FILE "%RUNDIR%HOLIDAY_%YYYY%.txt", TODAY IS HOLIDAY, EXIT
EXIT /B 1
)
) ELSE (
ECHO %date% %time% - FILE "%RUNDIR%HOLIDAY_%YYYY%.txt", NOT FOUND
)


REM ==================================================
REM Проверим субботу.
CALL wmic path win32_localtime get dayofweek | find "6" && (
ECHO %date% %time% - TODAY IS SATURDAY, EXIT
EXIT /B 1
)

REM ==================================================
REM Проверим воскресенье.
CALL wmic path win32_localtime get dayofweek | find "7" && (
ECHO %date% %time% - TODAY IS SUNDAY, EXIT
EXIT /B 1
)

REM ==================================================
REM Сегодня рабочий день, работаем.
ECHO %date% %time% - TODAY IS WORKING DAY
EXIT /B 0