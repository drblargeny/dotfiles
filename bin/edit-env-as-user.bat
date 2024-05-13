@echo off
rem Runs the Windows control panel item to edit the user's environment
rem variables.
rem
rem NOTE: This works when the user doesn't have administrative access. However,
rem it never provides access to modify system environment variables.

rem Start the system control panel in the edit evironment variables section
rundll32 sysdm.cpl,EditEnvironmentVariables
