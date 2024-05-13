@echo off
REM Decodes stdin as quoted printable
REM http://www.billharlan.com/papers/Bourne_shell_idioms.html

REM Check that CYGWIN_HOME env var is set
(call check-CYGWIN_HOME.bat) 1>&2
if ERRORLEVEL 1 exit /B 1

"%CYGWIN_HOME%\bin\perl" "-pe" "use MIME::QuotedPrint; $_=MIME::QuotedPrint::decode($_);"
REM pause

