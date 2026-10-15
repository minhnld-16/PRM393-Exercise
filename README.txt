SLOT 7 - Simple Planner App
Nguồn: Slot7.pdf, trang 19-29 (Bài tập tổng hợp 1)

YÊU CẦU ĐỀ
Home danh sách plans và nút Create Plan; form title/date/time qua date/time picker, validation, pop trả Plan; ThemeData, widget button.

CHẠY TRÊN WINDOWS (có Flutter SDK, Android SDK, Emulator)
1. Giải nén ZIP rồi mở terminal tại thư mục simple_planner (nơi có pubspec.yaml).
2. Chạy `flutter doctor` và đảm bảo Android toolchain + thiết bị được nhận.
3. Chạy `flutter create . --platforms=android` để tạo các file native/Gradle do Flutter SDK trên máy bạn quản lý.
4. Chạy `flutter pub get`.
5. Bật Android Emulator hoặc kết nối điện thoại, kiểm tra `flutter devices`.
6. Chạy `flutter run`.
7. Với Slot 3 (logic-only), thay `flutter run` bằng `dart run lib/main.dart` để xem console trực tiếp.

Lưu ý: Máy tạo bản nộp không cài `flutter`/`dart`, nên chưa thể chạy/biên dịch; file native được tạo từ lệnh flutter create trên SDK đích, không bịa template Android SDK/Gradle. Bản ZIP đã kèm source Flutter, pubspec.yaml và dữ liệu mẫu (nếu đề yêu cầu).

CHECKLIST / KẾT QUẢ MONG ĐỢI (CHƯA ĐƯỢC XÁC NHẬN BẰNG EMULATOR)
Create Plan → chọn Date và Time → Save; thiếu title/date/time thì có SnackBar; dữ liệu hợp lệ về Home hiển thị plan.

PHẠM VI / CHI TIẾT CHƯA RÕ
Đề có bước mở rộng Confirm Screen/Dark Theme; không triển khai.

TÙY CHỌN DỄ CHẠY TRÊN WINDOWS
Nhấn RUN_WINDOWS.bat từ thư mục gốc dự án; script dùng Flutter SDK đã cài trên máy,
tạo scaffold Android theo phiên bản SDK của máy, cài dependencies, rồi khởi chạy.
Ứng dụng vẫn cần thiết bị/emulator đã chạy sẵn.
