@ECHO OFF
setlocal

REM Мониторинг состояния програмных комплексов.
REM V 1.0.0 - первая эксплуатационная версия.

REM ==================================================
REM Установка переменных

REM Имя модуля.
SET PROGRAM_NAME=mtbpro

REM Каталог запуска скрипта.
SET RUN_DIR=%~dp0

REM ==================================================
REM Проверим процесс в памяти
CALL "%RUN_DIR%CHECK-PROCESS.cmd" "%PROGRAM_NAME%" || (
CALL "%RUN_DIR%LOG.cmd" "%PROGRAM_NAME%" "WARNING" "NOT RUNNIG"
EXIT /B 1
)

REM ==================================================
REM Проверим изменение размера лог-файла
REM CALL "%RUN_DIR%CHECK-FILE-SIZE-CHANGES.cmd" "имя лог-файла для мониторинга" || (
REM CALL "%RUN_DIR%LOG.cmd" "%PROGRAM_NAME%" "WARNING" "SIZE OF LOG-FILE NOT CHANGE"
REM EXIT /B 1
REM )

REM ==================================================
REM Проверим наличие изменений лог-файла
REM CALL %RUN_DIR%CHECK-FILE-HANGING.cmd "имя лог-файла для мониторинга" || (
REM CALL "%RUN_DIR%LOG.cmd" "%PROGRAM_NAME%" "WARNING" "LOG-FILE HANGING"
REM EXIT /B 1
REM )


REM ==================================================
REM Проверим наличие сообщениЙ лог-файла
REM CALL "%RUN_DIR%CHECK-FILE-CONTENT.cmd" "имя лог-файла для мониторинга" "сообщение для поиска" && (
REM CALL "%RUN_DIR%LOG.cmd" "%PROGRAM_NAME%" "WARNING" "FOUND ERROR IN LOG"
REM EXIT /B 1
REM )

REM ==================================================
REM Запишем сообщение в лог-файл.
CALL %RUN_DIR%LOG.cmd "%PROGRAM_NAME%" "INFO" "ALL IS WELL"

EXIT /B 0