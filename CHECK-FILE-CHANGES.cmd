@ECHO OFF
setlocal enabledelayedexpansion

REM ������ ����������� ��������� �����.
REM V 1.0.3 - ����� ����� SEND-INF-TO-NET.cmd 
REM V 1.0.2 - ���������� ������ �������� 
REM V 1.0.1 - ��������� �������� CD "%RUNDIR%"
REM V 1.0.0 - ������ ���������������� ������.

REM ==================================================
REM ��������� ����������

REM ��� ������.
SET MODUL_NAME=CHECK-FILE-CHANGES

REM ������� ������� �������.
SET RUNDIR=%~dp0

REM ���� ��� ����������.
SET FILE_TO_OBSERVE=%~1

REM ==================================================
ECHO %date% %time% - START %CHECK-FILE-CHANGES% V 1.0.3

REM ==================================================
REM ����� �������� �� �������.
CD "%RUNDIR%"|| ECHO %date% %time% - ERROR CD %RUNDIR%

REM ==================================================
REM �������� �������� ��������� �������
IF "%FILE_TO_OBSERVE%" == "" (
ECHO %date% %time% - WARNING FILE TO OBSERVE IS EMPTY
EXIT /B 1
)

REM ==================================================
REM �������� c������������ ����� FILE_TO_OBSERVE
IF NOT EXIST "%FILE_TO_OBSERVE%" (
ECHO %date% %time% - WARNING FILE %FILE_TO_OBSERVE% NOT FOUND
EXIT /B 1
)
ECHO %date% %time% - OK FILE TO OBSERVE - %FILE_TO_OBSERVE%

REM ==================================================
REM ���� ��� ����� ��� ��������� ������ �� �������� ��
IF NOT EXIST .\OLD_FILES (
MD .\OLD_FILES || (
ECHO %date% %time% - ERROR CREATE DIRECTORY ".\TEMP"
EXIT /B 1
)
)

REM ==================================================
REM ���� ��� ����� ��� ��������� ������ �� �������� ��
IF NOT EXIST .\TMP_FILES (
MD .\TMP_FILES || (
ECHO %date% %time% - ERROR CREATE DIRECTORY .\TMP_FILES
EXIT /B 1
)
)

REM ==================================================
REM �������� ����� ������ �����.
XCOPY /y /v /z "%FILE_TO_OBSERVE%" ".\TMP_FILES\" || (
ECHO %date% %time% - WARNING ERROR COPY FILE "%FILE_TO_OBSERVE%" TO ".\TMP_FILES\"
EXIT /B 1
)
ECHO %date% %time% - COPY FILE "%FILE_TO_OBSERVE%" TO ".\TMP_FILES\" COMPLETE

REM ==================================================
REM ������ ���� ����� ������ ����.
SET /A FILECOUNT=0
for /f %%a in ('dir /b /o:-d ".\TMP_FILES\"') do (
REM ECHO %date% %time% - ===%%a===
if !FILECOUNT! == 1 goto LABEL1
SET FILENAME=%%a
SET /A FILECOUNT=FILECOUNT+1
)
:LABEL1

REM ==================================================
REM �������� FILENAME
IF "%FILENAME%"=="" (
ECHO %date% %time% - WARNING FILENAME IS EMPTY
EXIT /B 1
)

REM ==================================================
REM ���� ��� ��������������� �����  %FILENAME%_OLD, �� �������� ���.
IF NOT EXIST ".\OLD_FILES\%FILENAME%_OLD" (
COPY NUL ".\OLD_FILES\%FILENAME%_OLD" && ECHO %date% %time% - CREATE FILE ".\OLD_FILES\%FILENAME%_OLD"  - OK
)

REM ==================================================
REM ��������� ������
SET FILE_CHANGED=1
ECHO %date% %time% - FC ".\OLD_FILES\%FILENAME%_OLD" ".\TMP_FILES\%FILENAME%"
FC ".\OLD_FILES\%FILENAME%_OLD" ".\TMP_FILES\%FILENAME%" | find "FC" && (
ECHO %date% %time% - CHANGES IN FILE %FILENAME% NOT FOUND
SET FILE_CHANGED=0
)

REM ==================================================
REM ��������� �������������� ��������� �����
COPY /y ".\TMP_FILES\%FILENAME%" ".\OLD_FILES\%FILENAME%_OLD" || (
ECHO %date% %time% - ERROR COPY ".\TMP_FILES\%FILENAME%" TO ".\OLD_FILES\%FILENAME%_OLD"
)
REM ������ ��������� �����
	REM DEL /Q ".\TMP_FILES\*" || (
DEL /Q ".\TMP_FILES\%FILENAME%" || (
ECHO %date% %time% - ERROR DELETE ".\TMP_FILES\%FILENAME%"
)

REM ==================================================
REM �����
IF "%FILE_CHANGED%" == "0" EXIT /B 1
ECHO %date% %time% - FOUND CHANGES IN FILE %FILE%
EXIT /B 0