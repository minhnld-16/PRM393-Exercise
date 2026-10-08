Art Gallery Manager | Lab1

Source: Lab1.pdf; Flutter/Dart, Android, Material Design.

REQUIREMENTS
- Flutter SDK + Dart, Android SDK, emulator or Android phone; VS Code / Android Studio.
- Internet on first build for Pub packages and Gradle dependencies.

RUN ON WINDOWS
1. Extract ZIP. Open folder `galleryManager_CE181159` in VS Code.
2. Run RUN_WINDOWS.bat (or in terminal: flutter create --project-name gallerymanager_ce181159 --platforms android . ; flutter pub get ; flutter run).
3. `flutter doctor` to check Android development environment.
4. A device must be connected or an Android emulator started.

NOTES
- SDK not present in author's execution environment; cannot claim Flutter build/emulator test passed.
- Android Gradle wrapper/bootstrap files are generated through flutter create using installed Flutter SDK.
- PNG banner provided in assets/images/banner.png; local DB is created automatically upon first launch.
- SQLite data and SharedPreferences sessions remain on the emulator/device across app restarts.
- Example output: visible app screens and current database values; actual values depend on your input.

LAB 1 SPECIFIC BEHAVIOR
- New users register with unique username, email, password, confirm password.
- Login verifies username/password in SQLite, then stores session user ID in SharedPreferences.
- SQL tables: users, artworks, favorites. Favorite (userId, artworkId) is UNIQUE; foreign keys are enforced.
- New artworks store createdBy = logged-in user ID; detail supports edit/delete/add-to-favorite.
- Home lists artworks, searches title live, filters by listed categories or year (current/last 5/all).
- Favorite Artworks shows the current user's favorite records and allows removal.
- Home gallery statistics show number of artworks, user's favorites and distinct categories, refreshed after changes.
- Header banner is a bundled PNG illustration for the required header image/logo; it is not a reproduction of sample screenshot.
- The lab does not specify ownership permission checks for editing/deleting artworks; none were invented.
- NOTE: the lab's User data model has a plain password String. This student-only example uses local password comparison; do not use it for production authentication.
- Naming: folder is galleryManager_CE181159 following the stated pattern, while pubspec package name is lower-case gallerymanager_ce181159 to satisfy Dart package naming rules.

MANUAL TEST CHECKLIST (NOT YET EXECUTED)
[ ] Register blank fields and nonmatching passwords: validation errors.
[ ] Register a username, attempt the same username again: reject duplicate.
[ ] Login with incorrect credentials, then correct ones.
[ ] Close/reopen app and confirm session restores Home.
[ ] Add artwork, tap detail, edit, then delete with confirmation.
[ ] Check live title search and year/category filters.
[ ] Favorite from detail; favorite screen lists the artwork; prevent duplicate.
[ ] Remove favorite from favorite screen and verify Home stats.
[ ] Log out and verify session removed and notification shown.
