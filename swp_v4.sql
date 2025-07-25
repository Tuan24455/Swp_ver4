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


CREATE TABLE ServiceBookings (
        id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT NOT NULL,
        service_id INT NOT NULL,
        booking_date DATETIME NOT NULL,
        usage_date DATE NOT NULL,
        quantity INT NOT NULL DEFAULT 1,
        total_amount DECIMAL(10, 2) NOT NULL,
        status NVARCHAR(50) NOT NULL DEFAULT 'Pending',
        created_at DATETIME NOT NULL DEFAULT GETDATE(),
        note NVARCHAR(MAX) NULL,
        
        -- Foreign key constraints
        CONSTRAINT FK_ServiceBookings_Users FOREIGN KEY (user_id) REFERENCES Users(id),
        CONSTRAINT FK_ServiceBookings_Services FOREIGN KEY (service_id) REFERENCES Services(id)
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
    description NVARCHAR(MAX),
	isDeleted BIT DEFAULT 0
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



-- Dữ liệu cho bảng Users (giữ nguyên)
INSERT INTO Users (user_name, pass, full_name, birth, gender, email, phone, address, role, avatar_url)
VALUES
-- password gốc: Password123
('nguyenminhquan', 'iOIn6rY20XzbTxNEc2fEuQ==', N'Nguyễn Minh Quân', '1990-05-15', 'Male', 'quan.nguyen@email.com', '0123456789', N'123 P. Hàng Bông, Hoàn Kiếm, Hà Nội', 'Customer', 'images/user/default_avatar.png'),

-- password gốc: Password123
('tranthiyen', 'iOIn6rY20XzbTxNEc2fEuQ==', N'Trần Thị Yến', '1985-08-25', 'Female', 'yenlaem412@gmail.com', '0123456780', N'456 P. Hàng Gai, Hoàn Kiếm, Hà Nội', 'Admin', 'images/user/default_avatar.png'),

-- password gốc: Password123
('lequangthang', 'iOIn6rY20XzbTxNEc2fEuQ==', N'Lê Quang Thắng', '1990-11-11', 'Male', 'thang.le@email.com', '0123456789', N'888 P. Tràng Tiền, Hoàn Kiếm, Hà Nội', 'Reception', 'images/user/default_avatar.png'),
('newuser4', 'iOIn6rY20XzbTxNEc2fEuQ==', N'Trần Quốc Tuấn', '1995-01-01', 'Male', 'user4@email.com', '0111111111', N'P. Quốc Tử Giám, Văn Miếu, Đống Đa, Hà Nội', 'Customer', 'images/user/default_avatar.png'),
('newuser5', 'iOIn6rY20XzbTxNEc2fEuQ==', N'Nguyễn Anh Minh', '1996-01-01', 'Female', 'user5@email.com', '0111111112', N'P. Đinh Tiên Hoàng, Hàng Trống, Hoàn Kiếm, Hà Nội', 'Customer', 'images/user/default_avatar.png');

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
-- Tầng 1
('101', 1, 500000, N'Available', 2, N'Phòng tiêu chuẩn, đầy đủ tiện nghi', 'images/room/101.jpg', 1),
('102', 2, 1000000, N'Occupied', 3, N'Phòng sang trọng với giường lớn', 'images/room/102.jpg', 1),
('103', 1, 550000, N'Available', 2, N'Phòng tiêu chuẩn, đầy đủ tiện nghi', 'images/room/103.jpg', 1),
('104', 3, 1500000, N'Available', 4, N'Phòng suite với bồn tắm', 'images/room/104.jpg', 1),
('105', 4, 2000000, N'Available', 5, N'Phòng tổng thống với tầm nhìn đẹp', 'images/room/105.jpg', 1),

-- Tầng 2
('201', 1, 500000, N'Available', 2, N'Phòng tiêu chuẩn, đầy đủ tiện nghi', 'images/room/201.jpg', 2),
('202', 2, 1000000, N'Occupied', 3, N'Phòng sang trọng với giường lớn', 'images/room/202.jpg', 2),
('203', 1, 550000, N'Available', 2, N'Phòng tiêu chuẩn, đầy đủ tiện nghi', 'images/room/203.jpg', 2),
('204', 3, 1500000, N'Available', 4, N'Phòng suite với bồn tắm', 'images/room/204.jpg', 2),
('205', 4, 2000000, N'Available', 5, N'Phòng tổng thống với tầm nhìn đẹp', 'images/room/205.jpg', 2),

-- Tầng 3
('301', 1, 500000, N'Available', 2, N'Phòng tiêu chuẩn, đầy đủ tiện nghi', 'images/room/301.jpg', 3),
('302', 2, 1000000, N'Occupied', 3, N'Phòng sang trọng với giường lớn', 'images/room/302.jpg', 3),
('303', 1, 550000, N'Available', 2, N'Phòng tiêu chuẩn, đầy đủ tiện nghi', 'images/room/303.jpg', 3),
('304', 3, 1500000, N'Available', 4, N'Phòng suite với bồn tắm', 'images/room/304.jpg', 3),
('305', 4, 2000000, N'Available', 5, N'Phòng tổng thống với tầm nhìn đẹp', 'images/room/305.jpg', 3),

-- Tầng 4
('401', 1, 500000, N'Available', 2, N'Phòng tiêu chuẩn, đầy đủ tiện nghi', 'images/room/401.jpg', 4),
('402', 2, 1000000, N'Occupied', 3, N'Phòng sang trọng với giường lớn', 'images/room/402.jpg', 4),
('403', 1, 550000, N'Available', 2, N'Phòng tiêu chuẩn, đầy đủ tiện nghi', 'images/room/403.jpg', 4),
('404', 3, 1500000, N'Available', 4, N'Phòng suite với bồn tắm', 'images/room/404.jpg', 4),
('405', 4, 2000000, N'Available', 5, N'Phòng tổng thống với tầm nhìn đẹp', 'images/room/405.jpg', 4),

-- Tầng 5
('501', 1, 600000, N'Available', 2, N'Phòng tiêu chuẩn, có ban công hướng thành phố', 'images/room/501.jpg', 5),
('502', 2, 1200000, N'Occupied', 3, N'Phòng sang trọng với view hồ, bồn tắm đứng', 'images/room/502.jpg', 5),
('503', 1, 650000, N'Available', 2, N'Phòng tiêu chuẩn, thoải mái, ấm cúng', 'images/room/503.jpg', 5),
('504', 3, 1700000, N'Available', 4, N'Phòng suite gia đình, có hai phòng ngủ', 'images/room/504.jpg', 5),
('505', 4, 2500000, N'Occupied', 5, N'Phòng tổng thống, tầm nhìn toàn cảnh thành phố', 'images/room/505.jpg', 5);

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
(N'Mì Quảng', 1, 70000, N'Món mì Quảng đặc trưng với nước dùng đậm đà, sợi mì vàng óng, tôm, thịt heo, trứng cút và rau sống phong phú.', 'https://image.url'),
(N'Bánh xèo', 1, 65000, N'Chiếc bánh xèo vàng giòn, nhân tôm thịt, ăn kèm với rau sống và nước mắm chua ngọt đặc trưng.', 'https://image.url'),
(N'Phở bò Hà Nội', 1, 60000, N'Tô phở bò nóng hổi với nước dùng trong veo, thơm lừng, sợi phở mềm dai, thịt bò tái ngọt mềm.', 'https://image.url'),
(N'Bún chả Hà Nội', 1, 75000, N'Bún đi kèm với chả nướng thơm phức, nem cua bể và nước mắm pha chua ngọt, tạo nên hương vị đặc trưng của Hà Nội.', 'https://image.url'),
(N'Bánh mì thịt nướng', 1, 35000, N'Chiếc bánh mì giòn rụm, bên trong là thịt heo nướng ướp gia vị đậm đà, pate, chả, đồ chua và rau thơm.', 'https://image.url'),
(N'Gỏi cuốn tôm thịt', 1, 45000, N'Các cuốn bún tươi, tôm, thịt heo luộc, rau sống, được cuốn trong bánh tráng trong, chấm với nước mắm pha.', 'https://image.url'),
(N'Bánh cuốn Thanh Trì', 1, 50000, N'Bánh cuốn nóng hổi, tráng mỏng, nhân thịt mộc nhĩ, ăn kèm chả lụa, hành khô và nước mắm pha.', 'https://image.url'),
(N'Cơm tấm sườn bì chả', 1, 55000, N'Xuất sắc với sườn nướng cháy cạnh, bì giòn, chả trứng, ăn kèm cơm tấm và đồ chua.', 'https://image.url'),
(N'Bún bò Huế', 1, 80000, N'Lẩu bún bò với nước dùng đỏ au, cay nồng, sợi bún to, giò heo, tiết lợn và rau sống đặc trưng.', 'https://image.url'),
(N'Cháo gà', 1, 40000, N'Món cháo nóng, sánh mịn nấu từ gạo và thịt gà, ăn kèm hành lá, ngò, tiêu và quẩy giòn.', 'https://image.url'),
(N'Bánh tôm Hồ Tây', 1, 90000, N'Những con tôm tươi được裹 trong bột, chiên giòn, ăn kèm nước mắm chua ngọt và rau sống.', 'https://image.url'),
(N'Bún riêu cua', 1, 60000, N'Bún với nước dùng từ cua đồng, gạch cua vàng ươm, đậu rán, chả, và cà chua, tạo nên hương vị đậm đà.', 'https://image.url'),
(N'Bánh tráng trộn', 1, 25000, N'Món ăn vặt hấp dẫn với bánh tráng, khô bò, trứng cút, xoài xanh, hành phi, ruốc, và sốt me.', 'https://image.url'),
(N'Nem nướng Nha Trang', 1, 85000, N'Nem nướng được nướng trên than hoa, dậy mùi thơm, ăn kèm bún, rau sống và nước lèo đặc biệt.', 'https://image.url'),
(N'Xôi gà', 1, 35000, N'Xôi nếp dẻo thơm, rưới mỡ hành, phủ lên trên là thịt gà xé phay và hành khô, có thể thêm chà bông.', 'https://image.url'),
(N'Hủ tiếu Nam Vang', 1, 65000, N'Nước dùng ngọt thanh từ xương heo và tôm khô, sợi hủ tiếu dai, tôm, thịt, trứng cút và tim heo.', 'https://image.url'),
(N'Bánh ướt lòng gà', 1, 55000, N'Món ăn dân dã với bánh ướt tráng mỏng, lòng gà luộc, ăn kèm rau thơm và mắm nêm.', 'https://image.url'),
(N'Chè đậu trắng', 1, 30000, N'Chè ngọt thanh từ đậu trắng, nấu với đường phèn, có thể thêm trân châu hoặc thạch.', 'https://image.url'),
(N'Bánh canh ghẹ', 1, 120000, N'Sợi bánh canh to, dai, nước dùng ngọt từ ghẹ, thịt ghẹ nhiều và tươi ngon.', 'https://image.url'),
(N'Phở gà', 1, 55000, N'Biến thể nhẹ nhàng của phở, với nước dùng trong, ngọt từ xương gà, sợi phở, thịt gà xé và hành lá.', 'https://image.url'),
(N'Buffet', 1, 200000, N'Tận hưởng bữa sáng buffet phong phú với đa dạng món Á - Âu, từ bánh mì nóng hổi, cháo dinh dưỡng đến các món Âu như trứng, xúc xích, salad tươi ngon và nhiều lựa chọn nước uống.', 'https://image.url'),
(N'Spa thư giãn', 2, 500000, N'Giải tỏa mọi căng thẳng với liệu pháp massage thư giãn chuyên sâu, giúp cơ thể phục hồi năng lượng, lưu thông khí huyết và mang lại cảm giác sảng khoái.', 'https://image.url'),
(N'Phòng tập', 3, 150000, N'Rèn luyện sức khỏe trong không gian hiện đại, đầy đủ ánh sáng tự nhiên và trang thiết bị tập luyện cardio, tạ tay chuyên nghiệp, phù hợp cho mọi nhu cầu từ tập luyện cơ bản đến nâng cao.', 'https://image.url'),
(N'Dịch vụ đưa đón', 4, 300000, N'Tiện nghi và an toàn với dịch vụ đưa đón tận nơi, xe đời mới, lái xe thân thiện và am hiểu địa phương, giúp bạn di chuyển thuận tiện từ sân bay đến khách sạn.', 'https://image.url'),
(N'Pizza', 1, 80000, N'Thưởng thức những chiếc pizza nóng giòn, thơm lừng với nhân phô mai kéo sợi, topping phong phú từ xúc xích, giăm bông, rau củ tươi ngon, nướng than củ đặc trưng.', 'https://image.url'),
(N'Massage mặt', 2, 250000, N'Chăm sóc làn da với liệu pháp massage mặt thư giãn, giúp tái tạo tế bào, giảm căng thẳng cho vùng mặt và cổ, mang lại làn da tươi tắn, rạng ngời.', 'https://image.url'),
(N'Trung tâm thể dục', 3, 120000, N'Mở rộng trải nghiệm tập luyện với quyền truy cập vào trung tâm thể dục đối tác hiện đại, đầy đủ máy móc và lớp học nhóm (yoga, aerobic...).', 'https://image.url'),
(N'Đưa đón sân bay', 4, 400000, N'Dịch vụ đưa đón riêng tư, tiện lợi từ sân bay đến khách sạn và ngược lại, với xe đời mới, lái xe chuyên nghiệp, giúp bạn bắt đầu hoặc kết thúc chuyến đi thật suôn sẻ.', 'https://image.url'),
(N'Chè', 1, 50000, N'Thanh mát và ngọt ngào với các loại chè truyền thống Việt Nam, được nấu công phu từ đậu xanh, hạt sen, củ năng, thạch dẻo, nước cốt dừa thơm béo và topping đa dạng.', 'https://image.url'),
(N'Trị liệu', 2, 600000, N'Phục hồi sức khỏe toàn diện với các liệu pháp trị liệu chuyên sâu như châm cứu, xoa bóp bấm huyệt, detox cơ thể, giúp giảm đau nhức, cải thiện giấc ngủ và tăng cường hệ miễn dịch.', 'https://image.url');

-- Dữ liệu cho bảng ServiceReviews (giữ nguyên)
INSERT INTO ServiceReviews (service_id, quality, comment)
VALUES
-- 10 đánh giá ban đầu (đã được cải thiện)
(1, 5, N'Thực đơn buffet vô cùng đa dạng và phong phú, từ các món Á đến Âu đều được chế biến tươi ngon và hấp dẫn. Nhân viên phục vụ tận tình, không gian ấm cúng, là điểm nhấn tuyệt vời cho buổi sáng tại khách sạn.'),
(2, 4, N'Liệu pháp massage thư giãn giúp cơ thể sảng khoái và giảm căng thẳng hiệu quả. Tuy nhiên, phòng trị liệu hơi nhỏ và thiếu sự riêng tư, nếu được cải thiện sẽ hoàn hảo hơn.'),
(3, 5, N'Phòng tập thể dục hiện đại, sạch sẽ và đầy đủ mọi thiết bị từ cardio đến tạ. Không gian mở, có cửa sổ lớn đón ánh sáng tự nhiên, tạo cảm giác thoải mái khi tập luyện.'),
(4, 5, N'Chuyến đi vô cùng thuận tiện và an toàn. Tài xế lịch sự, đúng giờ, xe đời mới và được vệ sinh sạch sẽ. Dịch vụ đưa đón đã giúp chuyến đi của tôi khởi đầu một cách hoàn hảo.'),
(5, 4, N'Chiếc pizza có đế mỏng giòn và nhân phô mai kéo sợi rất ngon. Tuy nhiên, phần topping hải sản có thể được bổ sung thêm để tăng độ phong phú và tươi ngon.'),
(6, 5, N'Chăm sóc da mặt bằng liệu pháp massage thư giãn thực sự là một trải nghiệm tuyệt vời. Làn da trở nên mịn màng, tươi tắn và cảm giác thư giãn sâu sau 60 phút.'),
(7, 4, N'Việc được truy cập vào trung tâm thể dục đối tác là một điểm cộng lớn. Thiết bị hiện đại, nhưng số lượng máy cardio còn hạn chế, đặc biệt vào giờ cao điểm.'),
(8, 5, N'Dịch vụ đưa đón sân bay được tổ chức chuyên nghiệp. Xe sang trọng, tài xế đón tận cửa ga, giúp hành lý và hướng dẫn nhanh chóng. Một trải nghiệm đẳng cấp.'),
(9, 4, N'Chè đậu xanh và chè thập cẩm được nấu ngọt thanh, rất hợp khẩu vị. Chỉ tiếc là thực đơn chè còn đơn điệu, nếu có thêm nhiều loại chè đặc sản khác thì sẽ tuyệt vời hơn.'),
(10, 5, N'Liệu pháp trị liệu chuyên sâu giúp tôi phục hồi nhanh chóng sau một tuần làm việc căng thẳng. Cảm giác thư giãn và tái tạo năng lượng rất rõ rệt. Tôi sẽ quay lại vào lần tới.'),

-- 20 đánh giá mới
(11, 5, N'Bữa sáng kiểu Mỹ đầy đủ và chất lượng, trứng ốp la và thịt xông khói được nấu vừa ăn, tạo năng lượng tuyệt vời cho một ngày mới.'),
(12, 5, N'Nhà hàng hải sản phục vụ những món tôm hùm và sò điệp tươi sống, được chế biến ngay tại chỗ. Chất lượng và dịch vụ đều xuất sắc.'),
(13, 4, N'Cocktail tại quầy bar có hương vị độc đáo và được pha chế đẹp mắt. Không gian âm nhạc sôi động, tuy nhiên giá cả hơi cao so với mặt bằng chung.'),
(14, 5, N'Đồ ăn nhẹ buổi chiều là một điểm nhấn tinh tế. Trà Anh, bánh ngọt và trái cây tươi được phục vụ chu đáo, tạo cảm giác được chăm sóc tận tình.'),
(15, 5, N'Bữa tối tại nhà hàng sang trọng là một trải nghiệm đẳng cấp. Món ăn được trình bày như tác phẩm nghệ thuật, hương vị tinh tế và dịch vụ chu đáo.'),
(16, 4, N'Buffet tối có nhiều lựa chọn hấp dẫn, đặc biệt là các món nướng. Tuy nhiên, một số món hải sản có thể được bổ sung thêm để tăng độ tươi ngon.'),
(17, 5, N'Pizza nướng bằng củi có đế giòn rụm, hương thơm đặc trưng và nhân phô mai béo ngậy. Một lựa chọn ẩm thực tuyệt vời cho buổi tối.'),
(18, 5, N'Món ăn Việt truyền thống như phở và bún chả được nấu đúng vị Hà Nội, mang lại hương vị quê nhà thân quen và ấm áp.'),
(19, 5, N'Nước ép trái cây tươi được ép theo yêu cầu, rất thơm ngon và tốt cho sức khỏe. Là lựa chọn lý tưởng cho những ai yêu thích lối sống lành mạnh.'),
(20, 5, N'Món chay được chế biến công phu, đa dạng và đầy đủ dinh dưỡng. Thật ấn tượng với sự sáng tạo của đầu bếp.'),
(21, 5, N'Spa toàn thân là một liệu pháp hoàn hảo, kết hợp massage, tẩy tế bào chết và xông hơi. Cơ thể được thư giãn hoàn toàn và tinh thần sảng khoái.'),
(22, 4, N'Chăm sóc da mặt chuyên sâu giúp cải thiện rõ rệt tình trạng da. Tuy nhiên, liệu trình hơi dài, nếu có gói ngắn hơn sẽ phù hợp với nhiều người.'),
(23, 5, N'Liệu pháp đá nóng giúp giảm đau cơ và lưu thông máu rất hiệu quả. Cảm giác ấm áp và thư giãn lan tỏa khắp cơ thể.'),
(24, 5, N'Chăm sóc tóc và da đầu bằng thảo dược giúp tóc bóng mượt và giảm căng thẳng đầu óc. Một trải nghiệm thư giãn tuyệt vời.'),
(25, 5, N'Gói chăm sóc sau sinh rất toàn diện, hỗ trợ phụ nữ phục hồi sức khỏe và vóc dáng một cách an toàn và hiệu quả.'),
(26, 5, N'Gội đầu dưỡng sinh với kỹ thuật bấm huyệt giúp giải tỏa căng thẳng và lưu thông khí huyết, mang lại cảm giác sảng khoái.'),
(27, 5, N'Tắm bùn khoáng giúp làn da trở nên mịn màng và sạch sâu. Không gian yên tĩnh, tạo cảm giác thư giãn tuyệt đối.'),
(28, 4, N'Chăm sóc móng tay chân chuyên nghiệp, sơn gel bền đẹp. Tuy nhiên, thời gian chờ đợi hơi lâu do đông khách.'),
(29, 5, N'Liệu pháp trẻ hóa làn da sử dụng công nghệ hiện đại, giúp làm mờ nếp nhăn và se khít lỗ chân lông rõ rệt.'),
(30, 5, N'Xông hơi thảo dược giúp giải độc cơ thể và thư giãn tinh thần. Mùi hương thảo dược tự nhiên rất dễ chịu.');

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







------------------------
-- bảng quản lý log chatbot ai
-- mục tiêu để lưu trữ chat phục vụ cho việc nâng cấp chatbot
CREATE TABLE chat_logs (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NULL, -- NULL for anonymous users
    user_message NVARCHAR(MAX) NOT NULL,
    bot_response NVARCHAR(MAX) NOT NULL,
    timestamp DATETIME2 DEFAULT GETDATE(),
    session_id NVARCHAR(50) NOT NULL,
    
    -- Foreign key constraint (optional, in case user_id references Users table)
    -- FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- Index for better performance on session lookups
CREATE INDEX IX_chat_logs_session_id ON chat_logs(session_id);
CREATE INDEX IX_chat_logs_timestamp ON chat_logs(timestamp);
CREATE INDEX IX_chat_logs_user_id ON chat_logs(user_id);

-- Sample data (optional)
-- INSERT INTO chat_logs (user_id, user_message, bot_response, session_id) 
-- VALUES (NULL, 'Xin chào', 'Xin chào! Tôi là trợ lý ảo của khách sạn. Tôi có thể giúp gì cho bạn?', 'demo-session-001');