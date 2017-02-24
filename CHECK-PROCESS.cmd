@ECHO OFF
setlocal

REM �஢�ઠ ������ ����� � �����.
REM V 1.0.0 - ��ࢠ� �ᯫ��樮���� �����.
REM V 1.0.1 - �롮� �⨫��� ᯨ᪠ ����ᮢ � �����.

REM �ᯮ�짮����� CHECK-PROCESS.cmd PROCESS_NAME

REM ==================================================
REM ��⠭���� ��६�����

REM ��� �����.
SET MODUL_NAME=CHECK-PROCESS

REM ��⠫�� ����᪠ �ਯ�.
SET RUN_DIR=%~dp0

REM ����饭��.
SET PROCESS_NAME=%~1

REM TaskList utils
REM SET TASK_LIST=%windir%/system32/tasklist.exe
SET TASK_LIST=%RUN_DIR%pslist.exe

REM ==================================================
REM �᫨ ᮮ�饭�� �� ��।��� 1-� ��ࠬ��஬ ���������� ��ப�, � ��室.
IF "%PROCESS_NAME%"=="" (
ECHO %date% %time% - PROCESS NAME IS EMPTY
EXIT /B 1
)

REM ==================================================
REM ��஢�ਬ ����稥 �⨫��� tasklist
IF NOT EXIST "%TASK_LIST%" (
ECHO %date% %time% - %TASK_LIST% NOT FOUND
EXIT /B 1
)

REM ==================================================
REM ��஢�ਬ ����稥 �⨫��� find
IF NOT EXIST "%windir%/system32/find.exe" (
ECHO %date% %time% - find.exe NOT FOUND
EXIT /B 1
)

REM ==================================================
REM �஢�ઠ ����⢮����� ����� � �����.
REM CALL "%TASK_LIST%" /NH /FI "IMAGENAME eq %PROCESS_NAME%.exe" | "%windir%/system32/find.exe" /I "%PROCESS_NAME%.exe" && (
CALL "%TASK_LIST%" | "%windir%/system32/find.exe" /I "%PROCESS_NAME%" && (
ECHO %date% %time% - FOUND PROCESS %PROCESS_NAME%
EXIT /B 0
)

REM ==================================================
REM �᫨ ����� � ����� �� �������.
ECHO %date% %time% - PROCESS %PROCESS_NAME% NOT FOUND
EXIT /B 1