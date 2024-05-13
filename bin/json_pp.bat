@echo off
REM Adapts the Cygwin /usr/bin/json_pp for use in a Windows shell

(call check-CYGWIN_HOME.bat) 1>&2
if ERRORLEVEL 1 exit /B 1

"%CYGWIN_HOME%\bin\perl" "--" "/usr/bin/json_pp" %*
REM pause

