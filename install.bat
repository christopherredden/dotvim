:::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights
:::::::::::::::::::::::::::::::::::::::::
@echo off
CLS 
ECHO.
ECHO =============================
ECHO Running Admin shell
ECHO =============================

:checkPrivileges 
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges ) 

:getPrivileges 
if '%1'=='ELEV' (shift & goto gotPrivileges)  
ECHO. 
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation 
ECHO **************************************

setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs" 
ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs" 
"%temp%\OEgetPrivileges.vbs" 
exit /B 

:gotPrivileges 
::::::::::::::::::::::::::::
:START
::::::::::::::::::::::::::::
setlocal & pushd .

REM Run shell as admin (example) - put here code as you like

SET dir=%~dp0
set vimdir=%UserProfile%\.vim\

mkdir %vimdir% 2>NUL

mklink %UserProfile%\.vimrc %dir%\.vimrc 2>NUL

for /d %%i in (%dir%.vim\*) do (
    mklink /D %vimdir%%%~ni %%i
)

pause
