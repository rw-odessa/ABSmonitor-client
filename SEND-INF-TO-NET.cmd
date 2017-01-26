@ECHO OFF
setlocal

REM �������� ��������� �� ����.
REM V 1.0.0 - ������ ���������������� ������.

REM ==================================================
REM ��������� ����������

REM ��� ������.
SET MODUL_NAME=DEL-OLD-LOGS

REM ������� ������� �������.
SET RUN_DIR=%~dp0

REM ���������.
SET MESSAGE=%~1

REM ������ ����������� ���������.
SET "MESSAGE_RECIPIENTS=%RUN_DIR%MESSAGE_RECIPIENTS.txt"

REM ������� ������� ���������.
SET NET_SEND=net.exe

REM ==================================================
REM ���� ������ ����������� �� ������, �� ��������� ������.
IF NOT EXIST "%MESSAGE_RECIPIENTS%" (
ECHO %date% %time% - MESSAGE RECIPIENTS LIST %MESSAGE_RECIPIENTS% NOT FOUND
EXIT /B 1
)

REM ==================================================
REM ���� ��������� �� �������� 1-�� ���������� ���������� ������, �� �����.
IF "%MESSAGE%"=="" (
ECHO %date% %time% - MESSAGE IS EMPTY
EXIT /B 1
)

REM ==================================================
REM ��������� ������� ������� �������� ���������
IF NOT EXIST "NET_SEND" (
ECHO %date% %time% - %NET_SEND% NOT FOUND 
EXIT /B 1
)

REM ==================================================
REM ������ ������ ����������� �� ����� MESSAGE_RECIPIENTS, � ���������� �� ��������� MESSAGE
FOR /F %%G IN (%MESSAGE_RECIPIENTS%) DO (
net.exe send %%G "%MESSAGE%" || ECHO %date% %time% - ERROR SEND MESSAGE TO %%G
)

EXIT /B 0