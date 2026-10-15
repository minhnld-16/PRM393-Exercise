SLOT 2 - Student Task Manager
Nguồn: Slot2.pdf, trang 54-58 (Dự án tổng hợp 9)

YÊU CẦU ĐỀ
Quản lý công việc trong bộ nhớ: nhập/thêm, danh sách ListView, checkbox hoàn thành, xóa; Scaffold, StatefulWidget/setState.

CHẠY TRÊN WINDOWS (có Flutter SDK, Android SDK, Emulator)
1. Giải nén ZIP rồi mở terminal tại thư mục student_task_manager (nơi có pubspec.yaml).
2. Chạy `flutter doctor` và đảm bảo Android toolchain + thiết bị được nhận.
3. Chạy `flutter create . --platforms=android` để tạo các file native/Gradle do Flutter SDK trên máy bạn quản lý.
4. Chạy `flutter pub get`.
5. Bật Android Emulator hoặc kết nối điện thoại, kiểm tra `flutter devices`.
6. Chạy `flutter run`.
7. Với Slot 3 (logic-only), thay `flutter run` bằng `dart run lib/main.dart` để xem console trực tiếp.

Lưu ý: Máy tạo bản nộp không cài `flutter`/`dart`, nên chưa thể chạy/biên dịch; file native được tạo từ lệnh flutter create trên SDK đích, không bịa template Android SDK/Gradle. Bản ZIP đã kèm source Flutter, pubspec.yaml và dữ liệu mẫu (nếu đề yêu cầu).

CHECKLIST / KẾT QUẢ MONG ĐỢI (CHƯA ĐƯỢC XÁC NHẬN BẰNG EMULATOR)
Nhập "Học Flutter" → (+) → có item; nhập trống không thêm; tick checkbox gạch chữ; delete xóa item.

PHẠM VI / CHI TIẾT CHƯA RÕ
Đề có bài nâng cao tự chọn; chỉ triển khai yêu cầu cốt lõi, không thêm SnackBar/Xóa tất cả.

TÙY CHỌN DỄ CHẠY TRÊN WINDOWS
Nhấn RUN_WINDOWS.bat từ thư mục gốc dự án; script dùng Flutter SDK đã cài trên máy,
tạo scaffold Android theo phiên bản SDK của máy, cài dependencies, rồi khởi chạy.
Ứng dụng vẫn cần thiết bị/emulator đã chạy sẵn.
