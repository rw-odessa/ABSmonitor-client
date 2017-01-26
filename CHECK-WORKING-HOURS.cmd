@ECHO OFF
setlocal

REM ��ਯ� �஢�ન ��室���� � �ࠧ���筮�� ���
REM V 1.0.0 - ��ࢠ� �ᯫ��樮���� �����.

REM ==================================================
REM ��⠭���� ��६�����

REM ��� �����.
SET MODUL_NAME=CHECK-WORKING-HOURS

REM ��⠫�� ����᪠ �ਯ�.
SET RUNDIR=%~dp0

REM ����祥 �६�.
SET START_TIME=8
SET END_TIME=18

REM ==================================================
ECHO .
ECHO ==================================================
ECHO %date% %time% - START %MODUL_NAME% V 1.0.0

REM ==================================================
REM ��।���� ⥪�饥 �६�
set HH=%time:~0,2%
REM set HH=3
IF %HH%=="" (
ECHO %date% %time% - WARNING, CANNOT RECOGNIZE CURRENT TIME
EXIT /B 1
)
ECHO %date% %time% - OK, CURRENT HOUR %HH%

REM ==================================================
REM ��।���� ⥪�饥 �६�
IF %HH% LSS %START_TIME% (
ECHO %date% %time% - WARNING, CURRENT TIME LSS %START_TIME%
EXIT /B 1
)
IF %HH% GTR %END_TIME% (
ECHO %date% %time% - WARNING, CURRENT TIME GTR %END_TIME%
EXIT /B 1
)

REM ==================================================
REM ������� ࠡ�稩 ����, ࠡ�⠥�.
ECHO %date% %time% - OK, NOW IS WORKING TIME
EXIT /B 0