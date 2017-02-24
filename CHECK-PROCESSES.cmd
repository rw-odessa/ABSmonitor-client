@ECHO OFF
setlocal

REM �஢�ઠ ������ ��᪮�쪨� ����ᮢ � �����.
REM V 1.0.0 - ��ࢠ� �ᯫ��樮���� �����.

REM ==================================================
REM ��⠭���� ��६�����

REM ��� �����.
SET MODUL_NAME=CHECK-PROCESSES

REM ��⠫�� ����᪠ �ਯ�.
SET RUN_DIR=%~dp0

REM ���᮪ �����⥫�� ᮮ�饭��.
SET "PROCESSES_LIST=%RUN_DIR%PROCESSES_LIST.txt"

REM ==================================================
REM �᫨ ᯨ᮪ �����⥫�� �� ������, � �����蠥� ࠡ���.
IF NOT EXIST "%PROCESSES_LIST%" (
ECHO %date% %time% - MESSAGE RECIPIENTS LIST %PROCESSES_LIST% NOT FOUND
EXIT /B 1
)

REM ==================================================
REM �᫨ ᯨ᮪ ����ᮢ �� ������, � �����蠥� ࠡ���.
IF NOT EXIST "%RUN_DIR%CHECK-PROCESS.cmd" (
ECHO %date% %time% - CHECK-PROCESS.cmd NOT FOUND
EXIT /B 1
)

REM ==================================================
REM ��⠥� ᯨ᮪ ����ᮢ �� 䠩�� PROCESSES_LIST, � �஢��塞 �� ����稥.
FOR /F %%G IN (%PROCESSES_LIST%) DO (
CALL "%RUN_DIR%CHECK-PROCESS.cmd" "%%G" || EXIT /B 1
)
EXIT /B 0