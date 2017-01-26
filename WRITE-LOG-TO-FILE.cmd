@ECHO OFF
setlocal

REM Заапись лог-файла
REM V 1.0.0 - первая эксплуатационная версия.

REM использование WRITE-LOG-TO-FILE.cmd "сообщение"

REM ==================================================
REM Установка переменных

REM Имя модуля.
SET MODUL_NAME=WRITE-LOG-TO-FILE

REM Каталог запуска скрипта.
SET RUN_DIR=%~dp0

REM Каталог размещения лог-файлов, указывать с завершающим \.
SET LOG_DIR=%RUN_DIR%LOGS\

REM ==================================================
REM Если нет папки для лог-файлов то создадим ее
IF NOT EXIST "%LOG_DIR%" (
MD "%LOG_DIR%" || (
ECHO %date% %time% - ERROR CREATE DIRECTORY "%LOG_DIR%"
)
)

REM ==================================================
REM Генерируем имя лог-файла из текущей даты и времени
set DA=%date%

REM Устраним недопустимые в имени файла символы
set DA=%DA::=-%
set DA=%DA:/=_%
set DA=%DA:\=_%
set DA=%DA:(=%
set DA=%DA:)=%
set DA=%DA:.=_%
set DA=%DA:,=_%
set DA=%DA: =_%
set DA=%DA:'=%
set DA=%DA:"=%
set DA=%DA:_______=_%
set DA=%DA:______=_%
set DA=%DA:_____=_%
set DA=%DA:____=_%
set DA=%DA:___=_%
set DA=%DA:__=_%

REM echo %DA%
SET LOG_FILE_NAME="%LOG_DIR%LOG_%DA%.txt"

REM ==================================================
REM Удалим старые лог-файлы.
IF EXIST "%RUN_DIR%DEL-OLD-LOGS.cmd" (
CALL "%RUN_DIR%DEL-OLD-LOGS.cmd" "%LOG_DIR%" "5" || ECHO %date% %time% - ERROR RUN DEL-OLD-LOGS.cmd
)

REM ==================================================
REM Если сообщение не передано 1-ым параметром коммандной строки, то выход.
IF "%~1"=="" (
ECHO %date% %time% - MESSAGE IS EMPTY
EXIT /B 1
)

REM ==================================================
REM Запись лога в файл, %1 - первый параметр командной строки.
ECHO %date% %time% - %~1 >> %LOG_FILE_NAME% || (
ECHO %date% %time% - Error write file - %LOG_FILE_NAME%
EXIT /B 1
)
EXIT /B 0