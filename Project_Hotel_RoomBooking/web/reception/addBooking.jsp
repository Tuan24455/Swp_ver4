<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*, model.User, model.RoomType" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Thêm Booking Mới</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
        }
        h2 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        form {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            max-width: 500px;
            margin: 0 auto;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"],
        input[type="number"],
        input[type="date"],
        select {
            width: calc(100% - 22px); /* Adjust for padding and border */
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box; /* Include padding and border in the element's total width and height */
        }
        input[type="submit"] {
            background-color: #007bff;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .form-group {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <h2>Thêm mới Booking 📅</h2>
    <form action="add-booking" method="post">
        <div class="form-group">
            <label for="user_id">Người dùng:</label>
            <select name="user_id" id="user_id" required>
                <c:forEach var="u" items="${users}">
                    <option value="${u.id}">${u.fullName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="room_type_id">Loại phòng:</label>
            <select name="room_type_id" id="room_type_id" required>
                <c:forEach var="rt" items="${roomTypes}">
                    <option value="${rt.id}">${rt.roomType}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="promotion_id">Mã khuyến mãi (tùy chọn):</label>
            <input type="number" name="promotion_id" id="promotion_id" placeholder="Nhập ID khuyến mãi nếu có">
        </div>

        <div class="form-group">
            <label for="check_in_date">Ngày Check-in:</label>
            <input type="date" name="check_in_date" id="check_in_date" required>
        </div>

        <div class="form-group">
            <label for="check_out_date">Ngày Check-out:</label>
            <input type="date" name="check_out_date" id="check_out_date" required>
        </div>

        <div class="form-group">
            <label for="status">Trạng thái:</label>
            <select name="status" id="status" required>
                <c:forEach var="s" items="${statuses}">
                    <option value="${s}">${s}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="total_prices">Tổng tiền:</label>
            <input type="number" name="total_prices" id="total_prices" step="0.01" required min="0" placeholder="0.00">
        </div>

        <input type="submit" value="Thêm Booking">
    </form>
</body>
</html>