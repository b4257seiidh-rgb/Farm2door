@echo off
setlocal
cd /d "%~dp0"

where node.exe >nul 2>&1
if errorlevel 1 (
  echo Node.js is required. Install Node.js 20 or newer, then try again.
  pause
  exit /b 1
)

if not exist "node_modules\express" (
  echo Installing Farm2Door dependencies for the first run...
  call npm.cmd install
  if errorlevel 1 (
    echo Dependency installation failed. Check your internet connection and try again.
    pause
    exit /b 1
  )
)

echo Starting Farm2Door. Keep this window open while using the website.
call npm.cmd run dev
pause