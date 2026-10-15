# Lab 5 — Favorite Shopping Items

Ứng dụng Flutter quản lý sản phẩm yêu thích, lưu SQLite trên Windows/Android/iOS. Lần đầu mở danh sách trống; dữ liệu không tự tạo để tránh ảnh hưởng bài demo.

## Chạy trên Windows

Máy cần Flutter trong PATH và Visual Studio có Desktop development with C++. Bản QC đã build và chạy bằng Flutter 3.47.3 / Dart 3.13.3 trên Windows; dependency hiện yêu cầu Dart 3.12 trở lên.

Mở PowerShell tại thư mục dự án:

```powershell
.\RUN_WINDOWS.bat
```

Hoặc chạy thủ công:

```powershell
flutter pub get
flutter run -d windows
```

Các lần sau chỉ cần `flutter run -d windows`. Trong VS Code, chọn cấu hình **Lab 5 - Windows**, nhấn F5. Script mặc định chọn Windows nên không cần emulator. Không tạo lại platform mỗi lần chạy.

Build bản phát hành:

```powershell
flutter build windows --release
```

Ứng dụng ở `build\windows\x64\runner\Release\lab5.exe`. Khi chuyển sang máy khác phải sao chép toàn bộ thư mục Release, bao gồm DLL và data.

## Android / iOS

Android scaffold đã có. Khởi động emulator hoặc cắm điện thoại, rồi:

```powershell
flutter devices
flutter run -d <device-id>
```

Có thể dùng `.\RUN_WINDOWS.bat <device-id>`. Nếu doctor báo chưa chấp nhận Android SDK licenses, chạy `flutter doctor --android-licenses` và đọc/chấp nhận điều khoản trên máy. Android chưa được QC thực tế trong đợt kiểm tra này.

iOS cần macOS/Xcode; chạy `flutter create --project-name lab5 --platforms=ios --no-pub .` trước lần chạy đầu. SQLite desktop dùng `sqflite_common_ffi`; mobile dùng SQLite native. Không chạy bản web vì chưa có SQLite cho trình duyệt.

## Kiểm tra

```powershell
flutter test
flutter analyze
```

Flutter 3.47.3 có thể làm analyzer lỗi giao thức khi đường dẫn chứa ký tự tiếng Việt (ví dụ BÀI TẬP). Nếu gặp lỗi này, dùng ổ đĩa tạm còn trống, ví dụ Q:

```powershell
subst Q: "$PWD"
Push-Location Q:\
flutter analyze
Pop-Location
subst Q: /D
```

Test bao gồm model, parser giá và luồng UI với SQLite thực trong thư mục tạm: danh sách trống, Cancel, validation, thêm sản phẩm, tổng Wishlist, đổi trạng thái hai chiều, hủy/xác nhận xóa và đóng/mở lại DB. Ảnh QC được tạo ở `build/qc/` khi chạy test trên Windows.

## Đối chiếu ảnh mẫu

- Home: banner màu pastel, tiêu đề Favorite Shopping Items phủ trên banner, thẻ trắng gọn, giá tím, trạng thái xanh/cam, nút + tròn tím và thanh Home/Wishlist.
- Add: Item Name, Category, Price, Status; Save xanh, Cancel xám; validation bằng hộp thoại Error và lỗi tại trường.
- Detail: ID, Category, Price, Status; đổi trạng thái, Delete đỏ, Back xám; xác nhận trước khi xóa.
- Wishlist: tiêu đề trái tim cam, danh sách đánh số, giá cam, Total Estimate ngay sau danh sách và tổng chỉ tính sản phẩm Wishlist.
- Thông báo thêm/xóa thành công dùng hộp thoại Success.

Banner được dựng lại bằng widget vì không có ảnh banner gốc trong ảnh chụp đề bài. Vì vậy bố cục/màu đã được đưa gần ảnh mẫu, nhưng không khẳng định khớp từng pixel. Dữ liệu mẫu trong `resources/sample_items.csv` để nhập thủ công.

## Cấu trúc

`lib/data/` chứa model, SQLite và repository; `lib/presentation/` chứa Home/Add/Detail/Wishlist và widget chung; `lib/core/` chứa theme, định dạng VND và parser giá. Trên Windows, dữ liệu nằm ở `%LOCALAPPDATA%\Lab5\FavoriteShoppingItems\favorite_shopping_items.db`, nên không phụ thuộc thư mục mở terminal. DB là `favorite_shopping_items.db`, bảng `shopping_items`, gồm id, itemName, category, price và status. Dữ liệu lưu qua các lần mở ứng dụng; nút xóa chỉ tác động sản phẩm đã xác nhận.
