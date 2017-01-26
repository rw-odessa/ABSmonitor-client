@ECHO OFF
setlocal enabledelayedexpansion

REM Удаление старых файлов
REM V 1.0.0 - первая эксплуатационная версия.
REM V 1.0.1 - мелкие доработки.
REM V 1.0.2 - добавлена обработка параметров командной строки.

REM ==================================================
REM Установка переменных

REM Имя модуля.
SET MODUL_NAME=DEL-OLD-LOGS

REM Каталог запуска скрипта.
SET RUN_DIR=%~dp0

REM Маска поиска лог-файлов.
SET FILES_TYPE=*log*.txt

REM Каталог размещения лог-файлов.
SET MON_DIR=%~1

REM Сколько файлов лога будем хранить.
SET LIVE_FILES=%~2

REM Если каталог размещения лог-файлов не передан 1-ым параметром коммандной строки, то установим его.
IF "%MON_DIR%"=="" (
SET MON_DIR=%RUN_DIR%
)

REM Если каталог размещения лог-файлов не найден, то завершаем работу.
IF NOT EXIST "%MON_DIR%" (
ECHO %date% %time% - DIRECTORY %MON_DIR% NOT FOUND
EXIT /B 1
)

REM Если количество лог-файлов не передано 2-ым параметром коммандной строки, то установим его.
IF "%LIVE_FILES%"=="" (
SET LIVE_FILES=12
)

REM ==================================================
REM Удаляем самые старые файлы
SET /A FILES_COUNT=0
for /f %%a IN ('dir /o:-d /a:-d /b "%MON_DIR%%FILES_TYPE%"') do (
IF !FILES_COUNT! GEQ %LIVE_FILES% (
DEL /q "%MON_DIR%%%a" || ECHO %date% %time% - ERROR DELETE FILE %%a
)
SET /A FILES_COUNT=FILES_COUNT+1
)
EXIT /B 0