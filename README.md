# Hệ Thống Đặt Phòng Khách Sạn

Một hệ thống đặt phòng khách sạn toàn diện được xây dựng bằng Java Servlets, JSP và SQL Server, cho phép người dùng đặt phòng, quản lý đặt phòng và thanh toán hóa đơn.

## Tổng Quan

Dự án này triển khai một nền tảng đặt phòng khách sạn cho phép người dùng đăng ký tài khoản, tìm kiếm và đặt phòng khách sạn, quản lý đặt phòng, thanh toán hóa đơn, và cung cấp các công cụ thống kê cho quản trị viên. Hệ thống tuân theo mô hình kiến trúc MVC để phân tách rõ ràng các thành phần và dễ bảo trì.

## Tính Năng Chính

### 1. Quản Lý Người Dùng & Xác Thực (Sinh viên 1)

- **Đăng Ký**

  - Tạo tài khoản mới với thông tin: Họ tên, email, mật khẩu, xác nhận mật khẩu, số điện thoại
  - Xác thực thông tin đầu vào

- **Đăng Nhập**

  - Đăng nhập hệ thống với email và mật khẩu
  - Tùy chọn ghi nhớ đăng nhập

- **Quên Mật Khẩu**

  - Gửi email reset mật khẩu
  - Xác nhận bằng mã xác nhận
  - Đặt mật khẩu mới

- **Hồ Sơ Cá Nhân**

  - Cập nhật thông tin: Họ tên, ảnh đại diện, số điện thoại, giới tính, ngày sinh

- **Đổi Mật Khẩu**

  - Thay đổi mật khẩu với xác nhận mật khẩu cũ

- **Quản Lý Vai Trò Người Dùng**
  - Phân quyền (admin, khách đặt lịch, nhân viên)
  - Gán quyền và hiển thị danh sách người dùng

### 2. Chức Năng Đặt Phòng & Quản Lý Đặt Phòng (Sinh viên 2)

- **Tìm Kiếm Phòng**

  - Tìm kiếm phòng theo tiêu chí: Ngày check-in/check-out, loại phòng, số người
  - Hiển thị danh sách phòng phù hợp với bộ lọc

- **Đặt Phòng Mới**

  - Chọn phòng và thời gian lưu trú
  - Thông tin bao gồm: Ngày check-in, ngày check-out, loại phòng, số người, yêu cầu đặc biệt

- **Danh Sách Đặt Phòng**

  - Hiển thị toàn bộ đặt phòng với thông tin: Mã đặt phòng, ngày check-in/check-out, loại phòng, trạng thái
  - Chức năng hủy đặt phòng

- **Hủy Đặt Phòng**

  - Xác nhận hủy đặt phòng, cập nhật trạng thái
  - Nhập lý do hủy và chính sách hoàn tiền

- **Chi Tiết Đặt Phòng**

  - Hiển thị thông tin chi tiết: Mã đặt phòng, thông tin khách hàng, thông tin phòng, thời gian lưu trú, trạng thái

- **Lịch Sử Đặt Phòng**
  - Xem toàn bộ lịch sử đặt phòng
  - Tìm kiếm và phân trang

### 3. Thanh Toán Hóa Đơn & Quản Lý Giao Dịch (Sinh viên 3)

- **Danh Sách Hóa Đơn**

  - Quản lý tất cả các hóa đơn trong hệ thống
  - Thông tin: Mã hóa đơn, khách hàng, tổng tiền, trạng thái thanh toán, ngày tạo

- **Chi Tiết Hóa Đơn**

  - Hiển thị chi tiết hóa đơn
  - Thông tin: Thông tin đặt phòng, danh sách dịch vụ, phí phát sinh, thuế, tổng tiền

- **Thanh Toán Hóa Đơn**

  - Xử lý thanh toán với nhiều phương thức (tiền mặt, thẻ tín dụng, chuyển khoản)
  - Ghi nhận thông tin thanh toán và cập nhật trạng thái

- **Lịch Sử Giao Dịch**

  - Xem lịch sử các giao dịch thanh toán
  - Thông tin: Mã giao dịch, phương thức thanh toán, số tiền, ngày thanh toán, trạng thái

- **Xuất Hóa Đơn**
  - Tạo và xuất hóa đơn dưới dạng PDF
  - Tùy chọn gửi hóa đơn qua email cho khách hàng

### 4. Thống Kê & Báo Cáo (Sinh viên 4)

- **Tổng Quan Đặt Phòng**

  - Biểu đồ số lượng đặt phòng theo ngày, tháng, quý
  - Hiển thị số lượt đặt phòng, số lượt hủy, tỷ lệ lấp đầy

- **Thống Kê Theo Loại Phòng**

  - Phân tích doanh thu theo từng loại phòng
  - Thông tin: Loại phòng, số lượt đặt, doanh thu, % tăng trưởng

- **Thống Kê Doanh Thu**

  - Biểu đồ doanh thu theo thời gian (ngày, tuần, tháng, năm)
  - Phân tích doanh thu theo nguồn (đặt phòng, dịch vụ, phụ thu)

