@ECHO OFF
setlocal

REM ��ਯ� �஢�ન ��室���� � �ࠧ���筮�� ���
REM V 1.0.0 - ��ࢠ� �ᯫ��樮���� �����.

REM ==================================================
REM ��⠭���� ��६�����

REM ��� �����.
SET MODUL_NAME=CHECK-HOLIDAY

REM ��⠫�� ����᪠ �ਯ�.
SET RUNDIR=%~dp0

REM ==================================================
ECHO .
ECHO ==================================================
ECHO %date% %time% - START %MODUL_NAME% V 1.0.0

REM ==================================================
REM ��஢�ਬ ����稥 �⨫��� find
IF NOT EXIST "%windir%/system32/find.exe" (
ECHO %date% %time% - find.exe NOT FOUND
EXIT /B 1
)

REM ==================================================
REM ��஢�ਬ ����稥 �⨫��� wmic
IF NOT EXIST "%windir%/system32/wbem/wmic.exe" (
ECHO %date% %time% - wmic.exe NOT FOUND
EXIT /B 1
)

REM ==================================================
REM ��।���� ⥪�騩 ��� YYYY
set YYYY=%date:~6,4%
REM set YYYY=2100
IF %YYYY%=="" (
ECHO %date% %time% - WARNING, CANNOT RECOGNIZE CURRENT YEAR
EXIT /B 1
)
ECHO %date% %time% - OK, CURRENT YEAR %YYYY%

REM ==================================================
REM �஢�ਬ ⥪�騩 ��� YYYY
IF %YYYY% LSS 2017 (
ECHO %date% %time% - WARNING, CURRENT YEAR LSS 2017
EXIT /B 1
)
IF %YYYY% GTR 2099 (
ECHO %date% %time% - WARNING, CURRENT YEAR GTR 2099
EXIT /B 1
)

REM ==================================================
REM �஢�ઠ c���⢮����� 䠩�� WORKING-DAY_YYYY
IF EXIST "%RUNDIR%WORKING-DAY_%YYYY%.txt" (
ECHO %date% %time% - OK, FILE "%RUNDIR%WORKING-DAY_%YYYY%.txt", EXIST
REM �஢�ઠ ������ ⥪�饩 ���� � 䠩�� ࠡ��� ����, WORKING-DAY_YYYY
CALL find /i "%date%" "%RUNDIR%WORKING-DAY_%YYYY%.txt" && (
ECHO %date% %time% - DATE %date%, FOUND IN FILE "%RUNDIR%HOLIDAY_%YYYY%.txt", TODAY IS WORKING DAY, OK
EXIT /B 0
)
) ELSE (
ECHO %date% %time% - FILE "%RUNDIR%WORKING-DAY_%YYYY%.txt", NOT FOUND
)

REM ==================================================
REM �஢�ઠ c���⢮����� 䠩�� HOLIDAY_YYYY
IF EXIST "%RUNDIR%HOLIDAY_%YYYY%.txt" (
ECHO %date% %time% - OK, FILE "%RUNDIR%HOLIDAY_%YYYY%.txt", EXIST
REM �஢�ઠ ������ ⥪�饩 ���� � 䠩�� �ࠧ������ ����, HOLIDAY_YYYY
CALL find /i "%date%" "%RUNDIR%HOLIDAY_%YYYY%.txt" && (
ECHO %date% %time% - DATE %date%, FOUND IN FILE "%RUNDIR%HOLIDAY_%YYYY%.txt", TODAY IS HOLIDAY, EXIT
EXIT /B 1
)
) ELSE (
ECHO %date% %time% - FILE "%RUNDIR%HOLIDAY_%YYYY%.txt", NOT FOUND
)


REM ==================================================
REM �஢�ਬ �㡡���.
CALL wmic path win32_localtime get dayofweek | find "6" && (
ECHO %date% %time% - TODAY IS SATURDAY, EXIT
EXIT /B 1
)

REM ==================================================
REM �஢�ਬ ����ᥭ�.
CALL wmic path win32_localtime get dayofweek | find "7" && (
ECHO %date% %time% - TODAY IS SUNDAY, EXIT
EXIT /B 1
)

REM ==================================================
REM ������� ࠡ�稩 ����, ࠡ�⠥�.
ECHO %date% %time% - TODAY IS WORKING DAY
EXIT /B 0