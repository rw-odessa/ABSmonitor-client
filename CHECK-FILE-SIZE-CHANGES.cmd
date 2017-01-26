@ECHO OFF
setlocal

REM Проверка изменения размера файла.
REM V 1.0.0 - первая эксплуатационная версия

REM использование CHECK-FILE-SIZE-CHANGES.cmd ".\test.txt"
REM использование CHECK-FILE-SIZE-CHANGES.cmd ".\test.*"
REM использование CHECK-FILE-SIZE-CHANGES.cmd ".\*test.*"

REM ==================================================
REM Установка переменных

REM Имя модуля.
SET MODUL_NAME=CHECK-FILE-SIZE-CHANGES

REM Каталог запуска скрипта.
SET RUNDIR=%~dp0

REM Имя файла.
SET FILE=%~1

REM Временная папка.
SET TEMPDIR=%RUNDIR%TEMP-FOR-SIZE\

REM ==================================================
ECHO .
ECHO %date% %time% - START %MODUL_NAME% V 1.0.0

REM ==================================================
REM Проверка передачи параметра скрипту
IF "%~1"=="" (
ECHO %date% %time% - WARNING COMMAND LINE PARAMETER 1 IS EMPTY
EXIT /B 1
)

REM ==================================================
REM Копируем если задан не файл а маска, найдем самый свежий файл.
SET /A FILECOUNT=0
for /f %%a in ('dir /b /o:-d "%FILE%"') do (
ECHO %date% %time% - OK, FOUND FILE %%a
SET FILE=%%a
if !FILECOUNT! == 1 goto NEXT
SET /A FILECOUNT=FILECOUNT+1
)
:NEXT

REM ==================================================
REM Проверка cуществования файла
IF NOT EXIST "%FILE%" (
ECHO %date% %time% - WARNING, FILE %FILE% NOT FOUND
EXIT /B 1
)
ECHO %date% %time% - OK, FILE EXIST, %FILE%

REM ==================================================
REM Опредилим имя файла, каталог, расширение.
	REM FOR /F "usebackq" %%b IN ('%FILE%') DO (
FOR /F %%b in ("%FILE%") do (
	REM SET FILEFULL=%%~fb
	REM SET FILEPATH=%%~dpb
	REM SET FILEEXT=%%~xb
SET FILENAME=%%~nxb
SET FILESIZE=%%~zb
)    
	REM ECHO %date% %time% - %file% = %filepath% + %filename%
	REM ECHO %date% %time% - FILEEXT = %FILEEXT%
	REM ECHO %date% %time% - FILEPATH = %FILEPATH%
	REM ECHO FILESIZE %FILE% = %FILESIZE%

REM ==================================================
REM Проверка правильности опредиления размера файла.
IF "%FILESIZE%" == "" (
ECHO %date% %time% - WARNING, FILESIZE IS EMPTY
EXIT /B 1
)

IF %FILESIZE% == 0  (
ECHO %date% %time% - WARNING, FILESIZE %FILE% = 0
	REM EXIT /B 1
)

REM ==================================================
REM Проверка правильности опредиления имени файла.
IF "%FILENAME%" == "" (
ECHO %date% %time% - WARNING, FILENAME IS EMPTY
EXIT /B 1
)

REM ==================================================
REM Если нет папки для временных файлов то создадим ее
IF NOT EXIST "%TEMPDIR%" (
MD "%TEMPDIR%" || (
ECHO %date% %time% - ERROR CREATE DIRECTORY "%TEMPDIR%"
EXIT /B 1
)
)

REM ==================================================
REM Получить старый размера файла
SET OLDFILESIZE=0
IF EXIST "%TEMPDIR%%FILENAME%" (
SET /p OLDFILESIZE=<"%TEMPDIR%%FILENAME%" || (
ECHO %date% %time% - ERROR, CANNOT READ FILE %TEMPDIR%%FILENAME%
)
)

REM ==================================================
REM Сохранить текущий размера файла
ECHO %FILESIZE% > "%TEMPDIR%%FILENAME%" || (
ECHO %date% %time% - ERROR, CANNOT WRITE FILE %TEMPDIR%%FILENAME%
EXIT /B 1
)

REM ==================================================
REM Проверка размера файла
IF %FILESIZE% LEQ %OLDFILESIZE% (
ECHO %date% %time% - WARNING, FILESIZE OF %FILE% = %FILESIZE% , BUT SHOULD BE GREATER THAN %OLDFILESIZE%
EXIT /B 1
)
ECHO %date% %time% - OK, FILESIZE OF %FILE% = %FILESIZE% GREATER THAN %OLDFILESIZE%
EXIT /B 0