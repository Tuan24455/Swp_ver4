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
            <h2 class="section-title animate__animated animate__fadeInUp">
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
                    <div class="room-price-badge">
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
                          value="${service.price}"
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/home-enhanced.js"></script>
  </body>
</html>
