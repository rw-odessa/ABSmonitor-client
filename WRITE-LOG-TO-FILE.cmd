@ECHO OFF
setlocal

REM ������� ���-䠩��
REM V 1.0.0 - ��ࢠ� �ᯫ��樮���� �����.

REM �ᯮ�짮����� WRITE-LOG-TO-FILE.cmd "ᮮ�饭��"

REM ==================================================
REM ��⠭���� ��६�����

REM ��� �����.
SET MODUL_NAME=WRITE-LOG-TO-FILE

REM ��⠫�� ����᪠ �ਯ�.
SET RUN_DIR=%~dp0

REM ��⠫�� ࠧ��饭�� ���-䠩���, 㪠�뢠�� � �������騬 \.
SET LOG_DIR=%RUN_DIR%LOGS\

REM ==================================================
REM �᫨ ��� ����� ��� ���-䠩��� � ᮧ����� ��
IF NOT EXIST "%LOG_DIR%" (
MD "%LOG_DIR%" || (
ECHO %date% %time% - ERROR CREATE DIRECTORY "%LOG_DIR%"
)
)

REM ==================================================
REM ������㥬 ��� ���-䠩�� �� ⥪�饩 ���� � �६���
set DA=%date%

REM ���࠭�� �������⨬� � ����� 䠩�� ᨬ����
set DA=%DA::=-%
set DA=%DA:/=_%
set DA=%DA:\=_%
set DA=%DA:(=%
set DA=%DA:)=%
set DA=%DA:.=_%
set DA=%DA:,=_%
set DA=%DA: =_%
set DA=%DA:'=%
set DA=%DA:"=%
set DA=%DA:_______=_%
set DA=%DA:______=_%
set DA=%DA:_____=_%
set DA=%DA:____=_%
set DA=%DA:___=_%
set DA=%DA:__=_%

REM echo %DA%
SET LOG_FILE_NAME="%LOG_DIR%LOG_%DA%.txt"

REM ==================================================
REM ������ ���� ���-䠩��.
IF EXIST "%RUN_DIR%DEL-OLD-LOGS.cmd" (
CALL "%RUN_DIR%DEL-OLD-LOGS.cmd" "%LOG_DIR%" "5" || ECHO %date% %time% - ERROR RUN DEL-OLD-LOGS.cmd
)

REM ==================================================
REM �᫨ ᮮ�饭�� �� ��।��� 1-� ��ࠬ��஬ ���������� ��ப�, � ��室.
IF "%~1"=="" (
ECHO %date% %time% - MESSAGE IS EMPTY
EXIT /B 1
)

REM ==================================================
REM ������ ���� � 䠩�, %1 - ���� ��ࠬ��� ��������� ��ப�.
ECHO %date% %time% - %~1 >> %LOG_FILE_NAME% || (
ECHO %date% %time% - Error write file - %LOG_FILE_NAME%
EXIT /B 1
)
EXIT /B 0