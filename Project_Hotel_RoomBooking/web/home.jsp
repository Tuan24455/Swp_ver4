<%-- 
    Document   : home
    Created on : May 22, 2025, 3:28:03 PM
    Author     : ADMIN
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trang chủ</title>
        <link rel="stylesheet" href="customer/customer.css" />
        <link rel="stylesheet" href="customer/includes/component.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    </head>
    <body style="background-image: url(images/system/Background.jpg)">
        <jsp:include page="customer/includes/header.jsp"/>

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
                        <c:forEach var="type" items="${requestScope.roomtypelist}">
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
            <div style="display: flex; flex-direction: column; justify-content: center; align-items: center;">
                <div class="room-list">
                    <c:forEach var="room" items="${roomlist}">
                        <div class="room-card">
                            <img src="${room.getImageUrl()}" alt="Room Image">
                            <h5>Phòng ${room.getRoomNumber()}</h5>
                            <h5>
                                Loại phòng: ${room.getRoomTypeName()}
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
                <!-- PHÂN TRANG -->
                <div class="pagination">
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation" class="d-flex justify-content-center my-4">
                            <ul class="pagination">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="home?page=${currentPage - 1}" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>

                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="home?page=${i}">${i}</a>
                                    </li>
                                </c:forEach>

                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="home?page=${currentPage + 1}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
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

        <jsp:include page="customer/includes/footer.jsp"/>
    </body>
</html>
