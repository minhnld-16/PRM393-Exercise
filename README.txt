SLOT 5 - Live Counter Stream
Nguồn: Slot5.pdf, trang 22-26 (Bài tập tổng hợp 1)

YÊU CẦU ĐỀ
StreamController phát counter mỗi giây, StreamBuilder loading/data/error; không setState; hủy Timer và đóng stream.

CHẠY TRÊN WINDOWS (có Flutter SDK, Android SDK, Emulator)
1. Giải nén ZIP rồi mở terminal tại thư mục live_counter_stream (nơi có pubspec.yaml).
2. Chạy `flutter doctor` và đảm bảo Android toolchain + thiết bị được nhận.
3. Chạy `flutter create . --platforms=android` để tạo các file native/Gradle do Flutter SDK trên máy bạn quản lý.
4. Chạy `flutter pub get`.
5. Bật Android Emulator hoặc kết nối điện thoại, kiểm tra `flutter devices`.
6. Chạy `flutter run`.
7. Với Slot 3 (logic-only), thay `flutter run` bằng `dart run lib/main.dart` để xem console trực tiếp.

Lưu ý: Máy tạo bản nộp không cài `flutter`/`dart`, nên chưa thể chạy/biên dịch; file native được tạo từ lệnh flutter create trên SDK đích, không bịa template Android SDK/Gradle. Bản ZIP đã kèm source Flutter, pubspec.yaml và dữ liệu mẫu (nếu đề yêu cầu).

CHECKLIST / KẾT QUẢ MONG ĐỢI (CHƯA ĐƯỢC XÁC NHẬN BẰNG EMULATOR)
Lúc đầu loading, sau khoảng 1 giây Counter: 1, sau 2 giây Counter: 2; không dùng setState.

PHẠM VI / CHI TIẾT CHƯA RÕ
Bài tập mở rộng (Pause/Resume, addError) là tùy chọn, không làm; UI vẫn có nhánh lỗi như đề.

TÙY CHỌN DỄ CHẠY TRÊN WINDOWS
Nhấn RUN_WINDOWS.bat từ thư mục gốc dự án; script dùng Flutter SDK đã cài trên máy,
tạo scaffold Android theo phiên bản SDK của máy, cài dependencies, rồi khởi chạy.
Ứng dụng vẫn cần thiết bị/emulator đã chạy sẵn.
