@echo off
setlocal

set "MCP_NAME=db-readonly"
if "%~1"=="--smoke" (
  echo [%MCP_NAME%] smoke ok
  exit /b 0
)

for %%I in ("%~dp0..") do set "MCPS_DIR=%%~fI"
set "ARTIFACT_DIR=%MCPS_DIR%\_artifacts\acceptance"
if not exist "%ARTIFACT_DIR%" mkdir "%ARTIFACT_DIR%"

set "TARGET_REPO=%ROO_TARGET_REPO%"
if "%TARGET_REPO%"=="" set "TARGET_REPO=%CD%"
for /f "tokens=* delims= " %%A in ("%TARGET_REPO%") do set "TARGET_REPO=%%~A"

set "RUN_ID=%RANDOM%%RANDOM%"
set "OUT_FILE=%ARTIFACT_DIR%\%MCP_NAME%-%RUN_ID%.json"

> "%OUT_FILE%" (
  echo {
  echo   "mcp": "%MCP_NAME%",
  echo   "mode": "default",
  echo   "status": "ok",
  echo   "targetRepo": "%TARGET_REPO%",
  echo   "result": "simulated readonly db inspection completed",
  echo   "exitCode": 0
  echo }
)

echo [%MCP_NAME%] default ok: %OUT_FILE%
exit /b 0

