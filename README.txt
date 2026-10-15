Music Library Manager | Lab2

Source: Lab2.pdf; Flutter/Dart, Android, Material Design.

REQUIREMENTS
- Flutter SDK + Dart, Android SDK, emulator or Android phone; VS Code / Android Studio.
- Internet on first build for Pub packages and Gradle dependencies.

RUN ON WINDOWS
1. Extract ZIP. Open folder `musicManagerBasic_CE181159` in VS Code.
2. Run RUN_WINDOWS.bat (or in terminal: flutter create --project-name musicmanagerbasic_ce181159 --platforms android . ; flutter pub get ; flutter run).
3. `flutter doctor` to check Android development environment.
4. A device must be connected or an Android emulator started.

NOTES
- SDK not present in author's execution environment; cannot claim Flutter build/emulator test passed.
- Android Gradle wrapper/bootstrap files are generated through flutter create using installed Flutter SDK.
- PNG banner provided in assets/images/banner.png; local DB is created automatically upon first launch.
- SQLite data and SharedPreferences sessions remain on the emulator/device across app restarts.
- Example output: visible app screens and current database values; actual values depend on your input.

LAB 2 SPECIFIC BEHAVIOR
- Hard-coded login: admin / 123456 (specified in Lab 2).
- The SQLite database has exactly ONE table called Song; login/session are never stored in SQLite.
- Session uses SharedPreferences key isLogin; logout removes it.
- The Song.isFavorite INTEGER column represents favorite state (0 or 1).
- Home: search matches title OR artist while typing, plus genre/year filters.
- Tap song to edit/delete/toggle favorite; reopen Favorites to see only isFavorite=1.
- Use Add Song, enter fields, Save Song; returning to Home reloads SQLite data.
- The lab requests real screenshots. Those must be captured on your own emulator/device; none are fabricated in this package.

MANUAL TEST CHECKLIST (NOT YET EXECUTED)
[ ] First launch shows Login.
[ ] Wrong password displays Invalid username or password.
[ ] admin/123456 logs in, restart app opens Home.
[ ] Add/edit/delete records and confirm list updates.
[ ] Favorite and un-favorite songs, verify Favorite Songs.
[ ] Search title/artist, filter genre, filter current/last 5 years.
[ ] Logout shows login screen and restart remains logged out.
