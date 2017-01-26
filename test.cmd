@ECHO OFF
setlocal
rem CALL CHECK-PROCESSES.cmd || ECHO "||OK"
rem CALL CHECK-PROCESSES.cmd && ECHO "&&OK"

rem call url2.js "http://localhost:8080/test?parameter=value&also=another"
rem call cscript.exe "url3.js" "http://10.104.4.43:8080/test1?program=notepad&status=OK&message=All is normal" || ECHO ERROR

:label1
CALL "START-MONITOR lsm.cmd"
ping 127.0.0.1 -n 15 > nul

CALL "START-MONITOR.cmd"
CALL "START-MONITOR lsm.cmd"
ping 127.0.0.1 -n 15 > nul

CALL "START-MONITOR mtbpro.cmd"
CALL "START-MONITOR lsm.cmd"
ping 127.0.0.1 -n 15 > nul

goto label1