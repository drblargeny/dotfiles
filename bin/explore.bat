@echo off
REM Adapts the Cygwin explore.sh for use in a Windows shell

call check-CYGWIN_HOME.bat
if ERRORLEVEL 1 exit /B 1

set c=%CYGWIN_HOME%\bin\cygpath.exe %*
set z=%CYGWIN_HOME%\bin\bash.exe -c "while read f; do ~/bin/explore ""$f"";done"
echo command: %c%
echo command: %z%
%c%|%z%
REM pause

