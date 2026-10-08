SLOT 10 - Responsive Dashboard App
Nguồn: Slot 10_1.pdf, trang 22-44 (Bài tập tổng hợp)

YÊU CẦU ĐỀ
Responsive Dashboard: MediaQuery spacing/font, LayoutBuilder Summary Row/Column ngưỡng 600, Grid 2/3/4 cột, ellipsis và kiểm tra layout.

CHẠY TRÊN WINDOWS (có Flutter SDK, Android SDK, Emulator)
1. Giải nén ZIP rồi mở terminal tại thư mục responsive_dashboard (nơi có pubspec.yaml).
2. Chạy `flutter doctor` và đảm bảo Android toolchain + thiết bị được nhận.
3. Chạy `flutter create . --platforms=android` để tạo các file native/Gradle do Flutter SDK trên máy bạn quản lý.
4. Chạy `flutter pub get`.
5. Bật Android Emulator hoặc kết nối điện thoại, kiểm tra `flutter devices`.
6. Chạy `flutter run`.
7. Với Slot 3 (logic-only), thay `flutter run` bằng `dart run lib/main.dart` để xem console trực tiếp.

Lưu ý: Máy tạo bản nộp không cài `flutter`/`dart`, nên chưa thể chạy/biên dịch; file native được tạo từ lệnh flutter create trên SDK đích, không bịa template Android SDK/Gradle. Bản ZIP đã kèm source Flutter, pubspec.yaml và dữ liệu mẫu (nếu đề yêu cầu).

CHECKLIST / KẾT QUẢ MONG ĐỢI (CHƯA ĐƯỢC XÁC NHẬN BẰNG EMULATOR)
Ở width <600 summary xếp dọc, >=600 xếp ngang; Grid <600:2 cột, <900:3, >=900:4; chữ dài bị ellipsis.

PHẠM VI / CHI TIẾT CHƯA RÕ
Đề có yêu cầu khảo sát UI lỗi ban đầu; ZIP chứa phiên bản refactor cuối để có thể chạy; checklist so sánh trên emulator vẫn cần người học thực hiện.

TÙY CHỌN DỄ CHẠY TRÊN WINDOWS
Nhấn RUN_WINDOWS.bat từ thư mục gốc dự án; script dùng Flutter SDK đã cài trên máy,
tạo scaffold Android theo phiên bản SDK của máy, cài dependencies, rồi khởi chạy.
Ứng dụng vẫn cần thiết bị/emulator đã chạy sẵn.
