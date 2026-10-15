@echo off
cd /d "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter SDK is not in PATH. Install Flutter first.
  pause
  exit /b 1
)
REM Bootstrap the Windows runner only when it is missing.
if not exist "windows\CMakeLists.txt" (
  call flutter create --project-name recurring_bills_manager --platforms=windows .
  if errorlevel 1 exit /b 1
)
call flutter pub get
if errorlevel 1 exit /b 1
call flutter run -d windows
pause
