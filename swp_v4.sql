DROP DATABASE IF EXISTS BookingHotel_v4;
CREATE DATABASE BookingHotel_v4;
USE BookingHotel_v4;

-- Bảng người dùng
CREATE TABLE Users (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_name NVARCHAR(50),
    pass NVARCHAR(255),
    full_name NVARCHAR(100),
    birth DATE,
    gender NVARCHAR(10),
    email NVARCHAR(100),
    phone NVARCHAR(20),
    address NVARCHAR(MAX),
    role NVARCHAR(20),
    avatar_url NVARCHAR(255),
    isDeleted BIT DEFAULT 0
);

-- Bảng loại phòng
CREATE TABLE RoomTypes (
    id INT PRIMARY KEY IDENTITY(1,1),
    room_type NVARCHAR(100)
);

-- Bảng phòng
CREATE TABLE Rooms (
    id INT PRIMARY KEY IDENTITY(1,1),
    room_number NVARCHAR(20),
    room_type_id INT,
    room_price DECIMAL(10, 2),
    room_status NVARCHAR(20),
    capacity INT,
    description NVARCHAR(MAX),
    image_url NVARCHAR(MAX),
    floor INT,
    isDelete BIT DEFAULT 0,
    FOREIGN KEY (room_type_id) REFERENCES RoomTypes(id)
);

