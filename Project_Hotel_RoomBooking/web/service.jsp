<%-- 
    Document   : Service
    Created on : Jun 15, 2025, 10:34:03 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Dịch vụ</title>
        <link rel="stylesheet" href="customer/customer.css" />
        <link rel="stylesheet" href="customer/includes/component.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    </head>
    <body style="background-image: url(images/system/Background.jpg)">
        <jsp:include page="customer/includes/header.jsp"/>

        <main>
            <!--         SERVICE LIST         -->
            <div style="display: flex; flex-direction: column; justify-content: center; align-items: center;">
                <h2 class="text-center mb-4" style="margin: 5px 0 0 0; color: #fff">Danh Sách Dịch Vụ</h2>
                <div class="room-list">
                    <c:forEach var="service" items="${serviceList}">
                        <div class="room-card">
                            <img src="${service.imageUrl}" alt="Service Image">
                            <h5>Dịch vụ: ${service.serviceName}</h5>
                            <p style="color: red"><strong>Giá:</strong> ${service.servicePrice} VND</p>
                            <c:choose>
                                <c:when test="${fn:length(service.description) > 50}">
                                    <p>${fn:substring(service.description, 0, 50)}...</p>
                                </c:when>
                                <c:otherwise>
                                    <p>${service.description}</p>
                                </c:otherwise>
                            </c:choose>
                            <a href="#" class="view-detail-btn disabled">Xem chi tiết</a>
                        </div>
                    </c:forEach>
                </div>

                <!-- PHÂN TRANG -->
                <div class="pagination">
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation" class="d-flex justify-content-center my-4">
                            <ul class="pagination">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="service?page=${currentPage - 1}" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>

                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="service?page=${i}">${i}</a>
                                    </li>
                                </c:forEach>

                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="service?page=${currentPage + 1}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </main>
        <jsp:include page="customer/includes/footer.jsp"/>
    </body>
</html>
