@ECHO OFF
setlocal enabledelayedexpansion

REM Скрипт мониторинга лог изменения файла.
REM V 1.0.0 - первая эксплуатационная версия.
REM V 1.0.1 - добавлены коды выхода.
REM V 1.0.2 - доработка кавычек.

REM ==================================================
REM Установка переменных

REM Имя модуля.
SET MODUL_NAME=CHECK-FILE-HANGING

REM Каталог запуска скрипта.
SET RUNDIR=%~dp0

REM Имя файла.
SET FILE_TO_OBSERVE=%~1

REM ==================================================
ECHO .
ECHO ==================================================
ECHO %date% %time% - START %MODUL_NAME% V 1.0.2

REM ==================================================
REM Проверка передачи параметра скрипту
IF "%FILE_TO_OBSERVE%" == "" (
ECHO %date% %time% - WARNING FILE TO OBSERVE IS EMPTY
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING FILE TO OBSERVE IS EMPTY"
EXIT /B 1
)

REM ==================================================
REM Проверка cуществования файла FILE_TO_OBSERVE
IF NOT EXIST "%FILE_TO_OBSERVE%" (
ECHO %date% %time% - WARNING FILE %FILE_TO_OBSERVE% NOT FOUND
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING %FILE_TO_OBSERVE% NOT FOUND"
EXIT /B 1
)
ECHO %date% %time% - OK FILE TO OBSERVE - %FILE_TO_OBSERVE%

REM ==================================================
REM Если нет папки для временных файлов то создадим ее
IF NOT EXIST "%RUNDIR%TEMP" (
MD "%RUNDIR%TEMP" || (
ECHO %date% %time% - ERROR CREATE DIRECTORY "%RUNDIR%TEMP"
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "ERROR CREATE DIRECTORY "%RUNDIR%TEMP""
)
)

REM ==================================================
REM Копируем самые свежие файлы
SET /A FILECOUNT=0
for /f %%a in ('dir /b /s /o:-d "%FILE_TO_OBSERVE%"') do (
ECHO %date% %time% - ===%%a===
if !FILECOUNT! == 1 goto LABEL1
ECHO %date% %time% - START COPY FILE %%a TO %RUNDIR%TEMP\
XCOPY /y /v /z "%%a" "%RUNDIR%TEMP\" || (
ECHO %date% %time% - WARNING ERROR COPY FILE %%a TO %RUNDIR%TEMP\
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING ERROR COPY FILE %%a TO %RUNDIR%TEMP\"
EXIT /B 1
)
SET FILE=%%a
SET /A FILECOUNT=FILECOUNT+1
)
:LABEL1
ECHO %date% %time% - COPY FILE COMPLETE

REM ==================================================
REM Опредилим имя файла.
FOR %%b in ("%FILE%") do (
	REM "SET FILEFULL=%%~fb"
	REM "SET FILEPATH=%%~dpb"
SET "FILEEXT=%%~xb"
SET "FILENAME=%%~nxb"
)    
	REM ECHO %date% %time% - %file% = %filepath% + %filename%
	REM ECHO %date% %time% - FILEEXT = %FILEEXT%

REM ==================================================
REM Если нет предшествующего файла  FILE_TO_OBSERVE_OLD, то создадим его.
REM а если нет файла, значит начат новый день и тогда очистим временную папку
IF NOT EXIST "%RUNDIR%TEMP\%FILENAME%_OLD" (
DEL /Q %RUNDIR%TEMP\*%FILEEXT%_OLD && ECHO %date% %time% - DELETE %RUNDIR%TEMP\*%FILEEXT%_OLD  - OK
COPY NUL "%RUNDIR%TEMP\%FILENAME%_OLD" && ECHO %date% %time% - CREATE FILE "%RUNDIR%TEMP\%FILENAME%_OLD"  - OK
)

REM ==================================================
REM Сравнение файлов
ECHO %date% %time% - FC "%RUNDIR%TEMP\%FILENAME%_OLD" "%RUNDIR%TEMP\%FILENAME%"
FC "%RUNDIR%TEMP\%FILENAME%_OLD" "%RUNDIR%TEMP\%FILENAME%" | find "FC" && (
ECHO %date% %time% - WARNING FILE %FILE% HANGING
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING FILE %FILE% HANGING"
EXIT /B 1
)
ECHO %date% %time% - CHECK FILE %FILE% - OK

REM ==================================================
REM Сохраняем предшествующее состояние файла
COPY /y "%RUNDIR%TEMP\%FILENAME%" "%RUNDIR%TEMP\%FILENAME%_OLD" || (
ECHO %date% %time% - ERROR COPY "%RUNDIR%TEMP\%FILENAME%" TO "%RUNDIR%TEMP\%FILENAME%_OLD"
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "ERROR COPY "%RUNDIR%TEMP\%FILENAME%" TO "%RUNDIR%TEMP\%FILENAME%_OLD"
)
REM Удалим старые файлы
DEL /Q %RUNDIR%TEMP\*%FILEEXT% || (
ECHO %date% %time% - ERROR DELETE %RUNDIR%TEMP\*%FILEEXT%
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "ERROR DELETE %RUNDIR%TEMP\*%FILEEXT%"
)

REM ==================================================
REM Успешный выход
EXIT /B 0