-- Đánh giá phòng
CREATE TABLE RoomReviews (
    id INT PRIMARY KEY IDENTITY(1,1),
    room_id INT,
    quality INT CHECK (quality BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    FOREIGN KEY (room_id) REFERENCES Rooms(id)
);

-- Bảng loại dịch vụ
CREATE TABLE ServiceTypes (
    id INT PRIMARY KEY IDENTITY(1,1),
    service_type NVARCHAR(100)
);

-- Bảng dịch vụ
CREATE TABLE Services (
    id INT PRIMARY KEY IDENTITY(1,1),
    service_name NVARCHAR(100),
    service_type_id INT,
    service_price DECIMAL(10, 2),
    description NVARCHAR(MAX),
    image_url NVARCHAR(MAX),
    isDeleted BIT DEFAULT 0
    FOREIGN KEY (service_type_id) REFERENCES ServiceTypes(id)
);

-- Đánh giá dịch vụ
CREATE TABLE ServiceReviews (
    id INT PRIMARY KEY IDENTITY(1,1),
    service_id INT,
    quality INT CHECK (quality BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    FOREIGN KEY (service_id) REFERENCES Services(id)
);

-- Bảng khuyến mãi
CREATE TABLE Promotion (
    id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(100),
    percentage DECIMAL(5, 2),
    start_at DATE,
    end_at DATE,
    description NVARCHAR(MAX)
);

-- Bảng đặt phòng
CREATE TABLE Bookings (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    promotion_id INT NULL,
    total_prices DECIMAL(10, 2),
    status NVARCHAR(20) DEFAULT 'Pending', -- Trạng thái booking
    room_review_id INT NULL,
    service_review_id INT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (promotion_id) REFERENCES Promotion(id)
);

-- Chi tiết đặt phòng
CREATE TABLE BookingRoomDetails (
    id INT PRIMARY KEY IDENTITY(1,1),
    booking_id INT,
    room_id INT,
    check_in_date DATE,
    check_out_date DATE,
    quantity INT,
    prices DECIMAL(10, 2),
    FOREIGN KEY (booking_id) REFERENCES Bookings(id),
    FOREIGN KEY (room_id) REFERENCES Rooms(id)
);

-- Chi tiết đặt dịch vụ
CREATE TABLE BookingServiceDetail (
    id INT PRIMARY KEY IDENTITY(1,1),
    booking_id INT,
    service_id INT,
    quantity INT,
    prices DECIMAL(10, 2),
    FOREIGN KEY (booking_id) REFERENCES Bookings(id),
    FOREIGN KEY (service_id) REFERENCES Services(id)
);

-- Bảng giao dịch thanh toán
CREATE TABLE Transactions (
    id INT PRIMARY KEY IDENTITY(1,1),
    booking_id INT,
    transaction_date DATETIME DEFAULT GETDATE(),
    amount DECIMAL(10, 2),
    payment_method NVARCHAR(50),
    status NVARCHAR(20), -- Ví dụ: Paid, Pending, Failed
    FOREIGN KEY (booking_id) REFERENCES Bookings(id)
);


--bảng thanh toán dịch vụ
CREATE TABLE [dbo].[ServiceBookings] (
    [id] INT IDENTITY(1,1) NOT NULL,  -- Khóa chính, tự tăng
    [user_id] INT NOT NULL,           -- ID người dùng, giả sử là khóa ngoại
    [service_id] INT NOT NULL,        -- ID dịch vụ, giả sử là khóa ngoại
    [booking_date] DATETIME NOT NULL, -- Ngày đặt dịch vụ
    [quantity] INT NOT NULL,          -- Số lượng
    [note] NVARCHAR(500) NULL,        -- Ghi chú (có thể NULL, độ dài tối đa 500 ký tự)
    [total_amount] DECIMAL(18,2) NOT NULL, -- Tổng tiền, kiểu số thập phân với 2 chữ số sau dấu phẩy
    [status] VARCHAR(50) NOT NULL,    -- Trạng thái (ví dụ: 'Pending', 'Completed')
    [created_at] DATETIME NOT NULL DEFAULT GETDATE(),  -- Thời gian tạo, mặc định là thời gian hiện tại
    [updated_at] DATETIME NULL DEFAULT GETDATE(),      -- Thời gian cập nhật, có thể NULL hoặc mặc định

ALTER TABLE [dbo].[ServiceBookings]
ADD CONSTRAINT FK_ServiceBookings_Users FOREIGN KEY ([user_id]) REFERENCES [dbo].[Users]([id]);

ALTER TABLE [dbo].[ServiceBookings]
ADD CONSTRAINT FK_ServiceBookings_Services FOREIGN KEY ([service_id]) REFERENCES [dbo].[Services]([id]);

-- Dữ liệu cho bảng Users (giữ nguyên)
INSERT INTO Users (user_name, pass, full_name, birth, gender, email, phone, address, role, avatar_url) 
VALUES 
-- password gốc: password123
('nguyenminhquan', 'q5tcb63SSYLuZb5eX0ltbA==', N'Nguyễn Minh Quân', '1990-05-15', 'Male', 'quan.nguyen@email.com', '0123456789', N'123 Đường ABC, Hà Nội', 'Customer', 'images/user/default_avatar.png'),

-- password gốc: password456
('tranthithuy', 'OFvwS0UtlUn9k2qYqH/8gQ==', N'Trần Thị Thúy', '1985-08-25', 'Female', 'thuy.tran@email.com', '0123456780', N'456 Đường XYZ, TP.HCM', 'Admin', 'images/user/default_avatar.png'),

-- password gốc: password123
('lequangthang', 'q5tcb63SSYLuZb5eX0ltbA==', N'Lê Quang Thắng', '1990-11-11', 'Male', 'thang.le@email.com', '0123456789', N'888 Đường XYZ, TP.HCM', 'Reception', 'images/user/default_avatar.png'),
('newuser4', 'xxx', N'Người dùng 4', '1995-01-01', 'Male', 'user4@email.com', '0111111111', N'Địa chỉ', 'Customer', 'images/user/default_avatar.png'),
('newuser5', 'xxx', N'Người dùng 5', '1996-01-01', 'Female', 'user5@email.com', '0111111112', N'Địa chỉ', 'Customer', 'images/user/default_avatar.png');

-- Dữ liệu cho bảng RoomTypes (giữ nguyên)
INSERT INTO RoomTypes (room_type) 
VALUES 
(N'Standard Room'),
(N'Deluxe Room'),
(N'Suite'),
(N'Presidential Suite');

-- Dữ liệu cho bảng Rooms (giữ nguyên)
INSERT INTO Rooms (room_number, room_type_id, room_price, room_status, capacity, description, image_url, floor) 
VALUES 
('101', 1, 500000, N'Available', 2, N'Phòng tiêu chuẩn, đầy đủ tiện nghi', 'https://image.url', 1),
('102', 2, 1000000, N'Occupied', 3, N'Phòng sang trọng với giường lớn', 'https://image.url', 2),
('201', 1, 550000, N'Available', 2, N'Phòng tiêu chuẩn, đầy đủ tiện nghi', 'https://image.url', 1),
('202', 2, 1200000, N'Occupied', 3, N'Phòng sang trọng với giường lớn', 'https://image.url', 2),
('301', 3, 1500000, N'Available', 4, N'Phòng suite với bồn tắm', 'https://image.url', 3),
('302', 3, 1600000, N'Occupied', 4, N'Phòng suite với bồn tắm', 'https://image.url', 3),
('401', 4, 2000000, N'Available', 5, N'Phòng tổng thống với tầm nhìn đẹp', 'https://image.url', 4),
('402', 4, 2100000, N'Available', 5, N'Phòng tổng thống với tầm nhìn đẹp', 'https://image.url', 4),
('501', 1, 530000, N'Available', 2, N'Phòng tiêu chuẩn, thoải mái', 'https://image.url', 5),
('502', 2, 1100000, N'Available', 3, N'Phòng sang trọng, rộng rãi', 'https://image.url', 5);

-- Dữ liệu cho bảng RoomReviews (giữ nguyên)
INSERT INTO RoomReviews (room_id, quality, comment) 
VALUES 
(1, 4, N'Phòng sạch sẽ và tiện nghi.'),
(2, 5, N'Rất thoải mái, dịch vụ tuyệt vời!'),
(3, 3, N'Phòng hơi nhỏ, nhưng vẫn đủ tiện nghi.'),
(4, 5, N'Tuyệt vời, phòng rộng và thoáng mát.'),
(5, 4, N'Phòng đẹp nhưng chưa có dịch vụ phòng 24/7.'),
(6, 2, N'Phòng không được sạch, cần cải thiện.'),
(7, 5, N'Phòng cao cấp, rất đẹp và sang trọng.'),
(8, 4, N'Phòng tốt, nhưng cần cải thiện thêm về ánh sáng.'),
(9, 5, N'Phòng tuyệt vời, sẽ quay lại lần sau.'),
(10, 4, N'Phòng đẹp, nhưng giá hơi cao.');

-- Dữ liệu cho bảng ServiceTypes (giữ nguyên)
INSERT INTO ServiceTypes (service_type) 
VALUES 
(N'Restaurant'),
(N'Spa'),
(N'Gym'),
(N'Shuttle');

-- Dữ liệu cho bảng Services (giữ nguyên)
INSERT INTO Services (service_name, service_type_id, service_price, description, image_url) 
VALUES 
(N'Buffet', 1, 200000, N'Ăn sáng buffet tại nhà hàng', 'https://image.url'),
(N'Spa thư giãn', 2, 500000, N'Massage thư giãn', 'https://image.url'),
(N'Phòng tập', 3, 150000, N'Phòng gym với thiết bị hiện đại', 'https://image.url'),
(N'Dịch vụ đưa đón', 4, 300000, N'Đưa đón khách từ sân bay', 'https://image.url'),
(N'Pizza', 1, 80000, N'Món ăn nhanh tại nhà hàng', 'https://image.url'),
(N'Massage mặt', 2, 250000, N'Massage mặt thư giãn', 'https://image.url'),
(N'Trung tâm thể dục', 3, 120000, N'Đưa khách vào trung tâm thể dục', 'https://image.url'),
(N'Đưa đón sân bay', 4, 400000, N'Dịch vụ đưa đón sân bay', 'https://image.url'),
(N'Chè', 1, 50000, N'Món chè ngọt', 'https://image.url'),
(N'Trị liệu', 2, 600000, N'Dịch vụ trị liệu phục hồi', 'https://image.url');

-- Dữ liệu cho bảng ServiceReviews (giữ nguyên)
INSERT INTO ServiceReviews (service_id, quality, comment) 
VALUES 
(1, 5, N'Dịch vụ ăn uống rất tốt, món ăn ngon miệng.'),
(2, 4, N'Massage thư giãn khá tốt, nhưng không gian có thể cải thiện.'),
(3, 5, N'Phòng gym đầy đủ thiết bị và không gian thoải mái.'),
(4, 5, N'Nhân viên nhiệt tình, đưa đón rất đúng giờ.'),
(5, 4, N'Pizza ngon nhưng cần cải thiện thêm về chất lượng.'),
(6, 5, N'Massage mặt rất thư giãn và tốt cho sức khỏe.'),
(7, 4, N'Phòng tập đầy đủ nhưng còn thiếu thiết bị.'),
(8, 5, N'Dịch vụ đưa đón tuyệt vời, xe đẹp và sạch sẽ.'),
(9, 4, N'Chè ngon nhưng không đa dạng.'),
(10, 5, N'Trị liệu phục hồi tốt, sẽ quay lại lần sau.');

-- Dữ liệu cho bảng Promotion (sửa: thay năm từ 2025 thành 2024 để test với ngày hiện tại)
INSERT INTO Promotion (title, percentage, start_at, end_at, description) 
VALUES 
(N'Giảm giá mùa hè', 10, '2024-06-01', '2024-06-30', N'Khuyến mãi mùa hè, giảm giá 10% cho tất cả các phòng.'),  -- Sửa: thay 2025 thành 2024
(N'Khuyến mãi cuối năm', 20, '2024-12-01', '2024-12-31', N'Mừng lễ cuối năm, giảm giá 20% cho tất cả dịch vụ.'),  -- Sửa: thay 2025 thành 2024
(N'Giảm giá cho khách hàng mới', 15, '2024-05-01', '2024-05-31', N'Tặng 15% cho khách hàng lần đầu sử dụng dịch vụ.'),  -- Sửa: thay 2025 thành 2024
(N'Khuyến mãi phòng VIP', 25, '2024-06-01', '2024-06-15', N'Giảm giá 25% cho các phòng Tổng thống.'),  -- Sửa: thay 2025 thành 2024
(N'Giảm giá cuối tuần', 30, '2024-06-05', '2024-06-07', N'Giảm 30% cho các phòng vào cuối tuần.');  -- Sửa: thay 2025 thành 2024

-- Thêm: Xóa data cũ trước insert để tránh lỗi foreign key khi chạy lại script
DELETE FROM Transactions;
DELETE FROM BookingServiceDetail;
DELETE FROM BookingRoomDetails;
DELETE FROM Bookings;

-- Dữ liệu cho bảng Bookings (sửa: thêm created_at đa dạng trong 2024 để test chart; thêm 5 records nữa để có 10 tổng, với status 'Confirmed' cho chart)
INSERT INTO Bookings (user_id, created_at, promotion_id, total_prices, status, room_review_id, service_review_id) 
VALUES 
(1, '2024-10-01 10:00:00', 1, 4500000, N'Pending', NULL, NULL),  -- ID 1, recent for weekly
(2, '2024-09-30 11:00:00', 2, 3000000, N'Confirmed', 1, 1),     -- ID 2
(3, '2024-09-29 12:00:00', 3, 5000000, N'Confirmed', 2, 2),     -- ID 3
(4, '2024-09-28 13:00:00', 4, 3500000, N'Pending', 3, 3),       -- ID 4
(5, '2024-09-27 14:00:00', 5, 6000000, N'Confirmed', 4, 4),     -- ID 5
(1, '2024-09-26 15:00:00', 1, 2000000, N'Confirmed', NULL, NULL),  -- Thêm: ID 6, for weekly/monthly
(2, '2024-09-25 16:00:00', 2, 2500000, N'Confirmed', NULL, NULL),  -- Thêm: ID 7
(3, '2024-08-15 17:00:00', 3, 3000000, N'Confirmed', NULL, NULL),  -- Thêm: ID 8, for monthly
(4, '2023-07-10 18:00:00', 4, 4000000, N'Confirmed', NULL, NULL),  -- Thêm: ID 9, for yearly
(5, '2022-06-05 19:00:00', 5, 5000000, N'Confirmed', NULL, NULL);  -- Thêm: ID 10, for yearly

-- Dữ liệu cho bảng BookingRoomDetails (sửa: dùng booking_id 1-5 thay vì 5-9; thêm records cho ID 6-10 để đầy đủ, ngày đa dạng trong 2024)
INSERT INTO BookingRoomDetails (booking_id, room_id, check_in_date, check_out_date, quantity, prices) 
VALUES 
(1, 1, '2024-10-02', '2024-10-04', 1, 1000000),  -- Sửa: booking_id từ 5 thành 1
(2, 2, '2024-09-30', '2024-10-02', 1, 1200000),  -- Sửa: booking_id từ 6 thành 2
(3, 3, '2024-09-29', '2024-10-01', 2, 1100000),  -- Sửa: booking_id từ 7 thành 3
(4, 5, '2024-09-28', '2024-09-30', 1, 1500000),  -- Sửa: booking_id từ 8 thành 4
(5, 7, '2024-09-27', '2024-09-29', 1, 2000000),  -- Sửa: booking_id từ 9 thành 5
(6, 1, '2024-09-26', '2024-09-28', 1, 1000000),  -- Thêm: cho ID 6
(7, 2, '2024-09-25', '2024-09-27', 1, 1200000),  -- Thêm: cho ID 7
(8, 3, '2024-08-16', '2024-08-18', 1, 1100000),  -- Thêm: cho ID 8
(9, 5, '2023-07-11', '2023-07-13', 1, 1500000),  -- Thêm: cho ID 9
(10, 7, '2022-06-06', '2022-06-08', 1, 2000000); -- Thêm: cho ID 10

-- Dữ liệu cho bảng BookingServiceDetail (sửa: dùng booking_id 1-5 thay vì 5-9; thêm records cho ID 6-10)
INSERT INTO BookingServiceDetail (booking_id, service_id, quantity, prices) 
VALUES 
(1, 1, 1, 200000),  -- Sửa: booking_id từ 5 thành 1
(2, 2, 1, 500000),  -- Sửa: booking_id từ 6 thành 2
(3, 3, 1, 150000),  -- Sửa: booking_id từ 7 thành 3
(4, 4, 1, 300000),  -- Sửa: booking_id từ 8 thành 4
(5, 5, 1, 80000),   -- Sửa: booking_id từ 9 thành 5
(6, 1, 1, 200000),  -- Thêm: cho ID 6
(7, 2, 1, 500000),  -- Thêm: cho ID 7
(8, 3, 1, 150000),  -- Thêm: cho ID 8
(9, 4, 1, 300000),  -- Thêm: cho ID 9
(10, 5, 1, 80000);  -- Thêm: cho ID 10

-- Dữ liệu cho bảng Transactions (sửa: dùng booking_id 1-5 thay vì 5-9; thêm records cho ID 6-10 với transaction_date đa dạng trong 2024, status 'Paid' cho chart)
INSERT INTO Transactions (booking_id, transaction_date, amount, payment_method, status) 
VALUES 
(1, '2024-10-01 12:00:00', 4500000, N'Credit Card', N'Paid'),  -- Sửa: booking_id từ 5 thành 1, thay ngày từ 2025 thành 2024
(2, '2024-09-30 13:00:00', 3000000, N'Cash', N'Paid'),         -- Sửa: booking_id từ 6 thành 2, thay ngày từ 2025 thành 2024
(3, '2024-09-29 14:00:00', 5000000, N'Credit Card', N'Paid'),  -- Sửa: booking_id từ 7 thành 3, thay ngày từ 2025 thành 2024
(4, '2024-09-28 15:00:00', 3500000, N'Cash', N'Pending'),      -- Sửa: booking_id từ 8 thành 4, thay ngày từ 2025 thành 2024
(5, '2024-09-27 16:00:00', 6000000, N'Credit Card', N'Paid'),  -- Sửa: booking_id từ 9 thành 5, thay ngày từ 2025 thành 2024
(6, '2024-09-26 17:00:00', 2000000, N'Credit Card', N'Paid'),  -- Thêm: cho ID 6, ngày trong 2024 cho test chart
(7, '2024-09-25 18:00:00', 2500000, N'Cash', N'Paid'),         -- Thêm: cho ID 7
(8, '2024-08-15 19:00:00', 3000000, N'Credit Card', N'Paid'),  -- Thêm: cho ID 8, cho monthly
(9, '2023-07-10 20:00:00', 4000000, N'Cash', N'Paid'),         -- Thêm: cho ID 9, cho yearly
(10, '2022-06-05 21:00:00', 5000000, N'Credit Card', N'Paid'); -- Thêm: cho ID 10, cho yearly

-- Query kiểm tra phòng available 
USE BookingHotel_v4;
GO

DECLARE @check_in DATE = '2025-06-06';
DECLARE @check_out DATE = '2025-06-06';

SELECT *
FROM Rooms r
WHERE r.room_status != N'Maintenance'
  AND r.isDelete = 0
  AND NOT EXISTS (
      SELECT 1
      FROM BookingRoomDetails brd
      JOIN Bookings b ON brd.booking_id = b.id
      WHERE brd.room_id = r.id
        --AND b.status IN (N'Pending', N'Confirmed') -- trạng thái giữ phòng
        AND (
            @check_in < brd.check_out_date AND @check_out > brd.check_in_date
        )
  );