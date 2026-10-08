Recurring Bills Manager | Lab4

Source: Lab4.pdf; Flutter/Dart, Android, Material Design.

REQUIREMENTS
- Flutter SDK + Dart, Android SDK, emulator or Android phone; VS Code / Android Studio.
- Internet on first build for Pub packages and Gradle dependencies.

RUN ON WINDOWS
1. Extract ZIP. Open folder `recurring_bills_manager` in VS Code.
2. Run RUN_WINDOWS.bat (or in terminal: flutter create --project-name recurring_bills_manager --platforms android . ; flutter pub get ; flutter run).
3. `flutter doctor` to check Android development environment.
4. A device must be connected or an Android emulator started.

NOTES
- SDK not present in author's execution environment; cannot claim Flutter build/emulator test passed.
- Android Gradle wrapper/bootstrap files are generated through flutter create using installed Flutter SDK.
- PNG banner provided in assets/images/banner.png; local DB is created automatically upon first launch.
- SQLite data and SharedPreferences sessions remain on the emulator/device across app restarts.
- Example output: visible app screens and current database values; actual values depend on your input.

LAB 4 SPECIFIC BEHAVIOR
- SQLite table bills: id, bill_name, category, amount (REAL), status, due_date (ISO YYYY-MM-DD).
- Starting list may be empty. Tap + to enter Bill Name, Category, Amount, Due Date and Paid/Unpaid (default Unpaid).
- Tap a bill to edit; Update/Delete/Back appear on ONE row.
- Deletion requires confirmation. Add/update/delete show a SnackBar result.
- Bottom tabs: All Bills and Unpaid. The Unpaid tab lists only Unpaid and sums their amounts in VND.
- The example figures mention FlatList (a React Native component); Flutter implementation uses ListView.builder as expressly suggested in the lab.
- Banner image is a locally bundled PNG illustration for the required banner (not an exact reproduction of the screenshot).

MANUAL TEST CHECKLIST (NOT YET EXECUTED)
[ ] First launch shows empty list/banner/tab navigation.
[ ] Form empty values show validation errors, including missing date.
[ ] Add Unpaid bill; verify Home list shows name/category/amount/date/status.
[ ] Tap bill; edit to Paid, save and verify Unpaid tab removes it.
[ ] Add multiple Unpaid bills and verify outstanding sum.
[ ] Delete with Cancel then with Confirm; verify list and summary refresh.
[ ] Restart app and confirm SQLite rows remain.
- Enter 850000 or 850.000 to represent 850 thousand VND; both input formats are accepted.
