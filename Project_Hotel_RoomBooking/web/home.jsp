<%-- 
    Document   : home
    Created on : May 22, 2025, 3:28:03 PM
    Author     : ADMIN
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home</title>
        <link rel="stylesheet" href="customer/customer.css" />
        <link rel="stylesheet" href="components/component.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    </head>
    <body>
        <jsp:include page="components/header.jsp"/>


        <main>
            <!-- Nút mở bộ lọc -->
            <button type="button" class="filter-open-btn" onclick="toggleFilter()">
                <i class="fas fa-filter"></i> Lọc phòng
            </button>

            <!-- Modal -->
            <div id="filterModal" class="modal-overlayy">
                <form method="get" action="home" class="modal-contentt">
                    <!-- Nhóm: Loại phòng -->
                    <div class="filter-group">
                        <label>Loại phòng</label>
                        <c:forEach var="type" items="${requestScope.roomtypes}">
                            <div class="checkbox-option">
                                <input type="checkbox" name="roomType" value="${type.getId()}" <c:if test="${fn:contains(paramValues.roomType, type.getId().toString())}">checked</c:if> />
                                <label style="width: 80%">${type.getRoomType()}</label>
                            </div>

                        </c:forEach>
                    </div>

                    <!-- Nhóm: Ngày -->
                    <div class="filter-group">
                        <label>Check-in (date)</label>
                        <input type="date" name="checkin" value="${param.checkin}">
                        <label>Check-out (date)</label>
                        <input type="date" name="checkout" value="${param.checkout}">
                    </div>

                    <!-- Nhóm: Giá -->
                    <div class="filter-group">
                        <label>Price from</label>
                        <input type="number" name="priceFrom" value="${param.priceFrom}" min="0">
                        <label>Price to</label>
                        <input type="number" name="priceTo" value="${param.priceTo}" min="0">
                    </div>

                    <!-- Nhóm: Sức chứa -->
                    <div class="filter-group">
                        <label>Numbers of person</label>
                        <input type="number" name="capacity" value="${param.capacity}" min="1">
                    </div>

                    <!-- Nút submit -->
                    <button type="submit" class="filter-btn">Lọc phòng</button>
                </form>
            </div>

            <!--         ROOM LIST         -->
            <div class="room-list">
                <c:forEach var="room" items="${roomlist}">
                    <div class="room-card">
                        <img src="${room.getImageUrl()}" alt="Room Image">
                        <h5>Phòng ${room.getRoomNumber()}</h5>
                        <h5>
                            Loại phòng:
                            <c:forEach var="type" items="${requestScope.roomtypes}">
                                <c:if test="${type.getId() == room.getRoomTypeId()}">${type.getRoomType()}</c:if>
                            </c:forEach>
                        </h5>
                        <p style="color: red"><strong>Giá:</strong> ${room.getRoomPrice()} VND</p>
                        <p><strong>Sức chứa:</strong> ${room.getCapacity()} người</p>
                        <c:choose>
                            <c:when test="${fn:length(room.getDescription()) > 50}">
                                <p>${fn:substring(room.getDescription(), 0, 50)}...</p>
                            </c:when>
                            <c:otherwise>
                                <p>${room.getDescription()}</p>
                            </c:otherwise>
                        </c:choose>

                        <a href="roomdetail?id=${room.getId()}" class="view-detail-btn">Xem chi tiết</a>
                    </div>
                </c:forEach>
            </div>
        </main>
        <script>
            function toggleFilter() {
                const modal = document.getElementById("filterModal");
                modal.style.display = modal.style.display === "flex" ? "none" : "flex";
            }

            window.addEventListener("click", function (e) {
                const modal = document.getElementById("filterModal");
                if (e.target === modal) {
                    modal.style.display = "none";
                }
            });
        </script>

        <jsp:include page="components/footer.jsp"/>
    </body>
</html>
