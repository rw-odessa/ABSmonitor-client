@ECHO OFF
setlocal

REM ����뫪� ᮮ�饭�� �� �����஭��� ����.
REM V 1.0.0 - ��ࢠ� �ᯫ��樮���� �����.

REM ==================================================
REM ��⠭���� ��६�����

REM ��� �����.
SET MODUL_NAME=SEND-INF-TO-NET

REM ��⠫�� ����᪠ �ਯ�.
SET "RUN_DIR=%~dp0"

REM ����� ���饭��.
SET "STATUS=%~1"

REM ����饭��.
SET "MESSAGE=%~2"

REM ���᮪ �����⥫�� ᮮ�饭��.
SET "EMAIL_RECIPIENTS=%RUN_DIR%EMAIL_RECIPIENTS.txt"

REM �⨫�� �।�� ᮮ�饭��.
SET "EMAIL_SEND=%RUN_DIR%mailsend1-16.exe"

REM ��⠫�� ࠧ��饭�� ���-䠩���.
SET LOG_DIR=%RUN_DIR%

REM ��᪠ ���᪠ ���-䠩���.
SET FILES_TYPE=*log*.txt

REM ==================================================
REM �᫨ ᯨ᮪ �����⥫�� �� ������, � �����蠥� ࠡ���.
IF NOT EXIST "%EMAIL_RECIPIENTS%" (
ECHO %date% %time% - EMAIL RECIPIENTS LIST %EMAIL_RECIPIENTS% NOT FOUND
EXIT /B 1
)

REM ==================================================
REM �᫨ ����c ᮮ�饭�� �� ��।��� 1-� ��ࠬ��஬ ���������� ��ப�, � ��室.
IF "%STATUS%"=="" (
ECHO %date% %time% - STATUS IS EMPTY
EXIT /B 1
)

REM ==================================================
REM �᫨ ᮮ�饭�� ��।��� 1-� ��ࠬ��஬ ���������� ��ப�, ����� ����� �� �।������.
IF "%MESSAGE%"=="" (
SET "MESSAGE=%STATUS%"
SET "STATUS=INFO"
)

REM ==================================================
REM ��஢�ਬ ����稥 �⨫��� ��।�� ᮮ�饭��
IF NOT EXIST "%EMAIL_SEND%" (
ECHO %date% %time% - %EMAIL_SEND% NOT FOUND 
EXIT /B 1
)

REM==================================================
REM ������ ᠬ� ᢥ��� ��� 䠩� 
for /f %%a IN ('dir /o:-d /a:-d /s /b "%LOG_DIR%%FILES_TYPE%"') do (
SET "LOG_FILE=%%a"
GOTO 1
)

:1 
REM ==================================================
REM ��஢�ਬ ����稥 ���-䠩��.
IF NOT EXIST "%LOG_FILE%" (
SET "ATTACH="
) ELSE (
ECHO %date% %time% - FOUND LOG-FILE - %LOG_FILE%
SET "ATTACH=-attach %LOG_FILE%,text/plain"
)

REM ==================================================
REM ��⠥� ᯨ᮪ �����⥫�� �� 䠩�� MESSAGE_RECIPIENTS, � ��ࠢ�塞 �� ᮮ�饭�� MESSAGE
FOR /F %%G IN (%EMAIL_RECIPIENTS%) DO (
CALL "%EMAIL_SEND%" -d mtbnet -smtp 10.104.1.4 -t %%G -f INFO@marfinbank.ua -cs "CP866" -sub "%STATUS%" -M "%MESSAGE%" %ATTACH%|| ECHO %date% %time% - ERROR SEND MESSAGE TO %%G
)
EXIT /B 0