@ECHO OFF
setlocal enabledelayedexpansion

REM �������� ����� 䠩���
REM V 1.0.0 - ��ࢠ� �ᯫ��樮���� �����.
REM V 1.0.1 - ������ ��ࠡ�⪨.
REM V 1.0.2 - ��������� ��ࠡ�⪠ ��ࠬ��஢ ��������� ��ப�.

REM ==================================================
REM ��⠭���� ��६�����

REM ��� �����.
SET MODUL_NAME=DEL-OLD-LOGS

REM ��⠫�� ����᪠ �ਯ�.
SET RUN_DIR=%~dp0

REM ��᪠ ���᪠ ���-䠩���.
SET FILES_TYPE=*log*.txt

REM ��⠫�� ࠧ��饭�� ���-䠩���.
SET MON_DIR=%~1

REM ����쪮 䠩��� ���� �㤥� �࠭���.
SET LIVE_FILES=%~2

REM �᫨ ��⠫�� ࠧ��饭�� ���-䠩��� �� ��।�� 1-� ��ࠬ��஬ ���������� ��ப�, � ��⠭���� ���.
IF "%MON_DIR%"=="" (
SET MON_DIR=%RUN_DIR%
)

REM �᫨ ��⠫�� ࠧ��饭�� ���-䠩��� �� ������, � �����蠥� ࠡ���.
IF NOT EXIST "%MON_DIR%" (
ECHO %date% %time% - DIRECTORY %MON_DIR% NOT FOUND
EXIT /B 1
)

REM �᫨ ������⢮ ���-䠩��� �� ��।��� 2-� ��ࠬ��஬ ���������� ��ப�, � ��⠭���� ���.
IF "%LIVE_FILES%"=="" (
SET LIVE_FILES=12
)

REM ==================================================
REM ����塞 ᠬ� ���� 䠩��
SET /A FILES_COUNT=0
for /f %%a IN ('dir /o:-d /a:-d /b "%MON_DIR%%FILES_TYPE%"') do (
IF !FILES_COUNT! GEQ %LIVE_FILES% (
DEL /q "%MON_DIR%%%a" || ECHO %date% %time% - ERROR DELETE FILE %%a
)
SET /A FILES_COUNT=FILES_COUNT+1
)
EXIT /B 0