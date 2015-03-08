@echo off
setlocal
call :SetConfig %~dp0\.

pushd %SCRIPTDIR%
cabal run
goto :eof

:SetConfig
set SCRIPTDIR=%~df1
goto :eof
