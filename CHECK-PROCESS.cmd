@ECHO OFF
setlocal

REM �������� ������� �������� � ������.
REM V 1.0.0 - ������ ���������������� ������.

REM ������������� CHECK-PROCESS.cmd PROCESS_NAME

REM ==================================================
REM ��������� ����������

REM ��� ������.
SET MODUL_NAME=CHECK-PROCESS

REM ������� ������� �������.
SET RUN_DIR=%~dp0

REM ���������.
SET PROCESS_NAME=%~1

REM ==================================================
REM ���� ��������� �� �������� 1-�� ���������� ���������� ������, �� �����.
IF "%PROCESS_NAME%"=="" (
ECHO %date% %time% - PROCESS NAME IS EMPTY
EXIT /B 1
)

REM ==================================================
REM ��������� ������� ������� tasklist
IF NOT EXIST "%windir%/system32/tasklist.exe" (
ECHO %date% %time% - tasklist.exe NOT FOUND
EXIT /B 1
)

REM ==================================================
REM ��������� ������� ������� find
IF NOT EXIST "%windir%/system32/find.exe" (
ECHO %date% %time% - find.exe NOT FOUND
EXIT /B 1
)

REM ==================================================
REM �������� ������������� �������� � ������.
CALL "%windir%/system32/tasklist.exe" /NH /FI "IMAGENAME eq %PROCESS_NAME%.exe" | "%windir%/system32/find.exe" /I "%PROCESS_NAME%.exe" && (
ECHO %date% %time% - FOUND PROCESS %PROCESS_NAME%
EXIT /B 0
)

REM ==================================================
REM ���� �������� � ������ �� �������.
ECHO %date% %time% - PROCESS %PROCESS_NAME% NOT FOUND
EXIT /B 1