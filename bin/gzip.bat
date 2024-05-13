@echo off
call check-CYGWIN_HOME.bat
if errorlevel 1 exit /b 1
set c=%CYGWIN_HOME%\bin\cygpath.exe %*
set z=%CYGWIN_HOME%\bin\xargs.exe "-rd\\n" "/bin/gzip" "--rsyncable"
echo command: %c%
echo command: %z%
%c%|%z%
REM pause
