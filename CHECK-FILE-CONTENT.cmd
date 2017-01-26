@ECHO OFF
setlocal enabledelayedexpansion

REM Скрипт мониторинга содержимого лог файлов.
REM V 1.0.0 - первая эксплуатационная версия.

REM использование CHECK-LOG-FILE-CONTENT.cmd "имя файла" "сообщение для поиска"

REM ==================================================
ECHO .
ECHO ==================================================
ECHO %date% %time% - START CHECK-LOG-FILE-CONTENT V 1.0.0

REM ==================================================
REM Установка переменных
SET RUNDIR=%~dp0
	REM SET FILE_TO_OBSERVE="O:\DWH\IMPORT\LOG\Full.20*.log"
SET FILE_TO_OBSERVE=%1
	REM SET MESSAGE="[NBU_01_MTB]\#01"
SET MESSAGE=%2

REM ==================================================
REM Проверка передачи параметра скрипту
IF %FILE_TO_OBSERVE% == "" (
ECHO %date% %time% - WARNING FILE TO OBSERVE IS EMPTY
EXIT /B 1
)

REM ==================================================
REM Проверка передачи параметра скрипту
IF %MESSAGE% == "" (
ECHO %date% %time% - WARNING MESSAGE IS EMPTY
EXIT /B 1
)
ECHO %date% %time% - OK MESSAGE - %MESSAGE%

REM ==================================================
REM Проверка cуществования файла FILE_TO_OBSERVE
IF NOT EXIST "%FILE_TO_OBSERVE%" (
ECHO %date% %time% - WARNING FILE %FILE_TO_OBSERVE% NOT FOUND
EXIT /B 1
)
ECHO %date% %time% - OK FILE TO OBSERVE - %FILE_TO_OBSERVE%


REM ==================================================
REM Проверка наличия MESSAGE
SET /A FILECOUNT=0
for /f %%a IN ('dir /o:-d %FILE_TO_OBSERVE% /b /s') do (
if !FILECOUNT!==1 goto LABEL1
ECHO %date% %time% - CHECK FILE %%a
FIND /i %MESSAGE% %%a && (
ECHO %date% %time% - %MESSAGE% FOUND IN FILE %%a
EXIT /B 0
)
SET /A FILECOUNT=FILECOUNT+1
REM ECHO FILECOUNT - %FILECOUNT%
)
:LABEL1

ECHO %date% %time% - %MESSAGE% NOT FOUND
EXIT /B 1