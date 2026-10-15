SLOT 9 - Simple Product Dashboard App
Nguồn: Slot 9.pdf, trang 21-32 (Bài tập tổng hợp 1)

YÊU CẦU ĐỀ
Dashboard Flex Row/Column/Expanded/Stack badge, Product Grid 2 cột 10 item, named route /products; iOS URL Scheme chỉ nhận thức không yêu cầu triển khai native.

CHẠY TRÊN WINDOWS (có Flutter SDK, Android SDK, Emulator)
1. Giải nén ZIP rồi mở terminal tại thư mục simple_dashboard_app (nơi có pubspec.yaml).
2. Chạy `flutter doctor` và đảm bảo Android toolchain + thiết bị được nhận.
3. Chạy `flutter create . --platforms=android` để tạo các file native/Gradle do Flutter SDK trên máy bạn quản lý.
4. Chạy `flutter pub get`.
5. Bật Android Emulator hoặc kết nối điện thoại, kiểm tra `flutter devices`.
6. Chạy `flutter run`.
7. Với Slot 3 (logic-only), thay `flutter run` bằng `dart run lib/main.dart` để xem console trực tiếp.

Lưu ý: Máy tạo bản nộp không cài `flutter`/`dart`, nên chưa thể chạy/biên dịch; file native được tạo từ lệnh flutter create trên SDK đích, không bịa template Android SDK/Gradle. Bản ZIP đã kèm source Flutter, pubspec.yaml và dữ liệu mẫu (nếu đề yêu cầu).

CHECKLIST / KẾT QUẢ MONG ĐỢI (CHƯA ĐƯỢC XÁC NHẬN BẰNG EMULATOR)
Dashboard có chào và badge; button mở Grid 2 cột; cuộn các sản phẩm Product #0…#9; Back về Dashboard.

PHẠM VI / CHI TIẾT CHƯA RÕ
iOS URL Scheme được ghi rõ chỉ học concept, không bắt buộc cấu hình iOS; không cấu hình native.

TÙY CHỌN DỄ CHẠY TRÊN WINDOWS
Nhấn RUN_WINDOWS.bat từ thư mục gốc dự án; script dùng Flutter SDK đã cài trên máy,
tạo scaffold Android theo phiên bản SDK của máy, cài dependencies, rồi khởi chạy.
Ứng dụng vẫn cần thiết bị/emulator đã chạy sẵn.
