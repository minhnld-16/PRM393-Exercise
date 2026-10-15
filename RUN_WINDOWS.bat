@echo off
setlocal
cd /d "%~dp0"
where flutter >nul 2>&1
if errorlevel 1 (
  echo ERROR: Flutter SDK not found in PATH. Install Flutter and run flutter doctor first.
  pause
  exit /b 1
)
flutter create . --platforms=android
if errorlevel 1 (pause & exit /b 1)
flutter pub get
if errorlevel 1 (pause & exit /b 1)
dart run lib/main.dart
pause
