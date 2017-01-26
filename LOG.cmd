@ECHO OFF
setlocal

REM ��������� ᮡ�⨩.
REM V 1.0.0 - ��ࢠ� �ᯫ��樮���� �����.

REM �ᯮ�짮����� LOG.cmd "MESSAGE_SOURCE" "STATUS" "MESSAGE"

REM ==================================================
REM ��⠭���� ��६�����

REM ��� �����.
SET MODUL_NAME=LOG

REM ��⠫�� ����᪠ �ਯ�.
SET RUN_DIR=%~dp0

REM ���筨� ᮮ�饭��.
SET MESSAGE_SOURCE=%~1

REM ����饭��.
SET STATUS=%~2

REM ����饭��.
SET MESSAGE=%~3

REM ==================================================
REM �᫨ ���筨� ᮮ�饭�� �� ��।�� 1-� ��ࠬ��஬ ���������� ��ப�, � ��室.
IF "%MESSAGE_SOURCE%"=="" (
ECHO %date% %time% - %MODUL_NAME%, MESSAGE SOURCE IS EMPTY
EXIT /B 1
)

REM ==================================================
REM �᫨ ����� ᮮ�饭�� �� ��।�� 2-� ��ࠬ��஬ ���������� ��ப�, � ��室.
IF "%STATUS%"=="" (
ECHO %date% %time% - %MODUL_NAME%, STATUS IS EMPTY
EXIT /B 1
)

REM ==================================================
REM �஢�ઠ �����⨬��� �����.
for %%A in ("ERROR" "WARNING" "INFO" "error" "warning" "info") do if "%STATUS%"==%%A GOTO NEXT
ECHO %date% %time% - %MODUL_NAME%, STATUS %STATUS% NOT ALLOWED, SET STATUS = INFO
SET "STATUS=INFO" || EXIT /B 1

:NEXT
REM ==================================================
REM �᫨ ᮮ�饭�� �� ��।��� 3-�� ��ࠬ��஬ ���������� ��ப�, � ��室.
IF "%MESSAGE%"=="" (
ECHO %date% %time% - %MODUL_NAME%, MESSAGE IS EMPTY
EXIT /B 1
)

IF NOT EXIST "%RUN_DIR%WRITE-LOG-TO-FILE.cmd" (
ECHO %date% %time% - %MODUL_NAME%, %RUN_DIR%WRITE-LOG-TO-FILE.cmd NOT EXIST
)

REM ==================================================
REM �롮� �業��� ࠡ��� � ����ᨬ��� �� ����� ᮮ�饭��.
IF "%STATUS%"=="ERROR" GOTO ERROR
IF "%STATUS%"=="error" GOTO ERROR
IF "%STATUS%"=="WARNING" GOTO WARNING
IF "%STATUS%"=="warning" GOTO WARNING
IF "%STATUS%"=="INFO" GOTO INFO
IF "%STATUS%"=="info" GOTO INFO

:ERROR
REM ==================================================
REM ��ࠢ�� ᮮ�饭�� �� �����.
CALL "%RUN_DIR%SEND-INF-TO-EMAIL.cmd" "%STATUS%" "%MESSAGE%" || (
ECHO %date% %time% - %MODUL_NAME%, ERROR CALL %RUN_DIR%SEND-INF-TO-EMAIL.cmd
)

:WARNING
REM ==================================================
REM ��ࠢ�� ᮮ�饭�� �� ��.
CALL "%RUN_DIR%SEND-INF-TO-NET.cmd" "%STATUS% - %MESSAGE%" || (
ECHO %date% %time% - %MODUL_NAME%, ERROR CALL %RUN_DIR%SEND-INF-TO-NET.cmd
)

:INFO
REM ==================================================
REM �������� ᮮ�饭�� � ���᮫�.
ECHO %date% %time% - %MESSAGE_SOURCE% %STATUS% %MESSAGE%

REM ==================================================
REM ������� ᮮ�饭�� � ���-䠩�.
CALL "%RUN_DIR%WRITE-LOG-TO-FILE.cmd" "%MESSAGE_SOURCE%, %STATUS%, %MESSAGE%" || (
ECHO %date% %time% - %MODUL_NAME%, ERROR CALL WRITE-LOG-TO-FILE.cmd
)

REM ==================================================
REM ��ࠢ�� ᮮ�饭�� �� �ࢥ�.
call cscript.exe "%RUN_DIR%SEND-INF-TO-SERVER.js" "http://10.104.4.43:8080/?program=%MESSAGE_SOURCE%&status=%STATUS%&message=%MESSAGE%" || (
ECHO %date% %time% - %MODUL_NAME%, ERROR CALL cscript.exe %RUN_DIR%SEND-INF-TO-SERVER.js
REM CALL WRITE-LOG-TO-FILE.cmd "%MODUL_NAME%, ERROR CALL cscript.exe"
)

EXIT /B 0