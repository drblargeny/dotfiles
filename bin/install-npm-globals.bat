@echo off
REM The procedures below are designed to remove any old version so a new
REM version can be cleanly installed.  While an update may be able to be used,
REM some libraries explicitly recommend against using it when updating.
REM
REM Some project builds and/or npm libraries require Git to be installed.
REM Please follow these instructions for setting it up.
REM
REM NOTE: npm is a batch/cmd file so we need to use the call statement to
REM invoke it

REM Grunt - JavaScript task runner (e.g. CSS/JS combination/minification)
call npm rm -g grunt-cli
call npm install -g grunt-cli

REM Gulp - Streaming build system (e.g. CSS/JS combination/minifcation)
call npm rm -g gulp
call npm rm -g gulp-cli
call npm install -g gulp-cli

REM trash - Move files and folders to the trash/recycle bin
call npm rm -g trash-cli
call npm install -g trash-cli
