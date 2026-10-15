Recurring Bills Manager | Lab4

Source: Lab4.pdf; Flutter/Dart, Android, Material Design.

REQUIREMENTS
- Flutter SDK + Dart; VS Code / Android Studio.
- Windows desktop: Visual Studio with Desktop development with C++ and Windows SDK.
- Android: Android SDK and emulator or Android phone.
- Internet on first build for dependencies.

RUN ON WINDOWS
1. Extract ZIP. Open folder `recurring_bills_manager` in VS Code.
2. Run RUN_WINDOWS.bat (or run: flutter pub get, then flutter run -d windows).
3. Run `flutter doctor -v` to check the Windows / Visual Studio development environment.
4. Windows desktop does not require an Android emulator.

RUN ON ANDROID
1. Connect an Android device or start an Android emulator.
2. Run `flutter devices`, then `flutter run -d <android-device-id>`.

NOTES
- Windows/Linux use sqflite_common_ffi; Android uses the sqflite plugin.
- Windows/Linux databases are stored in the application's support directory.
- Android Gradle wrapper/bootstrap files are generated through flutter create using installed Flutter SDK.
- Banner is drawn with Flutter widgets; local DB is created automatically upon first launch.
- SQLite data and SharedPreferences sessions remain on the emulator/device across app restarts.
- Example output: visible app screens and current database values; actual values depend on your input.

LAB 4 SPECIFIC BEHAVIOR
- SQLite table bills: id, bill_name, category, amount (REAL), status, due_date (ISO YYYY-MM-DD).
- Starting list may be empty. Tap + to enter Bill Name, select Category, enter Amount and Due Date (YYYY-MM-DD), and select Paid/Unpaid (default Unpaid).
- Tap a bill to edit; Update/Delete/Back appear on ONE row.
- Deletion requires confirmation. Validation and add/update/delete results use dialogs.
- Bottom tabs: All Bills and Unpaid. The Unpaid tab lists only Unpaid and sums their amounts in VND.
- The example figures mention FlatList (a React Native component); Flutter implementation uses ListView.builder as expressly suggested in the lab.
- Home uses a cream illustrated banner, purple amounts and status badges; Unpaid uses compact rows and an orange outstanding summary below the list.

MANUAL TEST CHECKLIST (NOT YET EXECUTED)
[ ] First launch shows empty list/banner/tab navigation.
[ ] Form empty values show validation errors, including missing date.
[ ] Add Unpaid bill; verify Home list shows name/category/amount/date/status.
[ ] Tap bill; edit to Paid, save and verify Unpaid tab removes it.
[ ] Add multiple Unpaid bills and verify outstanding sum.
[ ] Delete with Cancel then with Confirm; verify list and summary refresh.
[ ] Restart app and confirm SQLite rows remain.
- Enter 850000 or 850.000 to represent 850 thousand VND; both input formats are accepted.
