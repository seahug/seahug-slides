@echo off
setlocal
call :SetConfig %~dp0\.

pushd %PROJECTDIR%
cabal run
goto :eof

:SetConfig
set SCRIPTDIR=%~df1
call :SetConfig0 %SCRIPTDIR%\..
goto :eof
:SetConfig0
set PROJECTDIR=%~df1
goto :eof

