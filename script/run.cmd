@echo off
setlocal
call :SetConfig %~dp0\.

pushd %PROJECTDIR%
stack build
stack exec seahug-slides
goto :eof

:SetConfig
set SCRIPTDIR=%~df1
call :SetConfig0 %SCRIPTDIR%\..
goto :eof
:SetConfig0
set PROJECTDIR=%~df1
goto :eof

