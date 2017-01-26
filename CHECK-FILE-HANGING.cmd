@ECHO OFF
setlocal enabledelayedexpansion

REM ������ ����������� ��� ��������� �����.
REM V 1.0.0 - ������ ���������������� ������.
REM V 1.0.1 - ��������� ���� ������.
REM V 1.0.2 - ��������� �������.

REM ==================================================
REM ��������� ����������

REM ��� ������.
SET MODUL_NAME=CHECK-FILE-HANGING

REM ������� ������� �������.
SET RUNDIR=%~dp0

REM ��� �����.
SET FILE_TO_OBSERVE=%~1

REM ==================================================
ECHO .
ECHO ==================================================
ECHO %date% %time% - START %MODUL_NAME% V 1.0.2

REM ==================================================
REM �������� �������� ��������� �������
IF "%FILE_TO_OBSERVE%" == "" (
ECHO %date% %time% - WARNING FILE TO OBSERVE IS EMPTY
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING FILE TO OBSERVE IS EMPTY"
EXIT /B 1
)

REM ==================================================
REM �������� c������������ ����� FILE_TO_OBSERVE
IF NOT EXIST "%FILE_TO_OBSERVE%" (
ECHO %date% %time% - WARNING FILE %FILE_TO_OBSERVE% NOT FOUND
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING %FILE_TO_OBSERVE% NOT FOUND"
EXIT /B 1
)
ECHO %date% %time% - OK FILE TO OBSERVE - %FILE_TO_OBSERVE%

REM ==================================================
REM ���� ��� ����� ��� ��������� ������ �� �������� ��
IF NOT EXIST "%RUNDIR%TEMP" (
MD "%RUNDIR%TEMP" || (
ECHO %date% %time% - ERROR CREATE DIRECTORY "%RUNDIR%TEMP"
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "ERROR CREATE DIRECTORY "%RUNDIR%TEMP""
)
)

REM ==================================================
REM �������� ����� ������ �����
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
REM ��������� ��� �����.
FOR %%b in ("%FILE%") do (
	REM "SET FILEFULL=%%~fb"
	REM "SET FILEPATH=%%~dpb"
SET "FILEEXT=%%~xb"
SET "FILENAME=%%~nxb"
)    
	REM ECHO %date% %time% - %file% = %filepath% + %filename%
	REM ECHO %date% %time% - FILEEXT = %FILEEXT%

REM ==================================================
REM ���� ��� ��������������� �����  FILE_TO_OBSERVE_OLD, �� �������� ���.
REM � ���� ��� �����, ������ ����� ����� ���� � ����� ������� ��������� �����
IF NOT EXIST "%RUNDIR%TEMP\%FILENAME%_OLD" (
DEL /Q %RUNDIR%TEMP\*%FILEEXT%_OLD && ECHO %date% %time% - DELETE %RUNDIR%TEMP\*%FILEEXT%_OLD  - OK
COPY NUL "%RUNDIR%TEMP\%FILENAME%_OLD" && ECHO %date% %time% - CREATE FILE "%RUNDIR%TEMP\%FILENAME%_OLD"  - OK
)

REM ==================================================
REM ��������� ������
ECHO %date% %time% - FC "%RUNDIR%TEMP\%FILENAME%_OLD" "%RUNDIR%TEMP\%FILENAME%"
FC "%RUNDIR%TEMP\%FILENAME%_OLD" "%RUNDIR%TEMP\%FILENAME%" | find "FC" && (
ECHO %date% %time% - WARNING FILE %FILE% HANGING
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "WARNING FILE %FILE% HANGING"
EXIT /B 1
)
ECHO %date% %time% - CHECK FILE %FILE% - OK

REM ==================================================
REM ��������� �������������� ��������� �����
COPY /y "%RUNDIR%TEMP\%FILENAME%" "%RUNDIR%TEMP\%FILENAME%_OLD" || (
ECHO %date% %time% - ERROR COPY "%RUNDIR%TEMP\%FILENAME%" TO "%RUNDIR%TEMP\%FILENAME%_OLD"
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "ERROR COPY "%RUNDIR%TEMP\%FILENAME%" TO "%RUNDIR%TEMP\%FILENAME%_OLD"
)
REM ������ ������ �����
DEL /Q %RUNDIR%TEMP\*%FILEEXT% || (
ECHO %date% %time% - ERROR DELETE %RUNDIR%TEMP\*%FILEEXT%
CALL "%RUNDIR%SEND-INF-TO-NET.cmd" "ERROR DELETE %RUNDIR%TEMP\*%FILEEXT%"
)

REM ==================================================
REM �������� �����
EXIT /B 0