- **Thống Kê Theo Khách Hàng**

  - Top khách hàng đặt phòng nhiều nhất
  - Thông tin: Tên khách hàng, số lượt đặt, tổng chi tiêu, tỷ lệ hủy

- **Xuất Báo Cáo Excel/PDF**
  - Tùy chọn lọc theo thời gian, loại phòng, nguồn doanh thu
  - Chức năng xuất file và gửi email tự động

## Công Nghệ Sử Dụng

- **Backend**: Java Servlets, JSP
- **Frontend**: HTML, CSS, JavaScript, Bootstrap
- **Cơ Sở Dữ Liệu**: Microsoft SQL Server
- **Máy Chủ**: Apache Tomcat 10.1.x
- **Xác Thực**: Triển khai tùy chỉnh với mã hóa mật khẩu
- **Thanh Toán**: Tích hợp cổng thanh toán (VNPay, Momo)
- **Biểu Đồ**: Chart.js
- **Xuất Báo Cáo**: Apache POI (Excel), iText (PDF)
- **Gửi Email**: JavaMail API

## Cấu Trúc Dự Án

```
BookingSystem/
├── src/
│   └── java/
│       ├── controller/    # Bộ điều khiển Servlet
│       ├── dao/           # Các đối tượng truy cập dữ liệu
│       ├── database/      # Tiện ích kết nối cơ sở dữ liệu
│       ├── model/         # Mô hình dữ liệu
│       └── util/          # Các lớp tiện ích
├── web/
│   ├── WEB-INF/
│   │   ├── views/         # Các file JSP
│   │   └── web.xml        # Cấu hình ứng dụng web
│   ├── css/               # Stylesheets
│   ├── js/                # Các file JavaScript
│   └── images/            # Tài nguyên hình ảnh
└── README.md              # Tài liệu dự án
```

## Cấu Trúc Cơ Sở Dữ Liệu

Ứng dụng sử dụng các bảng chính sau:

- **Users**: Lưu trữ thông tin tài khoản người dùng (id, họ tên, email, mật khẩu, số điện thoại, giới tính, ngày sinh, vai trò, trạng thái)
- **Hotels**: Thông tin khách sạn (id, tên, địa chỉ, mô tả, số sao, tiện ích, hình ảnh)
- **RoomTypes**: Loại phòng (id, tên loại, mô tả, giá, sức chứa, diện tích, hình ảnh)
- **Rooms**: Thông tin phòng (id, số phòng, khách sạn id, loại phòng id, tầng, trạng thái)
- **Bookings**: Thông tin đặt phòng (id, người dùng id, phòng id, ngày check-in, ngày check-out, số người, yêu cầu đặc biệt, trạng thái, lý do hủy)
- **Invoices**: Hóa đơn thanh toán (id, đặt phòng id, tổng tiền, thuế, phí phát sinh, trạng thái thanh toán, ngày tạo)
- **Payments**: Thông tin thanh toán (id, hóa đơn id, phương thức thanh toán, số tiền, ngày thanh toán, trạng thái, mã giao dịch)

## Hướng Dẫn Cài Đặt

### Yêu Cầu Hệ Thống

- JDK 11 trở lên
- Apache Tomcat 10.1.x
- Microsoft SQL Server
- SQL Server JDBC Driver

### Thiết Lập Cơ Sở Dữ Liệu

1. Tạo cơ sở dữ liệu mới trong SQL Server
2. Chạy script SQL để tạo các bảng và dữ liệu mẫu
3. Cấu hình kết nối cơ sở dữ liệu trong `src/java/database/DBContext.java`

### Triển Khai

1. Clone repository
2. Thêm SQL Server JDBC driver vào thư viện của dự án
3. Build dự án
4. Triển khai lên Tomcat
5. Truy cập ứng dụng tại `http://localhost:9999/BookingSystem/`

## Tính Năng Bảo Mật

- Mã hóa mật khẩu với salt để lưu trữ an toàn
- Xác thực đầu vào để ngăn chặn SQL injection
- Quản lý phiên cho người dùng đã xác thực
- Kiểm soát truy cập dựa trên vai trò
- Bảo vệ chống tấn công CSRF



## Người Đóng Góp

- **Sinh viên 1**: Phạm Xuân Hiếu _ HE150075 - Quản lý người dùng & xác thực
- **Sinh viên 2**: Mai Tiến Dũng _ HE186519 - Chức năng đặt lịch & quản lý lịch cá nhân
- **Sinh viên 3**: Phạm Quốc Tuấn _ HE181869 - Quản lý dịch vụ & nhân sự
- **Sinh viên 4**: Lê Anh Minh _ HE180621 - Thống kê & báo cáo

## Giấy Phép

[Chỉ định thông tin giấy phép của bạn tại đây]

---

## Lời Cảm Ơn

- [Liệt kê các thư viện, tài nguyên hoặc nguồn cảm hứng]
