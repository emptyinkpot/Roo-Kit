@echo off
setlocal EnableDelayedExpansion

for %%I in ("%~dp0") do set "MCPS_DIR=%%~fI"
set "ARTIFACT_DIR=%MCPS_DIR%_artifacts\acceptance"
if not exist "%ARTIFACT_DIR%" mkdir "%ARTIFACT_DIR%"

set "TARGET_REPO=%ROO_TARGET_REPO%"
if "%TARGET_REPO%"=="" set "TARGET_REPO=%CD%"
for /f "tokens=* delims= " %%A in ("%TARGET_REPO%") do set "TARGET_REPO=%%~A"
set "ROO_TARGET_REPO=%TARGET_REPO%"

set "SUMMARY_FILE=%ARTIFACT_DIR%\all-mcps-regression-summary-%RANDOM%%RANDOM%.txt"

echo [all-mcps-regression] target repo: %ROO_TARGET_REPO%
echo targetRepo=%ROO_TARGET_REPO%> "%SUMMARY_FILE%"

set "MCP_LIST=playwright-browser experience-manager repo-inspector context-reranker context-store db-readonly log-diagnose memory-distill output-guard prompt-compressor"

for %%N in (%MCP_LIST%) do (
  call "%MCPS_DIR%%%N\start.cmd" --smoke
  if errorlevel 1 (
    echo failedSmoke=%%N>> "%SUMMARY_FILE%"
    goto :fail
  )
)

for %%N in (%MCP_LIST%) do (
  call "%MCPS_DIR%%%N\start.cmd"
  if errorlevel 1 (
    echo failedDefault=%%N>> "%SUMMARY_FILE%"
    goto :fail
  )
)

echo status=ok>> "%SUMMARY_FILE%"
echo [all-mcps-regression] summary: %SUMMARY_FILE%
exit /b 0

:fail
echo status=failed>> "%SUMMARY_FILE%"
echo [all-mcps-regression] failed, summary: %SUMMARY_FILE%
exit /b 1
