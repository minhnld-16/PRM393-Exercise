SLOT 4 - Async Product Loader
Nguồn: Slot4.pdf, trang 34-46 (Bài tập tổng hợp 1)

YÊU CẦU ĐỀ
Fake API Future<List<Item>> chờ 2 giây, dùng async/await, ListView qua FutureBuilder với loading/data/error.

CHẠY TRÊN WINDOWS (có Flutter SDK, Android SDK, Emulator)
1. Giải nén ZIP rồi mở terminal tại thư mục async_product_loader (nơi có pubspec.yaml).
2. Chạy `flutter doctor` và đảm bảo Android toolchain + thiết bị được nhận.
3. Chạy `flutter create . --platforms=android` để tạo các file native/Gradle do Flutter SDK trên máy bạn quản lý.
4. Chạy `flutter pub get`.
5. Bật Android Emulator hoặc kết nối điện thoại, kiểm tra `flutter devices`.
6. Chạy `flutter run`.
7. Với Slot 3 (logic-only), thay `flutter run` bằng `dart run lib/main.dart` để xem console trực tiếp.

Lưu ý: Máy tạo bản nộp không cài `flutter`/`dart`, nên chưa thể chạy/biên dịch; file native được tạo từ lệnh flutter create trên SDK đích, không bịa template Android SDK/Gradle. Bản ZIP đã kèm source Flutter, pubspec.yaml và dữ liệu mẫu (nếu đề yêu cầu).

CHECKLIST / KẾT QUẢ MONG ĐỢI (CHƯA ĐƯỢC XÁC NHẬN BẰNG EMULATOR)
Khi chạy thấy loading khoảng 2 giây, sau đó danh sách Táo 10000, Cam 15000, Chuối 8000; console log trước/sau Future.

PHẠM VI / CHI TIẾT CHƯA RÕ
Các bước thử bỏ await là thí nghiệm cố tình sai; bản nộp giữ phiên bản await đúng, không trộn ví dụ sai vào sản phẩm.

TÙY CHỌN DỄ CHẠY TRÊN WINDOWS
Nhấn RUN_WINDOWS.bat từ thư mục gốc dự án; script dùng Flutter SDK đã cài trên máy,
tạo scaffold Android theo phiên bản SDK của máy, cài dependencies, rồi khởi chạy.
Ứng dụng vẫn cần thiết bị/emulator đã chạy sẵn.
