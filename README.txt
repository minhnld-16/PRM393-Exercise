SLOT 8 - Student Manager App
Nguồn: Slot8.pdf, trang 19-33 (Bài tập tổng hợp 1)

YÊU CẦU ĐỀ
Home/List/Detail/Form, named routes với arguments, push/pop, add student; Android intent filter studentapp://student/detail?id=S001; Navigator 2.0 chỉ lý thuyết.

CHẠY TRÊN WINDOWS (có Flutter SDK, Android SDK, Emulator)
1. Giải nén ZIP rồi mở terminal tại thư mục student_manager_app (nơi có pubspec.yaml).
2. Chạy `flutter doctor` và đảm bảo Android toolchain + thiết bị được nhận.
3. Chạy `flutter create . --platforms=android` để tạo các file native/Gradle do Flutter SDK trên máy bạn quản lý.
4. Chạy `flutter pub get`.
5. Bật Android Emulator hoặc kết nối điện thoại, kiểm tra `flutter devices`.
6. Chạy `flutter run`.
7. Với Slot 3 (logic-only), thay `flutter run` bằng `dart run lib/main.dart` để xem console trực tiếp.

Lưu ý: Máy tạo bản nộp không cài `flutter`/`dart`, nên chưa thể chạy/biên dịch; file native được tạo từ lệnh flutter create trên SDK đích, không bịa template Android SDK/Gradle. Bản ZIP đã kèm source Flutter, pubspec.yaml và dữ liệu mẫu (nếu đề yêu cầu).

CHECKLIST / KẾT QUẢ MONG ĐỢI (CHƯA ĐƯỢC XÁC NHẬN BẰNG EMULATOR)
Home → Student List → Student Detail → Back; (+) mở Form, Save trả student. Deep link trên emulator chỉ đảm bảo mở app, chưa parse id (đề xác nhận).

PHẠM VI / CHI TIẾT CHƯA RÕ
Mô tả tổng quan nói deep link tới detail, nhưng trang 32 ghi rõ chưa parse query id; giữ đúng mức triển khai của hướng dẫn.

TEST ANDROID DEEP LINK:
adb shell am start -a android.intent.action.VIEW -d "studentapp://student/detail?id=S001"

TÙY CHỌN DỄ CHẠY TRÊN WINDOWS
Nhấn RUN_WINDOWS.bat từ thư mục gốc dự án; script dùng Flutter SDK đã cài trên máy,
tạo scaffold Android theo phiên bản SDK của máy, cài dependencies, rồi khởi chạy.
Ứng dụng vẫn cần thiết bị/emulator đã chạy sẵn.
