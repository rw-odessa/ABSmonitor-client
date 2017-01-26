@ECHO OFF
setlocal

REM �������� ��������� ������� �����.
REM V 1.0.0 - ������ ���������������� ������

REM ������������� CHECK-FILE-SIZE-CHANGES.cmd ".\test.txt"
REM ������������� CHECK-FILE-SIZE-CHANGES.cmd ".\test.*"
REM ������������� CHECK-FILE-SIZE-CHANGES.cmd ".\*test.*"

REM ==================================================
REM ��������� ����������

REM ��� ������.
SET MODUL_NAME=CHECK-FILE-SIZE-CHANGES

REM ������� ������� �������.
SET RUNDIR=%~dp0

REM ��� �����.
SET FILE=%~1

REM ��������� �����.
SET TEMPDIR=%RUNDIR%TEMP-FOR-SIZE\

REM ==================================================
ECHO .
ECHO %date% %time% - START %MODUL_NAME% V 1.0.0

REM ==================================================
REM �������� �������� ��������� �������
IF "%~1"=="" (
ECHO %date% %time% - WARNING COMMAND LINE PARAMETER 1 IS EMPTY
EXIT /B 1
)

REM ==================================================
REM �������� ���� ����� �� ���� � �����, ������ ����� ������ ����.
SET /A FILECOUNT=0
for /f %%a in ('dir /b /o:-d "%FILE%"') do (
ECHO %date% %time% - OK, FOUND FILE %%a
SET FILE=%%a
if !FILECOUNT! == 1 goto NEXT
SET /A FILECOUNT=FILECOUNT+1
)
:NEXT

REM ==================================================
REM �������� c������������ �����
IF NOT EXIST "%FILE%" (
ECHO %date% %time% - WARNING, FILE %FILE% NOT FOUND
EXIT /B 1
)
ECHO %date% %time% - OK, FILE EXIST, %FILE%

REM ==================================================
REM ��������� ��� �����, �������, ����������.
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
REM �������� ������������ ����������� ������� �����.
IF "%FILESIZE%" == "" (
ECHO %date% %time% - WARNING, FILESIZE IS EMPTY
EXIT /B 1
)

IF %FILESIZE% == 0  (
ECHO %date% %time% - WARNING, FILESIZE %FILE% = 0
	REM EXIT /B 1
)

REM ==================================================
REM �������� ������������ ����������� ����� �����.
IF "%FILENAME%" == "" (
ECHO %date% %time% - WARNING, FILENAME IS EMPTY
EXIT /B 1
)

REM ==================================================
REM ���� ��� ����� ��� ��������� ������ �� �������� ��
IF NOT EXIST "%TEMPDIR%" (
MD "%TEMPDIR%" || (
ECHO %date% %time% - ERROR CREATE DIRECTORY "%TEMPDIR%"
EXIT /B 1
)
)

REM ==================================================
REM �������� ������ ������� �����
SET OLDFILESIZE=0
IF EXIST "%TEMPDIR%%FILENAME%" (
SET /p OLDFILESIZE=<"%TEMPDIR%%FILENAME%" || (
ECHO %date% %time% - ERROR, CANNOT READ FILE %TEMPDIR%%FILENAME%
)
)

REM ==================================================
REM ��������� ������� ������� �����
ECHO %FILESIZE% > "%TEMPDIR%%FILENAME%" || (
ECHO %date% %time% - ERROR, CANNOT WRITE FILE %TEMPDIR%%FILENAME%
EXIT /B 1
)

REM ==================================================
REM �������� ������� �����
IF %FILESIZE% LEQ %OLDFILESIZE% (
ECHO %date% %time% - WARNING, FILESIZE OF %FILE% = %FILESIZE% , BUT SHOULD BE GREATER THAN %OLDFILESIZE%
EXIT /B 1
)
ECHO %date% %time% - OK, FILESIZE OF %FILE% = %FILESIZE% GREATER THAN %OLDFILESIZE%
EXIT /B 0