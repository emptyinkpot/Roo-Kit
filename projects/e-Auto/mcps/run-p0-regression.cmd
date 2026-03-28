@echo off
setlocal

for %%I in ("%~dp0") do set "MCPS_DIR=%%~fI"
set "ARTIFACT_DIR=%MCPS_DIR%_artifacts\acceptance"
if not exist "%ARTIFACT_DIR%" mkdir "%ARTIFACT_DIR%"

set "TARGET_REPO=%ROO_TARGET_REPO%"
if "%TARGET_REPO%"=="" set "TARGET_REPO=%CD%"
for /f "tokens=* delims= " %%A in ("%TARGET_REPO%") do set "TARGET_REPO=%%~A"
set "ROO_TARGET_REPO=%TARGET_REPO%"

set "SUMMARY_FILE=%ARTIFACT_DIR%\p0-regression-summary-%RANDOM%%RANDOM%.txt"

echo [p0-regression] target repo: %ROO_TARGET_REPO%
echo targetRepo=%ROO_TARGET_REPO%> "%SUMMARY_FILE%"

call "%MCPS_DIR%playwright-browser\start.cmd" --smoke
if errorlevel 1 goto :fail
call "%MCPS_DIR%experience-manager\start.cmd" --smoke
if errorlevel 1 goto :fail
call "%MCPS_DIR%repo-inspector\start.cmd" --smoke
if errorlevel 1 goto :fail

call "%MCPS_DIR%playwright-browser\start.cmd"
if errorlevel 1 goto :fail
call "%MCPS_DIR%experience-manager\start.cmd"
if errorlevel 1 goto :fail
call "%MCPS_DIR%repo-inspector\start.cmd"
if errorlevel 1 goto :fail

echo status=ok>> "%SUMMARY_FILE%"
echo [p0-regression] summary: %SUMMARY_FILE%
exit /b 0

:fail
echo status=failed>> "%SUMMARY_FILE%"
echo [p0-regression] failed, summary: %SUMMARY_FILE%
exit /b 1
