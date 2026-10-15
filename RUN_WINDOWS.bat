@echo off
setlocal
cd /d "%~dp0"
title Lab 5 - Favorite Shopping Items
where flutter >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Flutter was not found in PATH. Install Flutter and restart the terminal.
  pause
  exit /b 1
)
set "LAB5_DEVICE=%~1"
if not defined LAB5_DEVICE set "LAB5_DEVICE=windows"
if not exist windows\CMakeLists.txt (
  call flutter create --project-name lab5 --platforms=windows,android --no-pub .
  if errorlevel 1 goto failed
)
call flutter pub get
if errorlevel 1 goto failed
call flutter run -d "%LAB5_DEVICE%"
if errorlevel 1 goto failed
exit /b 0
:failed
echo [ERROR] Run failed. Check flutter doctor -v and README.md.
pause
exit /b 1
