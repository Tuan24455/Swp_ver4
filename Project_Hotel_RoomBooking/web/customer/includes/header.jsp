<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="component.css" />

<nav id="navbar"> <div id="navbar-left"> <a href="home" style="text-decoration: none"><img class="logo" src="images/logo/logo.png" alt="Logo"/></a>
    </div>

    <div id="navbar-center"> <ul id="nav-links"> <li><a href="home">Trang chủ</a></li>
            <li><a href="service">Dịch vụ</a></li>
            <li><a href="contact.jsp">Liên hệ</a></li>
            <li><a href="about.jsp">Chúng tôi</a></li>
        </ul>
    </div>

    <div id="navbar-right"> <div id="dropdown"> <button id="dropdown-toggle" onclick="toggleDropdown()"><i class="fas fa-user-circle fa-2x"></i></button> <div id="userDropdown" class="dropdown-menu"> <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <a href="login.jsp" class="dropdown-item"><i class="fas fa-sign-in-alt"></i> Login</a> <a href="register.jsp" class="dropdown-item"><i class="fas fa-user-plus"></i> Register</a> </c:when>

                    <c:when test="${sessionScope.user.getRole() == 'Customer'}">
                        <span class="dropdown-item">Hello, ${sessionScope.user.getFullName()}</span> <a href="information" class="dropdown-item"><i class="fas fa-user"></i> Thông tin cá nhân</a> <a href="#" class="dropdown-item"><i class="fas fa-key"></i> Đổi mật khẩu</a> <a href="#" class="dropdown-item"><i class="fas fa-history"></i> Lịch sử chi tiêu</a> <a href="logout" class="dropdown-item"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a> </c:when>

                    <c:when test="${sessionScope.user.getRole() == 'Reception'}">
                        <span class="dropdown-item">${sessionScope.user.getFullName()} (Staff)</span> <a href="#" class="dropdown-item"><i class="fa-solid fa-table-columns"></i>Darkboard</a> <a href="logout" class="dropdown-item"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a> </c:when>

                    <c:when test="${sessionScope.user.getRole() == 'Admin'}">
                        <span class="dropdown-item">${sessionScope.user.getFullName()} (Admin)</span> <a href="admin/dashboard.jsp" class="dropdown-item"><i class="fa-solid fa-table-columns"></i>Darkboard</a> <a href="logout" class="dropdown-item"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a> </c:when>
                </c:choose>

            </div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                var currentPath = window.location.pathname;
                var navLinks = document.querySelectorAll("#nav-links a"); // Changed selector from ".nav-links a" to "#nav-links a"

                var contextPath = "<%= request.getContextPath()%>";

                navLinks.forEach(function (link) {
                    var linkHref = link.getAttribute("href");
                    var fullLinkPath = linkHref.startsWith('/') ? linkHref : contextPath + "/" + linkHref;

                    var isHomePage = (linkHref === "home.jsp" &&
                            (currentPath === contextPath + "/" || currentPath === contextPath || currentPath.endsWith("/index.jsp")));

                    if (currentPath.endsWith(fullLinkPath) || isHomePage) {
                        link.classList.add("active");
                    }
                });
            });

            function toggleDropdown() {
                document.getElementById("userDropdown").classList.toggle("show");
            }

            window.onclick = function (event) {
                if (!event.target.closest('#dropdown')) { // Changed selector from '.dropdown' to '#dropdown'
                    var dropdowns = document.getElementsByClassName("dropdown-menu");
                    for (var i = 0; i < dropdowns.length; i++) {
                        var openDropdown = dropdowns[i];
                        if (openDropdown.classList.contains('show')) {
                            openDropdown.classList.remove('show');
                        }
                    }
                }
            };
        </script>
    </div>
</nav>