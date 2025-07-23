<%-- Document : home.jsp Created on : May 22, 2025 Author : ADMIN --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title> Trang chủ - Hệ thống quản lý khách sạn</title>
    <!-- CSS Files -->
    <!--<link rel="stylesheet" href="customer/customer.css" />-->
    <link rel="stylesheet" href="css/home-enhanced.css" />
    <!-- External Libraries -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Animate.css for smooth animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <!-- Custom Styles for Chatbox -->
    <style>
        /* Chat Bubble */
        #chat-bubble {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 60px;
            height: 60px;
            background-color: #007bff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            z-index: 1000;
            transition: all 0.3s ease;
        }
        #chat-bubble:hover {
            transform: scale(1.1);
            background-color: #0056b3;
        }
        #chat-bubble i {
            color: white;
            font-size: 24px;
        }
        /* Chatbox Frame */
        #chatbox-frame {
            position: fixed;
            bottom: 90px;
            right: 20px;
            width: 500px;
            height: 700px;
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            display: none; /* Ban đầu ẩn */
            z-index: 999;
            overflow: hidden;
            animation: fadeInUp 0.3s ease;
        }
        #chatbox-frame .chat-header {
            background-color: #007bff;
            color: white;
            padding: 10px;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        #chatbox-frame .chat-header .title {
            display: flex;
            align-items: center;
        }
        #chatbox-frame .chat-header .title i {
            margin-right: 8px;
            font-size: 18px;
        }
        #chatbox-frame .chat-header .header-buttons {
            display: flex;
            gap: 5px;
        }
        #chatbox-frame .chat-header .close-btn,
        #chatbox-frame .chat-header .clear-btn {
            background: none;
            border: none;
            color: white;
            font-size: 16px;
            cursor: pointer;
            padding: 5px;
            border-radius: 3px;
            transition: background-color 0.2s;
        }
        #chatbox-frame .chat-header .close-btn:hover,
        #chatbox-frame .chat-header .clear-btn:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }
        #chatbox-frame .chat-messages {
            height: 590px; /* Tăng height tương ứng với chatbox lớn hơn */
            padding: 15px;
            overflow-y: auto;
            background-color: #f8f9fa;
        }
        #chatbox-frame .chat-messages .message {
            margin-bottom: 15px;
            display: flex;
            align-items: flex-start;
        }
        #chatbox-frame .chat-messages .message.bot {
            justify-content: flex-start;
        }
        #chatbox-frame .chat-messages .message.user {
            justify-content: flex-end;
        }
        #chatbox-frame .chat-messages .message .avatar {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background-color: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 10px;
        }
        #chatbox-frame .chat-messages .message .avatar i {
            font-size: 16px;
            color: #6c757d;
        }
        #chatbox-frame .chat-messages .message .bubble {
            max-width: 700%;
            padding: 8px 12px;
            border-radius: 15px;
            background-color: white;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            color: #000; /* Đảm bảo text hiển thị rõ ràng */
            word-break: break-word; /* Wrap text nếu dài */
            line-height: 1.4;
        }
        #chatbox-frame .chat-messages .message .bubble ul {
            margin: 5px 0;
            padding-left: 15px;
        }
        #chatbox-frame .chat-messages .message .bubble li {
            margin: 3px 0;
        }
        /* Suggestion buttons styling */
        .suggestion-btn {
            display: inline-block;
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border: none;
            border-radius: 20px;
            padding: 8px 16px;
            margin: 4px 2px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0, 123, 255, 0.2);
        }
        .suggestion-btn:hover {
            background: linear-gradient(135deg, #0056b3, #004085);
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0, 123, 255, 0.3);
        }
        .suggestion-btn:active {
            transform: translateY(0);
            box-shadow: 0 2px 4px rgba(0, 123, 255, 0.2);
        }
        #chatbox-frame .chat-messages .message.bot .bubble {
            border-bottom-left-radius: 0;
        }
        #chatbox-frame .chat-messages .message.user .bubble {
            border-bottom-right-radius: 0;
        }
        #chatbox-frame .chat-messages .message .time {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
            text-align: right;
        }
        #chatbox-frame .chat-messages .message.bot .time {
            text-align: left;
        }
        #chatbox-frame .chat-input {
            display: flex;
            padding: 10px;
            border-top: 1px solid #ddd;
            background-color: white;
            border-bottom-left-radius: 15px;
            border-bottom-right-radius: 15px;
        }
        #chatbox-frame .chat-input input {
            flex: 1;
            border: none;
            border-radius: 20px;
            padding: 8px 15px;
            background-color: #f1f3f5;
            outline: none;
        }
        #chatbox-frame .chat-input button {
            background: none;
            border: none;
            color: #007bff;
            font-size: 18px;
            cursor: pointer;
            margin-left: 10px;
        }
        /* Typing indicator animation */
        .typing-dots {
            animation: typing 1.4s infinite;
            font-size: 18px;
        }
        @keyframes typing {
            0%, 60%, 100% {
                opacity: 0.2;
            }
            30% {
                opacity: 1;
            }
        }
        /* Container for suggestion buttons inside bubble (for dynamic buttons) */
        .suggestions-container {
            margin-top: 10px;
            display: flex;
            flex-wrap: wrap;
            gap: 6px; /* Khoảng cách giữa các nút */
        }
    </style>
