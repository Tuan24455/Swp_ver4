<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Về Chúng Tôi - Luxury Hotel</title>

        <!-- Bootstrap & Font Awesome CDN -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

        <style>
            /* Base Styles */
            body {
                background-color: #ffffff;
                background-image: url("images/system/Background.jpg");
                background-size: cover;
                background-position: center;
                background-attachment: fixed;
            }

            /* Member Card Styles */
            .member-card {
                background-color: #f8f9fa;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
                display: flex;
                align-items: center;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .member-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            }

            .member-img {
                width: 120px;
                height: 120px;
                object-fit: cover;
                border-radius: 50%;
                margin-right: 20px;
                border: 3px solid #e9ecef;
                transition: border-color 0.3s ease;
            }

            .member-card:hover .member-img {
                border-color: #0d6efd;
            }

            /* Contact Information Section */
            .contact-info-section {
                background-color: #f8f9fa;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                margin-top: 2rem;
            }

            .contact-icon i {
                color: #0d6efd;
                transition: color 0.3s ease, transform 0.3s ease;
            }

            .contact-icon:hover i {
                color: #0b5ed7;
                transform: scale(1.1);
            }

            /* Typography */
            .text-justify {
                text-align: justify;
                line-height: 1.6;
            }

            .lead {
                font-size: 1.1rem;
                font-weight: 300;
            }

            /* Section Headings */
            h1, h2 {
                color: #2c3e50;
                font-weight: 600;
            }

            h1 {
                font-size: 2.5rem;
                margin-bottom: 2rem;
            }

            h2 {
                font-size: 2rem;
                margin-bottom: 1.5rem;
            }

            /* Member Information */
            .member-card h5 {
                color: #2c3e50;
                font-weight: 600;
                margin-bottom: 0.5rem;
            }

            .member-card p {
                margin-bottom: 0.5rem;
                color: #6c757d;
            }

            .member-card p:last-child {
                color: #495057;
                font-style: italic;
            }

            /* Contact Information Styling */
            .contact-info-section h6 {
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 0.5rem;
            }

            .contact-info-section p {
                color: #6c757d;
                margin-bottom: 0;
                font-size: 0.9rem;
            }

            /* Container and Layout */
            .container {
                max-width: 1200px;
            }

            main {
                min-height: calc(100vh - 200px);
                background-color: rgba(255, 255, 255, 0.95);
                border-radius: 15px;
                margin: 2rem auto;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .member-card {
                    flex-direction: column;
                    align-items: flex-start;
                    text-align: center;
                }

                .member-img {
                    margin-bottom: 15px;
                    margin-right: 0;
                    align-self: center;
                }

                h1 {
                    font-size: 2rem;
                }

                h2 {
                    font-size: 1.5rem;
                }

                .contact-info-section {
                    padding: 20px;
                }
            }

            @media (max-width: 576px) {
                .container {
                    padding: 0 15px;
                }

                main {
                    margin: 1rem auto;
                    border-radius: 10px;
                }

                .member-card {
                    padding: 15px;
                }

                .contact-info-section {
                    padding: 15px;
                }

                .contact-icon i {
                    font-size: 1.5rem !important;
                }
            }

            /* Animation for smooth loading */
            .member-card, .contact-info-section {
                animation: fadeInUp 0.6s ease-out;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Additional enhancements */
            .contact-content {
                animation: fadeIn 0.8s ease-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            /* Focus states for accessibility */
            .member-card:focus-within {
                outline: 2px solid #0d6efd;
                outline-offset: 2px;
            }

            /* Print styles */
            @media print {
                body {
                    background-image: none;
                    background-color: white;
                }

                .member-card, .contact-info-section {
                    box-shadow: none;
                    border: 1px solid #dee2e6;
                }
            }
        </style>
    </head>
    <body>

        <!-- Header -->
        <jsp:include page="customer/includes/header.jsp"/>

        <main class="container py-5">
            <!-- Giới thiệu -->
            <section class="mb-5">
                <h1 class="text-center mb-4">Về Chúng Tôi</h1>
                <p class="lead text-justify">
                    <strong>Luxury Hotel</strong> là hệ thống khách sạn cao cấp, tọa lạc tại những vị trí trung tâm của các thành phố lớn và khu nghỉ dưỡng hàng đầu. 
                    Chúng tôi tự hào mang đến trải nghiệm lưu trú đẳng cấp, dịch vụ hoàn hảo và nền tảng đặt phòng trực tuyến hiện đại.
                </p>
                <p class="text-justify">
                    Dù bạn đang tìm kiếm kỳ nghỉ thư giãn bên bờ biển, chuyến công tác chuyên nghiệp giữa lòng thành phố hay kỳ nghỉ lãng mạn cùng người thân, Luxury Hotel chính là nơi khởi đầu cho những trải nghiệm đáng nhớ.

                    Với hệ thống đặt phòng thông minh và giao diện thân thiện, bạn có thể dễ dàng tìm kiếm, so sánh và đặt phòng chỉ trong vài cú click. Chúng tôi cung cấp thông tin phòng rõ ràng, hình ảnh chân thực, giá cả minh bạch và các ưu đãi độc quyền mỗi ngày.

                    Không chỉ là nơi lưu trú, Luxury Hotel mang đến không gian nghỉ dưỡng đẳng cấp, dịch vụ tận tâm 24/7 và những tiện ích hiện đại như nhà hàng sang trọng, spa thư giãn, trung tâm thể hình và hỗ trợ khách hàng mọi lúc, mọi nơi.

                    Chúng tôi tin rằng mỗi kỳ nghỉ là một câu chuyện, và Luxury Hotel sẽ là nơi bắt đầu của những kỷ niệm khó quên. Hãy để chúng tôi đồng hành cùng bạn trong hành trình tận hưởng cuộc sống theo cách trọn vẹn nhất.
                </p>
            </section>

            <!-- Đội ngũ -->
            <section>
                <h2 class="text-center mb-4">Đội Ngũ Phát Triển Hệ Thống</h2>

                <div class="member-card">
                    <img src="#" alt="Phạm Quốc Tuấn" class="member-img">
                    <div>
                        <h5>Phạm Quốc Tuấn</h5>
                        <p class="mb-1"><strong>Vai trò:</strong> Trưởng nhóm</p>
                        <p><strong>MSSV:</strong> HE181869</p>
                        <p>Chịu trách nhiệm chính về quản lý dự án, thiết kế hệ thống và phát triển giao diện người dùng.</p>
                    </div>
                </div>

                <div class="member-card">
                    <img src="#" alt="Mai Tiến Dũng" class="member-img">
                    <div>
                        <h5>Mai Tiến Dũng</h5>
                        <p class="mb-1"><strong>Vai trò:</strong> Thành viên</p>
                        <p><strong>MSSV:</strong> HE186519</p>
                        <p>Phụ trách xử lý backend, xác thực người dùng và tích hợp các chức năng quản lý người dùng.</p>
                    </div>
                </div>

                <div class="member-card">
                    <img src="#" alt="Phạm Xuân Hiếu" class="member-img">
                    <div>
                        <h5>Phạm Xuân Hiếu</h5>
                        <p class="mb-1"><strong>Vai trò:</strong> Thành viên</p>
                        <p><strong>MSSV:</strong> HE150075</p>
                        <p>Chịu trách nhiệm thiết kế cơ sở dữ liệu, xây dựng chức năng quản lý phòng và dịch vụ khách sạn.</p>
                    </div>
                </div>

                <div class="member-card">
                    <img src="#" alt="Lê Anh Minh" class="member-img">
                    <div>
                        <h5>Lê Anh Minh</h5>
                        <p class="mb-1"><strong>Vai trò:</strong> Thành viên</p>
                        <p><strong>MSSV:</strong> HE180621</p>
                        <p>Phụ trách biểu đồ thống kê, hệ thống báo cáo và hỗ trợ tối ưu giao diện quản trị.</p>
                    </div>
                </div>
            </section>

            <!-- Thông tin liên hệ -->
            <section class="contact-content mt-5">
                <div class="contact-info-section px-4 py-3">
                    <div class="row text-center">
                        <div class="col-md-3 mb-4">
                            <div class="contact-icon mb-2">
                                <i class="fas fa-map-marker-alt fa-2x"></i>
                            </div>
                            <h6>Địa chỉ</h6>
                            <p>Khu CNC, Láng Hòa Lạc<br>Thạch Thất, Hà Nội</p>
                        </div>

                        <div class="col-md-3 mb-4">
                            <div class="contact-icon mb-2">
                                <i class="fas fa-phone fa-2x"></i>
                            </div>
                            <h6>Điện thoại</h6>
                            <p>+84 334 688 774<br>+84 987 654 321</p>
                        </div>

                        <div class="col-md-3 mb-4">
                            <div class="contact-icon mb-2">
                                <i class="fas fa-envelope fa-2x"></i>
                            </div>
                            <h6>Email</h6>
                            <p>yenlaem412@gmail.com<br>tdpoke412@gmail.com</p>
                        </div>

                        <div class="col-md-3 mb-4">
                            <div class="contact-icon mb-2">
                                <i class="fas fa-clock fa-2x"></i>
                            </div>
                            <h6>Giờ làm việc</h6>
                            <p>Thứ 2 - Chủ nhật<br>24/7 - Luôn sẵn sàng</p>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <!-- Footer -->
        <jsp:include page="customer/includes/footer.jsp"/>
    </body>
</html>
