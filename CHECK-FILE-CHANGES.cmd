@ECHO OFF
setlocal enabledelayedexpansion

REM Скрипт мониторинга изменения файла.
REM V 1.0.3 - убран вызов SEND-INF-TO-NET.cmd 
REM V 1.0.2 - исправлена ошибка удаления 
REM V 1.0.1 - применена операция CD "%RUNDIR%"
REM V 1.0.0 - первая эксплуатационная версия.

REM ==================================================
REM Установка переменных

REM Имя модуля.
SET MODUL_NAME=CHECK-FILE-CHANGES

REM Каталог запуска скрипта.
SET RUNDIR=%~dp0

REM Файл для наблюдения.
SET FILE_TO_OBSERVE=%~1

REM ==================================================
ECHO %date% %time% - START %CHECK-FILE-CHANGES% V 1.0.3

REM ==================================================
REM Смена каталога на текущий.
CD "%RUNDIR%"|| ECHO %date% %time% - ERROR CD %RUNDIR%

REM ==================================================
REM Проверка передачи параметра скрипту
IF "%FILE_TO_OBSERVE%" == "" (
ECHO %date% %time% - WARNING FILE TO OBSERVE IS EMPTY
EXIT /B 1
)

REM ==================================================
REM Проверка cуществования файла FILE_TO_OBSERVE
IF NOT EXIST "%FILE_TO_OBSERVE%" (
ECHO %date% %time% - WARNING FILE %FILE_TO_OBSERVE% NOT FOUND
EXIT /B 1
)
ECHO %date% %time% - OK FILE TO OBSERVE - %FILE_TO_OBSERVE%

REM ==================================================
REM Если нет папки для временных файлов то создадим ее
IF NOT EXIST .\OLD_FILES (
MD .\OLD_FILES || (
ECHO %date% %time% - ERROR CREATE DIRECTORY ".\TEMP"
EXIT /B 1
)
)

REM ==================================================
REM Если нет папки для временных файлов то создадим ее
IF NOT EXIST .\TMP_FILES (
MD .\TMP_FILES || (
ECHO %date% %time% - ERROR CREATE DIRECTORY .\TMP_FILES
EXIT /B 1
)
)

REM ==================================================
REM Копируем самые свежие файлы.
XCOPY /y /v /z "%FILE_TO_OBSERVE%" ".\TMP_FILES\" || (
ECHO %date% %time% - WARNING ERROR COPY FILE "%FILE_TO_OBSERVE%" TO ".\TMP_FILES\"
EXIT /B 1
)
ECHO %date% %time% - COPY FILE "%FILE_TO_OBSERVE%" TO ".\TMP_FILES\" COMPLETE

REM ==================================================
REM Выбрем один самый свежий файл.
SET /A FILECOUNT=0
for /f %%a in ('dir /b /o:-d ".\TMP_FILES\"') do (
REM ECHO %date% %time% - ===%%a===
if !FILECOUNT! == 1 goto LABEL1
SET FILENAME=%%a
SET /A FILECOUNT=FILECOUNT+1
)
:LABEL1

REM ==================================================
REM Проверка FILENAME
IF "%FILENAME%"=="" (
ECHO %date% %time% - WARNING FILENAME IS EMPTY
EXIT /B 1
)

REM ==================================================
REM Если нет предшествующего файла  %FILENAME%_OLD, то создадим его.
IF NOT EXIST ".\OLD_FILES\%FILENAME%_OLD" (
COPY NUL ".\OLD_FILES\%FILENAME%_OLD" && ECHO %date% %time% - CREATE FILE ".\OLD_FILES\%FILENAME%_OLD"  - OK
)

REM ==================================================
REM Сравнение файлов
SET FILE_CHANGED=1
ECHO %date% %time% - FC ".\OLD_FILES\%FILENAME%_OLD" ".\TMP_FILES\%FILENAME%"
FC ".\OLD_FILES\%FILENAME%_OLD" ".\TMP_FILES\%FILENAME%" | find "FC" && (
ECHO %date% %time% - CHANGES IN FILE %FILENAME% NOT FOUND
SET FILE_CHANGED=0
)

REM ==================================================
REM Сохраняем предшествующее состояние файла
COPY /y ".\TMP_FILES\%FILENAME%" ".\OLD_FILES\%FILENAME%_OLD" || (
ECHO %date% %time% - ERROR COPY ".\TMP_FILES\%FILENAME%" TO ".\OLD_FILES\%FILENAME%_OLD"
)
REM Удалим временные файлы
	REM DEL /Q ".\TMP_FILES\*" || (
DEL /Q ".\TMP_FILES\%FILENAME%" || (
ECHO %date% %time% - ERROR DELETE ".\TMP_FILES\%FILENAME%"
)

REM ==================================================
REM Выход
IF "%FILE_CHANGED%" == "0" EXIT /B 1
ECHO %date% %time% - FOUND CHANGES IN FILE %FILE%
EXIT /B 0