</head>
<body>
    <!-- Temporary Message -->
    <c:if test="${not empty param.message}">
        <div id="tempMessage" class="alert alert-${param.status == 'success' ? 'success' : 'danger'} text-center" 
             style="position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 9999; padding: 15px 30px;">
            ${param.message}
        </div>
        <script>
            setTimeout(function() {
                var msg = document.getElementById('tempMessage');
                if (msg) {
                    msg.style.transition = 'opacity 0.5s';
                    msg.style.opacity = '0';
                    setTimeout(function() {
                        msg.remove();
                        // Remove message and status from URL without refreshing
                        var url = new URL(window.location.href);
                        url.searchParams.delete('message');
                        url.searchParams.delete('status');
                        window.history.replaceState({}, '', url);
                    }, 500);
                }
            }, 2000);
        </script>
    </c:if>
    <!-- Background overlay for better readability -->
    <div class="background-overlay"></div>
    <!-- Header -->
    <jsp:include page="customer/includes/header.jsp"/>
    <main class="main-content">
        <!-- Hero Section -->
        <section class="hero-section animate__animated animate__fadeInDown">
            <div class="container">
                <div class="hero-content text-center">
                    <h1 class="hero-title">
                        <i class="fas fa-hotel me-3"></i>
                        Khám Phá Phòng Nghỉ Tuyệt Vời
                    </h1>
                    <p class="hero-subtitle">Tìm kiếm và đặt phòng khách sạn phù hợp với nhu cầu của bạn</p>
                </div>
            </div>
        </section>
        <!-- Filter Section -->
        <section class="filter-section">
            <div class="container">
                <div class="text-center mb-4">
                    <button type="button" class="filter-toggle-btn animate__animated animate__pulse animate__infinite" onclick="toggleFilter()">
                        <i class="fas fa-filter me-2"></i>
                        <span>Lọc phòng</span>
                        <i class="fas fa-chevron-down ms-2 filter-arrow"></i>
                    </button>
                </div>
                <!-- Enhanced Filter Modal -->
                <div id="filterModal" class="filter-modal">
                    <div class="filter-modal-content animate__animated">
                        <div class="filter-header">
                            <h3><i class="fas fa-sliders-h me-2"></i>Bộ lọc tìm kiếm</h3>
                            <button type="button" class="filter-close-btn" onclick="toggleFilter()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <form method="post" action="home" class="filter-form">
                            <div class="filter-grid">
                                <!-- Room Type Filter -->
                                <div class="filter-group">
                                    <div class="filter-group-header">
                                        <i class="fas fa-bed"></i>
                                        <label>Loại phòng</label>
                                    </div>
                                    <div class="checkbox-container">
                                        <c:forEach var="type" items="${requestScope.roomtypelist}">
                                            <div class="checkbox-item">
                                                <input type="checkbox" 
                                                       id="roomType_${type.getId()}"
                                                       name="roomType" 
                                                       value="${type.getId()}"
                                                       <c:if test="${selectedRoomTypeIds != null && selectedRoomTypeIds.contains(type.getId())}">checked</c:if> />
                                                <label for="roomType_${type.getId()}" class="checkbox-label">
                                                    ${type.getRoomType()}
                                                </label>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                                <!-- Date Filter -->
                                <div class="filter-group">
                                    <div class="filter-group-header">
                                        <i class="fas fa-calendar-alt"></i>
                                        <label>Thời gian</label>
                                    </div>
                                    <div class="date-inputs">
                                        <!-- Ngày nhận phòng -->
                                        <div class="input-group">
                                            <label class="input-label">Ngày nhận phòng</label>
                                            <input type="date" name="checkin" class="form-input"
                                                   value="${param.checkin != null ? param.checkin : checkin}" />
                                        </div>
                                        <!-- Ngày trả phòng -->
                                        <div class="input-group">
                                            <label class="input-label">Ngày trả phòng</label>
                                            <input type="date" name="checkout" class="form-input"
                                                   value="${param.checkout != null ? param.checkout : checkout}" />
                                        </div>
                                    </div>
                                </div>
                                <!-- Price Filter -->
                                <div class="filter-group">
                                    <div class="filter-group-header">
                                        <i class="fas fa-money-bill-wave"></i>
                                        <label>Khoảng giá</label>
                                    </div>
                                    <div class="price-inputs">
                                        <div class="input-group">
                                            <label class="input-label">Từ (VND)</label>
                                            <input type="number" name="priceFrom" value="${param.priceFrom}" 
                                                   min="0" class="form-input" placeholder="0">
                                        </div>
                                        <div class="input-group">
                                            <label class="input-label">Đến (VND)</label>
                                            <input type="number" name="priceTo" value="${param.priceTo}" 
                                                   min="0" class="form-input" placeholder="Không giới hạn">
                                        </div>
                                    </div>
                                </div>
                                <!-- Capacity Filter -->
                                <div class="filter-group">
                                    <div class="filter-group-header">
                                        <i class="fas fa-users"></i>
                                        <label>Sức chứa</label>
                                    </div>
                                    <div class="input-group">
                                        <input type="number" name="capacity" value="${param.capacity}" 
                                               min="1" max="10" class="form-input" placeholder="Số người">
                                    </div>
                                </div>
                                <!-- Sort Filter -->
                                <div class="filter-group">
                                    <div class="filter-group-header">
                                        <i class="fas fa-sort-amount-down"></i>
                                        <label>Sắp xếp</label>
                                    </div>
                                    <select name="sort" class="form-select">
                                        <option value="">-- Mặc định --</option>
                                        <option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>Giá tăng dần</option>
                                        <option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Giá giảm dần</option>
                                    </select>
                                </div>
                            </div>
                            <!-- Hiển thị lỗi nếu có -->
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger text-center mb-3" role="alert">
                                    ${error}
                                </div>
                            </c:if>
                            <!-- Filter Actions -->
                            <div class="filter-actions">
                                <button type="button" class="btn btn-reset" onclick="resetFilter()">
                                    <i class="fas fa-undo me-2"></i>Đặt lại
                                </button>
                                <button type="submit" class="btn btn-apply">
                                    <i class="fas fa-search me-2"></i>Áp dụng lọc
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
        <!-- Room List Section -->
        <section class="room-list-section">
            <div class="container">
                <!-- Section Header -->
                <div class="section-header text-center mb-5">
                    <h2 class="section-title animate__animated animate__fadeInUp">
                        <i class="fas fa-list me-3"></i>Danh Sách Phòng
                    </h2>
                    <div class="section-divider"></div>
                    <c:if test="${not empty roomlist}">
                        <p class="section-subtitle">
                            Tìm thấy <strong>${fn:length(roomlist)}</strong> phòng phù hợp
                        </p>
                    </c:if>
                </div>
                <!-- Room Grid -->
                <div class="room-grid">
                    <c:choose>
                        <c:when test="${not empty roomlist}">
                            <c:forEach var="room" items="${roomlist}" varStatus="status">
                                <div class="room-card animate__animated animate__fadeInUp" 
                                     style="animation-delay: ${status.index * 0.1}s">
                                    <div class="room-image-container">
                                        <img src="${room.getImageUrl()}" alt="Phòng ${room.getRoomNumber()}" class="room-image">
                                        <div class="room-overlay">
                                            <div class="room-price-badge">
                                                <fmt:formatNumber value="${room.getRoomPrice()}" type="number" groupingUsed="true"/> VND
                                            </div>
                                        </div>
                                    </div>
                                    <div class="room-content">
                                        <div class="room-header">
                                            <h5 class="room-number">
                                                <i class="fas fa-door-open me-2"></i>Phòng ${room.getRoomNumber()}
                                            </h5>
                                            <div class="room-type-badge">${room.getRoomTypeName()}</div>
                                        </div>
                                        <div class="room-details">
                                            <div class="room-detail-item">
                                                <i class="fas fa-users text-primary"></i>
                                                <span>${room.getCapacity()} người</span>
                                            </div>
                                            <div class="room-detail-item">
                                                <i class="fas fa-tag text-success"></i>
                                                <span class="room-price">
                                                    <fmt:formatNumber value="${room.getRoomPrice()}" type="number" groupingUsed="true"/> VND
                                                </span>
                                            </div>
                                        </div>
                                        <div class="room-description">
                                            <c:choose>
                                                <c:when test="${fn:length(room.getDescription()) > 80}">
                                                    <p>${fn:substring(room.getDescription(), 0, 80)}...</p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p>${room.getDescription()}</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="room-actions">
                                            <a href="room-detail?id=${room.getId()}" class="btn btn-view-detail">
                                                <i class="fas fa-eye me-2"></i>Xem chi tiết
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="no-rooms-found">
                                <div class="no-rooms-icon">
                                    <i class="fas fa-search"></i>
                                </div>
                                <h3>Không tìm thấy phòng phù hợp</h3>
                                <p>Vui lòng thử điều chỉnh bộ lọc tìm kiếm</p>
                                <button type="button" class="btn btn-reset" onclick="resetFilter()">
                                    <i class="fas fa-undo me-2"></i>Đặt lại bộ lọc
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>
        <!-- Enhanced Pagination -->
        <c:if test="${totalPages > 1}">
            <section class="pagination-section">
                <div class="container">
                    <nav class="pagination-nav" aria-label="Phân trang">
                        <ul class="pagination-list">
                            <!-- Previous Button -->
                            <li class="pagination-item ${currentPage == 1 ? 'disabled' : ''}">
                                <button class="pagination-link" type="button" 
                                        onclick="goToPage(${currentPage - 1})"
                                        ${currentPage == 1 ? 'disabled' : ''}>
                                    <i class="fas fa-chevron-left"></i>
                                    <span class="d-none d-sm-inline ms-1">Trước</span>
                                </button>
                            </li>
                            <!-- Page Numbers -->
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <li class="pagination-item ${i == currentPage ? 'active' : ''}">
                                    <button class="pagination-link" type="button" onclick="goToPage(${i})">
                                        ${i}
                                    </button>
                                </li>
                            </c:forEach>
                            <!-- Next Button -->
                            <li class="pagination-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <button class="pagination-link" type="button" 
                                        onclick="goToPage(${currentPage + 1})"
                                        ${currentPage == totalPages ? 'disabled' : ''}>
                                    <span class="d-none d-sm-inline me-1">Sau</span>
                                    <i class="fas fa-chevron-right"></i>
                                </button>
                            </li>
                        </ul>
                    </nav>
                    <!-- Pagination Info -->
                    <div class="pagination-info text-center mt-3">
                        <span class="pagination-text">
                            Trang ${currentPage} / ${totalPages}
                        </span>
                    </div>
                </div>
            </section>
        </c:if>
    </main>
    <!-- Hidden Pagination Form -->
    <form id="paginationForm" method="post" action="home" style="display: none;">
        <input type="hidden" name="page" id="paginationPage" />
        <c:forEach var="entry" items="${paramValues}">
            <c:if test="${entry.key != 'page'}">
                <c:forEach var="v" items="${entry.value}">
                    <input type="hidden" name="${entry.key}" value="${v}" />
                </c:forEach>
            </c:if>
        </c:forEach>
    </form>
    <!-- Footer -->
    <jsp:include page="customer/includes/footer.jsp"/>
    <!-- Chat Bubble -->
    <div id="chat-bubble" onclick="toggleChatbox()">
        <i class="fas fa-comment-dots"></i>
    </div>
    <!-- Chatbox Frame -->
    <div id="chatbox-frame">
        <div class="chat-header">
            <div class="title">
                <i class="fas fa-headset"></i>
                Hỗ trợ trực tuyến
            </div>
            <div class="header-buttons">
                <button class="clear-btn" onclick="clearChatSession()" title="Xóa cuộc trò chuyện">
                    <i class="fas fa-trash"></i>
                </button>
                <button class="close-btn" onclick="toggleChatbox()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
        <div class="chat-messages" id="chat-messages">
            <!-- Tin nhắn mẫu giống hình ảnh - ĐÃ CẬP NHẬT -->
            <div class="message bot">
                <div class="avatar"><i class="fas fa-robot"></i></div>
                <div>
                    <div class="bubble">Chào bạn! Mình là trợ lý ảo của Hệ thống quản lý khách sạn, rất vui được hỗ trợ bạn. Xin lưu ý rằng đặt phòng tại khách sạn chúng tôi hiện không được hoàn tiền và không thể thay đổi lịch. Tôi có thể giúp gì cho bạn?</div>
                    <div class="time">Bây giờ</div>
                    <!-- Các nút gợi ý riêng lẻ - ĐÃ CẬP NHẬT -->
                    <div style="display: flex; flex-wrap: wrap; gap: 5px; margin-top: 10px;">
                        <button class="suggestion-btn" onclick="sendSuggestion('Phòng nào rẻ nhất?')">Phòng nào rẻ nhất?</button>
                        <button class="suggestion-btn" onclick="sendSuggestion('Giờ nhận phòng và trả phòng là mấy giờ?')">Giờ nhận/trả phòng?</button>
                        <button class="suggestion-btn" onclick="sendSuggestion('Khách sạn có những dịch vụ gì?')">Dịch vụ khách sạn?</button>
                        <button class="suggestion-btn" onclick="sendSuggestion('Giá phòng Presidential Suite bao nhiêu?')">Giá Presidential Suite?</button>
                    </div>
                </div>
            </div>
            <div class="message bot">
                <div class="avatar"><i class="fas fa-robot"></i></div>
                <div>
                    <div class="bubble">Giờ nhận phòng là 12:00 và giờ trả phòng là 11:00.</div>
                    <div class="time">Bây giờ</div>
                </div>
            </div>
        </div>
        <div class="chat-input">
            <input type="text" id="chat-input" placeholder="Nhập tin nhắn của bạn...">
            <button onclick="sendMessage()"><i class="fas fa-paper-plane"></i></button>
        </div>
    </div>
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="js/home-enhanced.js"></script>
    <!-- Script for Chatbox Toggle and Send Message -->
    <script>
        function sendSuggestion(question) {
            // Set the input value and send the message
            var input = document.getElementById('chat-input');
            input.value = question;
            sendMessage();
        }
        function toggleChatbox() {
            var chatbox = document.getElementById('chatbox-frame');
            if (chatbox.style.display === 'none' || chatbox.style.display === '') {
                chatbox.style.display = 'block';
                chatbox.classList.add('animate__animated', 'animate__fadeInUp');
            } else {
                chatbox.style.display = 'none';
                chatbox.classList.remove('animate__animated', 'animate__fadeInUp');
            }
        }
        function sendMessage() {
            var input = document.getElementById('chat-input');
            var messageText = input.value.trim();
            if (messageText) {
                console.log('Sending user message: ' + messageText);
                var messages = document.getElementById('chat-messages');
                var time = 'Bây giờ';
                // Add user message to chat
                addUserMessage(messages, messageText, time);
                input.value = '';
                messages.scrollTop = messages.scrollHeight;
                // Show typing indicator
                showTypingIndicator(messages);
                // Send message to server
                fetch('/Project_Hotel_RoomBooking/chatbot', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({
                        message: messageText
                    })
                })
                .then(response => response.json())
                .then(data => {
                    // Remove typing indicator
                    removeTypingIndicator();
                    if (data.success) {
                        // Add bot response
                        addBotMessage(messages, data.message, time);
                    } else {
                        // Add error message
                        addBotMessage(messages, data.message || 'Xin lỗi, tôi đang gặp sự cố. Vui lòng thử lại sau.', time);
                    }
                    messages.scrollTop = messages.scrollHeight;
                })
                .catch(error => {
                    console.error('Error:', error);
                    removeTypingIndicator();
                    addBotMessage(messages, 'Xin lỗi, tôi đang gặp sự cố kết nối. Vui lòng thử lại sau.', time);
                    messages.scrollTop = messages.scrollHeight;
                });
            } else {
                console.log('No message to send');
            }
        }
        function clearChatSession() {
            if (confirm('Bạn có chắc muốn xóa cuộc trò chuyện này? Hành động này không thể hoàn tác.')) {
                var input = document.getElementById('chat-input');
                var messages = document.getElementById('chat-messages');
                // Send clear command to server
                fetch('/Project_Hotel_RoomBooking/chatbot', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({
                        message: '/clear'
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.action === 'clear_chat') {
                        // Clear the chat UI - ĐÃ CẬP NHẬT
                        messages.innerHTML = '<div class="message bot">' +
                            '<div class="avatar"><i class="fas fa-robot"></i></div>' +
                            '<div>' +
                                '<div class="bubble">Chào bạn! Mình là trợ lý ảo của Hệ thống quản lý khách sạn, rất vui được hỗ trợ bạn. Xin lưu ý rằng đặt phòng tại khách sạn chúng tôi hiện không được hoàn tiền và không thể thay đổi lịch. Tôi có thể giúp gì cho bạn?</div>' +
                                '<div class="time">Bây giờ</div>' +
                                '<div style="display: flex; flex-wrap: wrap; gap: 5px; margin-top: 10px;">' +
                                    '<button class="suggestion-btn" onclick="sendSuggestion(\'Phòng nào rẻ nhất?\')">Phòng nào rẻ nhất?</button>' +
                                    '<button class="suggestion-btn" onclick="sendSuggestion(\'Giờ nhận phòng và trả phòng là mấy giờ?\')">Giờ nhận/trả phòng?</button>' +
                                    '<button class="suggestion-btn" onclick="sendSuggestion(\'Khách sạn có những dịch vụ gì?\')">Dịch vụ khách sạn?</button>' +
                                    '<button class="suggestion-btn" onclick="sendSuggestion(\'Giá phòng Presidential Suite bao nhiêu?\')">Giá Presidential Suite?</button>' +
                                '</div>' +
                            '</div>' +
                        '</div>';
                        // Show success message
                        addBotMessage(messages, data.message, 'Bây giờ');
                    }
                    messages.scrollTop = messages.scrollHeight;
                })
                .catch(error => {
                    console.error('Error clearing chat:', error);
                    addBotMessage(messages, 'Có lỗi khi xóa cuộc trò chuyện. Vui lòng thử lại.', 'Bây giờ');
                    messages.scrollTop = messages.scrollHeight;
                });
            }
        }
        function addUserMessage(messages, messageText, time) {
            var userMessage = document.createElement('div');
            userMessage.className = 'message user';
            var contentDiv = document.createElement('div');
            var bubble = document.createElement('div');
            bubble.className = 'bubble';
            bubble.textContent = messageText;
            var timeDiv = document.createElement('div');
            timeDiv.className = 'time';
            timeDiv.textContent = time;
            contentDiv.appendChild(bubble);
            contentDiv.appendChild(timeDiv);
            var avatarDiv = document.createElement('div');
            avatarDiv.className = 'avatar';
            var icon = document.createElement('i');
            icon.className = 'fas fa-user';
            avatarDiv.appendChild(icon);
            userMessage.appendChild(contentDiv);
            userMessage.appendChild(avatarDiv);
            messages.appendChild(userMessage);
        }
        function addBotMessage(messages, messageText, time) {
            var botMessage = document.createElement('div');
            botMessage.className = 'message bot';
            var botAvatarDiv = document.createElement('div');
            botAvatarDiv.className = 'avatar';
            var botIcon = document.createElement('i');
            botIcon.className = 'fas fa-robot';
            botAvatarDiv.appendChild(botIcon);
            var botContentDiv = document.createElement('div');
            
            // Create bubble for text content
            var botBubble = document.createElement('div');
            botBubble.className = 'bubble';

            // Parse markdown links and convert to HTML
            var processedText = parseMarkdownLinks(messageText);

            // Separate text content from buttons
            var lines = processedText.split('<br>');
            var textLines = [];
            var buttonHtmls = [];

            for (var i = 0; i < lines.length; i++) {
                var line = lines[i].trim();
                // Kiểm tra nếu dòng là một nút button (bắt đầu bằng <button)
                if (line.startsWith('<button')) {
                    buttonHtmls.push(line);
                } else if (line.length > 0) {
                    textLines.push(line);
                }
            }

            // Set text content
            botBubble.innerHTML = textLines.join('<br>');

            // Create container for buttons if they exist (for dynamic buttons from AI)
            if (buttonHtmls.length > 0) {
                var suggestionsContainer = document.createElement('div');
                suggestionsContainer.className = 'suggestions-container'; // Apply custom styling
                suggestionsContainer.innerHTML = buttonHtmls.join('');
                botBubble.appendChild(suggestionsContainer);
            }

            var botTimeDiv = document.createElement('div');
            botTimeDiv.className = 'time';
            botTimeDiv.textContent = time;

            botContentDiv.appendChild(botBubble);
            botContentDiv.appendChild(botTimeDiv);
            botMessage.appendChild(botAvatarDiv);
            botMessage.appendChild(botContentDiv);
            messages.appendChild(botMessage);
        }
        function parseMarkdownLinks(text) {
            // Convert markdown links [text](url) to HTML links
            var linkRegex = /\[([^\]]+)\]\(([^)]+)\)/g;
            var processedText = text.replace(linkRegex, '<a href="$2" target="_blank" style="color: #007bff; text-decoration: underline;">$1</a>');

            // Convert bullet points (•) to clickable suggestion buttons
            var lines = processedText.split('\n'); // Use \n for line breaks
            var result = [];
            for (var i = 0; i < lines.length; i++) {
                var line = lines[i].trim();
                if (line.startsWith('•')) {
                    var questionText = line.substring(1).trim();
                    // Escape single quotes for onclick attribute
                    var escapedQuestion = questionText.replace(/'/g, "\\'");
                    result.push('<button class="suggestion-btn" onclick="sendSuggestion(\'' + escapedQuestion + '\')">' + questionText + '</button>');
                } else if (line.length > 0) {
                    result.push(line);
                }
            }
            return result.join('<br>');
        }
        function showTypingIndicator(messages) {
            var typingMessage = document.createElement('div');
            typingMessage.className = 'message bot typing-indicator';
            typingMessage.id = 'typing-indicator';
            var botAvatarDiv = document.createElement('div');
            botAvatarDiv.className = 'avatar';
            var botIcon = document.createElement('i');
            botIcon.className = 'fas fa-robot';
            botAvatarDiv.appendChild(botIcon);
            var botContentDiv = document.createElement('div');
            var botBubble = document.createElement('div');
            botBubble.className = 'bubble';
            botBubble.innerHTML = '<span class="typing-dots">●●●</span>';
            botBubble.style.backgroundColor = '#f0f0f0';
            botContentDiv.appendChild(botBubble);
            typingMessage.appendChild(botAvatarDiv);
            typingMessage.appendChild(botContentDiv);
            messages.appendChild(typingMessage);
            messages.scrollTop = messages.scrollHeight;
        }
        function removeTypingIndicator() {
            var typingIndicator = document.getElementById('typing-indicator');
            if (typingIndicator) {
                typingIndicator.remove();
            }
        }
        // Enter để gửi
        document.getElementById('chat-input').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });
    </script>
    <!-- Show payment result message if exists -->
    <c:if test="${not empty param.message}">    
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                Swal.fire({
                    title: '${param.status == "success" ? "Thành công!" : "Thất bại!"}',
                    text: '${param.message}',
                    icon: '${param.status}',
                    confirmButtonText: 'OK'
                });
            });
        </script>
    </c:if>
</body>
</html>