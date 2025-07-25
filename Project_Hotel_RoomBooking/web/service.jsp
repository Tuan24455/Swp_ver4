<%@ page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
                                                                    uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fn"
                                                                    uri="http://java.sun.com/jsp/jstl/functions" %> <%@ taglib prefix="fmt"
                                                                    uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>Dịch vụ</title>
        <link rel="stylesheet" href="css/home-enhanced.css" />
        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
            />
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet"
            />
        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"
            />

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
                display: none;
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
                height: 590px;
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
                max-width: 70%;
                padding: 8px 12px;
                border-radius: 15px;
                background-color: white;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                color: #000;
                word-break: break-word;
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
        </style>
    </head>
    <body>
        <!-- Background -->
        <div class="background-overlay"></div>

        <jsp:include page="customer/includes/header.jsp" />

        <main class="main-content">
            <!-- Hero Section -->
            <section class="hero-section animate__animated animate__fadeInDown">
                <div class="container">
                    <div class="hero-content text-center">
                        <h1 class="hero-title">
                            <i class="fas fa-concierge-bell me-2"></i>
                            Khám Phá Dịch Vụ Của Chúng Tôi
                        </h1>
                        <p class="hero-subtitle">
                            Các tiện ích giúp bạn tận hưởng kỳ nghỉ một cách hoàn hảo
                        </p>
                    </div>
                </div>
            </section>

            <!-- Filter Section -->
            <section class="filter-section">
                <div class="container text-center mb-4">
                    <button
                        type="button"
                        class="filter-toggle-btn animate__animated animate__pulse animate__infinite"
                        onclick="toggleFilter()"
                        >
                        <i class="fas fa-filter me-2"></i>
                        <span>Lọc dịch vụ</span>
                        <i class="fas fa-chevron-down ms-2 filter-arrow"></i>
                    </button>
                </div>

                <!-- Filter Modal -->
                <div id="filterModal" class="filter-modal">
                    <div class="filter-modal-content animate__animated">
                        <div class="filter-header">
                            <h3><i class="fas fa-sliders-h me-2"></i>Bộ lọc dịch vụ</h3>
                            <button
                                type="button"
                                class="filter-close-btn"
                                onclick="toggleFilter()"
                                >
                                <i class="fas fa-times"></i>
                            </button>
                        </div>

                        <form method="post" action="service" class="filter-form">
                            <div class="filter-grid">
                                <!-- Dịch vụ loại -->
                                <div class="filter-group">
                                    <div class="filter-group-header">
                                        <i class="fas fa-tags"></i>
                                        <label>Loại dịch vụ</label>
                                    </div>
                                    <div class="checkbox-container">
                                        <c:forEach var="entry" items="${serviceTypes}">
                                            <c:set var="typeId" value="${entry.key}" />
                                            <c:set var="typeName" value="${entry.value}" />
                                            <div class="checkbox-item">
                                                <input type="checkbox" id="type_${typeId}" name="typeId"
                                                       value="${typeId}" ${selectedTypes != null &&
                                                                selectedTypes.contains(typeId) ? 'checked' : ''}/>
                                                <label for="type_${typeId}" class="checkbox-label"
                                                       >${typeName}</label
                                                >
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Khoảng giá -->
                                <div class="filter-group">
                                    <div class="filter-group-header">
                                        <i class="fas fa-money-bill-wave"></i>
                                        <label>Khoảng giá</label>
                                    </div>
                                    <div class="price-inputs">
                                        <div class="input-group">
                                            <label class="input-label">Từ (VND)</label>
                                            <input
                                                type="number"
                                                name="priceFrom"
                                                value="${param.priceFrom}"
                                                min="0"
                                                class="form-input"
                                                />
                                        </div>
                                        <div class="input-group">
                                            <label class="input-label">Đến (VND)</label>
                                            <input
                                                type="number"
                                                name="priceTo"
                                                value="${param.priceTo}"
                                                min="0"
                                                class="form-input"
                                                />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Filter Action -->
                            <div class="filter-actions">
                                <button
                                    type="button"
                                    class="btn btn-reset"
                                    onclick="resetFilter()"
                                    >
                                    Đặt lại
                                </button>
                                <button type="submit" class="btn btn-apply">Áp dụng lọc</button>
                            </div>
                        </form>
                    </div>
                </div>
            </section>

            <!-- Service List -->
            <section class="room-list-section">
                <div class="container">
                    <div class="section-header text-center mb-5">
                        <h2 class="section-title animate__animated animate__fadeInUp" style="color: white">
                            <i class="fas fa-list me-3"></i>Danh sách dịch vụ
                        </h2>
                        <div class="section-divider"></div>
                        <p class="section-subtitle">
                            Có <strong>${fn:length(serviceList)}</strong> dịch vụ đang khả
                            dụng
                        </p>
                    </div>

                    <div class="room-grid">
                        <c:forEach var="service" items="${serviceList}" varStatus="status">
                            <div
                                class="room-card animate__animated animate__fadeInUp"
                                style="animation-delay: ${status.index * 0.1}s"
                                >
                                <div class="room-image-container">
                                    <img
                                        src="${service.imageUrl}"
                                        alt="Dịch vụ ${service.name}"
                                        class="room-image"
                                        />
                                    <div class="room-overlay">
                                        <div class="room-price-badge" style="text-decoration: line-through;">
                                            <fmt:formatNumber
                                                value="${service.price}"
                                                type="number"
                                                groupingUsed="true"
                                                />
                                            VND
                                        </div>
                                    </div>
                                </div>
                                <div class="room-content">
                                    <div class="room-header">
                                        <h5 class="room-number">
                                            <i class="fas fa-concierge-bell me-2"></i>${service.name}
                                        </h5>
                                        <div class="room-type-badge">${service.typeName}</div>
                                    </div>
                                    <div class="room-details">
                                        <div class="room-detail-item">
                                            <i class="fas fa-tag text-success"></i>
                                            <span class="room-price">
                                                <fmt:formatNumber
                                                    value="${service.price * (1 - promotion.getPercentage()/100)}"
                                                    type="number"
                                                    groupingUsed="true"
                                                    />
                                                VND
                                            </span>
                                        </div>
                                    </div>
                                    <div class="room-description">
                                        <c:choose>
                                            <c:when test="${fn:length(service.description) > 80}">
                                                <p>${fn:substring(service.description, 0, 80)}...</p>
                                            </c:when>
                                            <c:otherwise>
                                                <p>${service.description}</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="room-actions">
                                        <a
                                            href="serviceDetail?id=${service.id}"
                                            class="btn btn-view-detail"
                                            >
                                            <i class="fas fa-eye me-2"></i>Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </section>

            <!-- Phân trang -->
            <c:if test="${totalPages > 1}">
                <section class="pagination-section">
                    <div class="container">
                        <nav class="pagination-nav" aria-label="Phân trang">
                            <ul class="pagination-list">
                                <li
                                    class="pagination-item ${currentPage == 1 ? 'disabled' : ''}"
                                    >
                                    <button
                                        class="pagination-link"
                                        type="button"
                                        onclick="goToPage(${currentPage - 1})"
                                        >
                                        <i class="fas fa-chevron-left"></i>
                                    </button>
                                </li>

                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li
                                        class="pagination-item ${i == currentPage ? 'active' : ''}"
                                        >
                                        <button
                                            class="pagination-link"
                                            type="button"
                                            onclick="goToPage(${i})"
                                            >
                                            ${i}
                                        </button>
                                    </li>
                                </c:forEach>

                                <li
                                    class="pagination-item ${currentPage == totalPages ? 'disabled' : ''}"
                                    >
                                    <button
                                        class="pagination-link"
                                        type="button"
                                        onclick="goToPage(${currentPage + 1})"
                                        >
                                        <i class="fas fa-chevron-right"></i>
                                    </button>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </section>
            </c:if>
        </main>

        <!-- Form ẩn phục vụ phân trang -->
        <form
            id="paginationForm"
            method="get"
            action="service"
            style="display: none"
            >
            <input type="hidden" name="page" id="paginationPage" />
            <c:forEach var="entry" items="${paramValues}">
                <c:if test="${entry.key != 'page'}">
                    <c:forEach var="v" items="${entry.value}">
                        <input type="hidden" name="${entry.key}" value="${v}" />
                    </c:forEach>
                </c:if>
            </c:forEach>
        </form>
        <jsp:include page="customer/includes/footer.jsp" />

        <!-- Chat Bubble -->
        <div id="chat-bubble" onclick="toggleChatbox()">
            <i class="fas fa-comment-dots"></i>
        </div>

        <!-- Chatbox Frame -->
        <div id="chatbox-frame">
            <div class="chat-header">
                <div class="title">
                    <i class="fas fa-headset"></i>
                    Hỗ trợ dịch vụ
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
                <!-- Tin nhắn mẫu -->
                <div class="message bot">
                    <div class="avatar"><i class="fas fa-robot"></i></div>
                    <div>
                        <div class="bubble">Xin chào! Tôi có thể tư vấn về các dịch vụ của khách sạn. Bạn quan tâm dịch vụ nào?<br><br>Bạn có thể click vào câu hỏi dưới đây:<br><button class="suggestion-btn" onclick="sendSuggestion('Khách sạn có những dịch vụ gì?')">Khách sạn có những dịch vụ gì?</button><br><button class="suggestion-btn" onclick="sendSuggestion('Giá dịch vụ spa bao nhiêu?')">Giá dịch vụ spa bao nhiêu?</button><br><button class="suggestion-btn" onclick="sendSuggestion('Làm sao để đặt dịch vụ?')">Làm sao để đặt dịch vụ?</button><br><button class="suggestion-btn" onclick="sendSuggestion('Có dịch vụ ăn uống gì không?')">Có dịch vụ ăn uống gì không?</button></div>
                        <div class="time">Bây giờ</div>
                    </div>
                </div>
            </div>
            <div class="chat-input">
                <input type="text" id="chat-input" placeholder="Hỏi về dịch vụ...">
                <button onclick="sendMessage()"><i class="fas fa-paper-plane"></i></button>
            </div>
        </div>

        <script>
            var contextPath = "${pageContext.request.contextPath}";
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/home-enhanced.js"></script>

        <!-- Chatbox JavaScript -->
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
                    console.log('Sending user message:', messageText);

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
                var botBubble = document.createElement('div');
                botBubble.className = 'bubble';

                // Parse markdown links and convert to HTML
                var processedText = parseMarkdownLinks(messageText);
                botBubble.innerHTML = processedText;

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
                var lines = processedText.split('\n');
                var result = [];

                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim();

                    if (line.startsWith('•')) {
                        var questionText = line.substring(1).trim();
                        result.push('<button class="suggestion-btn" onclick="sendSuggestion(\'' + questionText.replace(/'/g, "\\'") + '\')">' + questionText + '</button>');
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
                                    // Clear the chat UI
                                    messages.innerHTML = '<div class="message bot">' +
                                            '<div class="avatar"><i class="fas fa-robot"></i></div>' +
                                            '<div>' +
                                            '<div class="bubble">Xin chào! Tôi có thể tư vấn về các dịch vụ của khách sạn. Bạn quan tâm dịch vụ nào?<br><br>Bạn có thể click vào câu hỏi dưới đây:<br><button class="suggestion-btn" onclick="sendSuggestion(\'Khách sạn có những dịch vụ gì?\')">Khách sạn có những dịch vụ gì?</button><br><button class="suggestion-btn" onclick="sendSuggestion(\'Giá dịch vụ spa bao nhiêu?\')">Giá dịch vụ spa bao nhiêu?</button><br><button class="suggestion-btn" onclick="sendSuggestion(\'Làm sao để đặt dịch vụ?\')">Làm sao để đặt dịch vụ?</button><br><button class="suggestion-btn" onclick="sendSuggestion(\'Có dịch vụ ăn uống gì không?\')">Có dịch vụ ăn uống gì không?</button></div>' +
                                            '<div class="time">Bây giờ</div>' +
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

            // Enter để gửi tin nhắn
            document.addEventListener('DOMContentLoaded', function () {
                var chatInput = document.getElementById('chat-input');
                if (chatInput) {
                    chatInput.addEventListener('keypress', function (e) {
                        if (e.key === 'Enter') {
                            sendMessage();
                        }
                    });
                }
            });
        </script>
    </body>
</html>
