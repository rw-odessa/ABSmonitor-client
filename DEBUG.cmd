@ECHO OFF
setlocal enabledelayedexpansion

REM ������ �������� ��� ������� � ��� ����.
REM V 1.0.0 - ������ ���������������� ������.

REM==================================================
REM ��������� ����������
SET RUNDIR=%~dp0
REM CD "%RUNDIR%"|| ECHO %date% %time% - ERROR CD %RUNDIR%

REM==================================================
REM ������ ��������� � ������� �����.
REM ����� ��������� ��� ��������� ����� � ����� ����.
CALL %RUNDIR%START-MONITOR.cmd >> "%RUNDIR%DEBUG_LOG.txt"

REM==================================================
REM ����� ��� ������.
EXIT /B 0