@ECHO OFF
setlocal

REM �����ਭ� ���ﭨ� �ணࠬ��� �������ᮢ.
REM V 1.0.0 - ��ࢠ� �ᯫ��樮���� �����.

REM ==================================================
REM ��⠭���� ��६�����

REM ��� �����.
SET PROGRAM_NAME=mtbpro

REM ��⠫�� ����᪠ �ਯ�.
SET RUN_DIR=%~dp0

REM ==================================================
REM �஢�ਬ ����� � �����
CALL "%RUN_DIR%CHECK-PROCESS.cmd" "%PROGRAM_NAME%" || (
CALL "%RUN_DIR%LOG.cmd" "%PROGRAM_NAME%" "WARNING" "NOT RUNNIG"
EXIT /B 1
)

REM ==================================================
REM �஢�ਬ ��������� ࠧ��� ���-䠩��
REM CALL "%RUN_DIR%CHECK-FILE-SIZE-CHANGES.cmd" "��� ���-䠩�� ��� �����ਭ��" || (
REM CALL "%RUN_DIR%LOG.cmd" "%PROGRAM_NAME%" "WARNING" "SIZE OF LOG-FILE NOT CHANGE"
REM EXIT /B 1
REM )

REM ==================================================
REM �஢�ਬ ����稥 ��������� ���-䠩��
REM CALL %RUN_DIR%CHECK-FILE-HANGING.cmd "��� ���-䠩�� ��� �����ਭ��" || (
REM CALL "%RUN_DIR%LOG.cmd" "%PROGRAM_NAME%" "WARNING" "LOG-FILE HANGING"
REM EXIT /B 1
REM )


REM ==================================================
REM �஢�ਬ ����稥 ᮮ�饭�� ���-䠩��
REM CALL "%RUN_DIR%CHECK-FILE-CONTENT.cmd" "��� ���-䠩�� ��� �����ਭ��" "ᮮ�饭�� ��� ���᪠" && (
REM CALL "%RUN_DIR%LOG.cmd" "%PROGRAM_NAME%" "WARNING" "FOUND ERROR IN LOG"
REM EXIT /B 1
REM )

REM ==================================================
REM ����襬 ᮮ�饭�� � ���-䠩�.
CALL %RUN_DIR%LOG.cmd "%PROGRAM_NAME%" "INFO" "ALL IS WELL"

EXIT /B 0