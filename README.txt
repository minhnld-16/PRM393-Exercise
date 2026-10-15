SLOT 3 - Student Data Processor (Logic-only)
Nguồn: Slot3(1).pdf, trang 40-46 (Bài tập tổng hợp 1)

YÊU CẦU ĐỀ
Dart logic-only: Student(id,name,age,gpa,major), dữ liệu mẫu, thêm, cập nhật GPA, lọc GPA cao với where, định dạng qua map + callback và log.

CHẠY TRÊN WINDOWS (có Flutter SDK, Android SDK, Emulator)
1. Giải nén ZIP rồi mở terminal tại thư mục student_data_processor (nơi có pubspec.yaml).
2. Chạy `flutter doctor` và đảm bảo Android toolchain + thiết bị được nhận.
3. Chạy `flutter create . --platforms=android` để tạo các file native/Gradle do Flutter SDK trên máy bạn quản lý.
4. Chạy `flutter pub get`.
5. Bật Android Emulator hoặc kết nối điện thoại, kiểm tra `flutter devices`.
6. Chạy `flutter run`.
7. Với Slot 3 (logic-only), thay `flutter run` bằng `dart run lib/main.dart` để xem console trực tiếp.

Lưu ý: Máy tạo bản nộp không cài `flutter`/`dart`, nên chưa thể chạy/biên dịch; file native được tạo từ lệnh flutter create trên SDK đích, không bịa template Android SDK/Gradle. Bản ZIP đã kèm source Flutter, pubspec.yaml và dữ liệu mẫu (nếu đề yêu cầu).

CHECKLIST / KẾT QUẢ MONG ĐỢI (CHƯA ĐƯỢC XÁC NHẬN BẰNG EMULATOR)
Console dự kiến: An - GPA: 3.6; Binh - GPA: 3.8; Dung - GPA: 3.5 (theo đúng thứ tự dữ liệu mẫu).

PHẠM VI / CHI TIẾT CHƯA RÕ
Đề không đưa ví dụ stdout minh bạch (vùng ảnh kết quả); README nêu output suy ra từ dữ liệu mẫu và logic, KHÔNG phải log chạy thật.

TÙY CHỌN DỄ CHẠY TRÊN WINDOWS
Nhấn RUN_WINDOWS.bat từ thư mục gốc dự án; script dùng Flutter SDK đã cài trên máy,
tạo scaffold Android theo phiên bản SDK của máy, cài dependencies, rồi khởi chạy.
Ứng dụng vẫn cần thiết bị/emulator đã chạy sẵn.
