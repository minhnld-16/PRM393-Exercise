@echo off
cd /d "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter SDK is not in PATH. Install Flutter first.
  pause
  exit /b 1
)
REM Generate missing files (including Gradle wrapper) using installed Flutter SDK.
call flutter create --project-name gallerymanager_ce181159 --platforms android .
if errorlevel 1 exit /b 1
call flutter pub get
if errorlevel 1 exit /b 1
call flutter run
pause
