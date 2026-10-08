SLOT 1 - Flutter Starter App
Nguồn: Slot1.pdf, trang 7-8

YÊU CẦU ĐỀ
Tạo Flutter app, hiển thị tên sinh viên, mô tả “Why I learn Flutter”, ít nhất hai widget, biến final; chạy emulator và chụp ảnh.

CHẠY TRÊN WINDOWS (có Flutter SDK, Android SDK, Emulator)
1. Giải nén ZIP rồi mở terminal tại thư mục flutter_starter_app (nơi có pubspec.yaml).
2. Chạy `flutter doctor` và đảm bảo Android toolchain + thiết bị được nhận.
3. Chạy `flutter create . --platforms=android` để tạo các file native/Gradle do Flutter SDK trên máy bạn quản lý.
4. Chạy `flutter pub get`.
5. Bật Android Emulator hoặc kết nối điện thoại, kiểm tra `flutter devices`.
6. Chạy `flutter run`.
7. Với Slot 3 (logic-only), thay `flutter run` bằng `dart run lib/main.dart` để xem console trực tiếp.

Lưu ý: Máy tạo bản nộp không cài `flutter`/`dart`, nên chưa thể chạy/biên dịch; file native được tạo từ lệnh flutter create trên SDK đích, không bịa template Android SDK/Gradle. Bản ZIP đã kèm source Flutter, pubspec.yaml và dữ liệu mẫu (nếu đề yêu cầu).

CHECKLIST / KẾT QUẢ MONG ĐỢI (CHƯA ĐƯỢC XÁC NHẬN BẰNG EMULATOR)
Thấy tên sinh viên và dòng “Why I learn Flutter”. Chụp màn hình trên emulator sau khi chạy (chưa có ảnh thực tế).

PHẠM VI / CHI TIẾT CHƯA RÕ
Đề không cung cấp tên sinh viên. Trong code đặt chuỗi mẫu "Tên sinh viên" để người học thay theo danh tính; chưa chụp được màn hình.

TÙY CHỌN DỄ CHẠY TRÊN WINDOWS
Nhấn RUN_WINDOWS.bat từ thư mục gốc dự án; script dùng Flutter SDK đã cài trên máy,
tạo scaffold Android theo phiên bản SDK của máy, cài dependencies, rồi khởi chạy.
Ứng dụng vẫn cần thiết bị/emulator đã chạy sẵn.
