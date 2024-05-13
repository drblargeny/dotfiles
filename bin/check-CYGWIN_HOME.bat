@echo off
REM Check to see the CYGWIN_HOME is assigned
REM http://www.robvanderwoude.com/battech_defined.php
verify other 2>nul
setlocal enableextensions
if errorlevel 1 (
  echo Unable to enable extensions 1>&2
  goto Error
)
if defined CYGWIN_HOME (
  echo CYGWIN_HOME=%CYGWIN_HOME% 1>&2
  REM Check that path actually exists
  if exist "%CYGWIN_HOME%" (
    goto Success
  ) else (
    echo Path does not exist 1>&2
    goto Error
  )
) else (
  echo CYGWIN_HOME NOT defined 1>&2
  goto Error
)

:Success
REM End local context and set return value
endlocal & set RETVAL=0
goto End

:Error
REM End local context and set return value
endlocal & set RETVAL=1
goto End

:End
REM Exit batch file and return value
REM echo Exiting with RETVAL=%RETVAL% 1>&2
exit /B %RETVAL%

