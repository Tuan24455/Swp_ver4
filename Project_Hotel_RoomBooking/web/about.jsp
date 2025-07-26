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

        <main class="container py-5 px-3 px-md-5">
            <!-- Giới thiệu -->
            <section class="mb-5">
                <h1 class="text-center mb-4 fw-bold text-primary">Về Chúng Tôi</h1>
                <p class="lead text-justify text-dark">
                    <strong>Luxury Hotel</strong> – Không gian nghỉ dưỡng ven biển dành cho những tâm hồn yêu cái đẹp và sự tận hưởng.
                </p>
                <p class="text-justify text-secondary">
                    Tọa lạc tại một trong những bãi biển đẹp nhất Việt Nam, Luxury Hotel là khách sạn cao cấp mang đến trải nghiệm nghỉ dưỡng khác biệt – nơi hội tụ giữa vẻ đẹp thiên nhiên nguyên sơ và những tiêu chuẩn dịch vụ quốc tế. Chúng tôi không chỉ là một điểm đến, mà là nơi mở ra những khoảnh khắc sống chậm, thư giãn và đắm mình trong sự yên bình tuyệt đối.
                </p>
                <p class="text-justify text-secondary">
                    Với kiến trúc hiện đại lấy cảm hứng từ sóng biển và ánh nắng, từng đường nét của khách sạn được thiết kế để giao hòa với thiên nhiên – từ phòng nghỉ rộng mở ngập tràn ánh sáng tự nhiên, ban công riêng nhìn thẳng ra biển, đến những khu vườn xanh mát bên trong khuôn viên.
                </p>
                <p class="text-justify text-secondary">
                    Chúng tôi hiểu rằng mỗi vị khách đều xứng đáng được phục vụ bằng sự chân thành và chuyên nghiệp nhất. Vì vậy, Luxury Hotel không ngừng nâng cao chất lượng dịch vụ – từ đội ngũ lễ tân thân thiện, dịch vụ phòng tận tâm 24/7, đến những tiện nghi như hồ bơi tràn viền, trung tâm thể thao, spa trị liệu, nhà hàng sang trọng với thực đơn đa dạng phong cách ẩm thực Á – Âu.
                </p>
                <p class="text-justify text-secondary">
                    Điểm nổi bật của Luxury Hotel chính là hệ thống đặt phòng thông minh, nhanh chóng và minh bạch. Chúng tôi áp dụng chính sách <strong>không hủy</strong> đối với một số hạng phòng để đảm bảo sự ổn định trong mùa cao điểm – phản ánh cam kết chuẩn hóa và chuyên nghiệp trong vận hành.
                </p>
                <p class="text-justify text-secondary">
                    Luxury Hotel hướng tới xây dựng một cộng đồng khách hàng thân thiết – những người không chỉ đến để lưu trú, mà còn tìm thấy sự gắn kết, niềm vui và nguồn cảm hứng trong từng kỳ nghỉ.
                </p>
                <p class="text-justify text-secondary">
                    Chúng tôi tin rằng mỗi chuyến đi đều bắt đầu bằng một sự lựa chọn. Và khi bạn chọn Luxury Hotel, bạn đang chọn một nơi lưu trú xứng tầm, nơi mọi chi tiết đều được chăm chút để nâng niu cảm xúc của bạn.
                </p>
            </section>

            <!-- Thông tin liên hệ -->
            <section class="contact-content mt-5">
                <h2 class="text-center text-primary mb-4">Thông Tin Liên Hệ</h2>
                <div class="contact-info-section px-4 py-3 bg-light rounded shadow-sm">
                    <div class="row text-center gy-4">
                        <div class="col-md-3 col-6">
                            <div class="contact-icon mb-2">
                                <i class="fas fa-map-marker-alt fa-2x"></i>
                            </div>
                            <h6>Địa chỉ</h6>
                            <p>Khu CNC, Láng Hòa Lạc</p>
                            <p>Thạch Thất, Hà Nội</p>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="contact-icon mb-2">
                                <i class="fas fa-phone fa-2x"></i>
                            </div>
                            <h6>Điện thoại</h6>
                            <p>+84 334 688 774</p>
                            <p>+84 987 654 321</p>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="contact-icon mb-2">
                                <i class="fas fa-envelope fa-2x"></i>
                            </div>
                            <h6>Email</h6>
                            <p>yenlaem412@gmail.com</p>
                            <p>tdpoke412@gmail.com</p>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="contact-icon mb-2">
                                <i class="fas fa-clock fa-2x"></i>
                            </div>
                            <h6>Giờ làm việc</h6>
                            <p>Thứ 2 - Chủ nhật</p>
                            <p>24/7 - Luôn sẵn sàng</p>
                        </div>
                    </div>
                </div>
            </section>
        </main>


        <!-- Footer -->
        <jsp:include page="customer/includes/footer.jsp"/>
    </body>
</html>
