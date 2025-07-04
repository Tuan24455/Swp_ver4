<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lịch sử giao dịch</title>
        <link href="../css/bootstrap.min.css" rel="stylesheet">
        <link href="../css/style.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --primary-color: #1e3c72;
                --secondary-color: #2a5298;
                --accent-color: #f8b400;
                --neutral-100: #f8f9fa;
                --neutral-200: #e9ecef;
                --neutral-300: #dee2e6;
                --neutral-400: #ced4da;
                --neutral-500: #adb5bd;
                --text-primary: #2d3436;
                --text-secondary: #636e72;
            }

            body {
                background-color: var(--neutral-100);
                color: var(--text-primary);
            }
            /* Transaction History Page Styles */
            .page-header {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                padding: 3rem 0;
                margin-bottom: 3rem;
                color: white;
            }

            .page-header h2 {
                font-weight: 300;
                font-size: 2.5rem;
                margin-bottom: 0.5rem;
                letter-spacing: -0.5px;
            }

            .page-header p {
                opacity: 0.9;
                font-size: 1.1rem;
            }

            .filter-section {
                background: white;
                padding: 2rem;
                border-radius: 16px;
                box-shadow: 0 4px 24px rgba(0, 0, 0, 0.06);
                margin-bottom: 2rem;
            }

            .filter-section .form-control {
                border: 2px solid var(--neutral-200);
                padding: 0.875rem 1rem;
                border-radius: 12px;
                font-size: 0.95rem;
                transition: all 0.3s ease;
            }

            .filter-section .form-control:focus {
                border-color: var(--secondary-color);
                box-shadow: 0 0 0 4px rgba(42, 82, 152, 0.1);
            }

            .filter-section .form-label {
                font-weight: 500;
                color: var(--text-secondary);
                margin-bottom: 0.5rem;
            }

            .transaction-card {
                background: white;
                border-radius: 16px;
                padding: 1.5rem;
                margin-bottom: 1rem;
                transition: all 0.3s ease;
                border: 1px solid var(--neutral-200);
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .transaction-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
                border-color: var(--neutral-300);
            }

            .transaction-info {
                flex-grow: 1;
            }

            .transaction-date {
                color: var(--text-secondary);
                font-size: 0.9rem;
                margin-bottom: 0.25rem;
            }

            .transaction-id {
                color: var(--text-primary);
                font-weight: 500;
                font-size: 1.1rem;
            }

            .transaction-amount {
                font-weight: 600;
                color: var(--primary-color);
                font-size: 1.2rem;
                margin-left: 2rem;
            }

            .hotel-name {
                color: var(--text-secondary);
                font-size: 0.95rem;
                margin-top: 0.25rem;
            }

            /* Drawer Styles */
            .drawer {
                position: fixed;
                top: 0;
                right: -450px;
                width: 450px;
                height: 100vh;
                background: white;
                box-shadow: -5px 0 30px rgba(0, 0, 0, 0.1);
                transition: right 0.3s ease-out;
                z-index: 1050;
                overflow-y: auto;
            }

            .drawer.show {
                right: 0;
            }

            .drawer-backdrop {
                position: fixed;
                top: 0;
                left: 0;
                width: 100vw;
                height: 100vh;
                background: rgba(0, 0, 0, 0.5);
                opacity: 0;
                visibility: hidden;
                transition: opacity 0.3s ease;
                z-index: 1040;
            }

            .drawer-backdrop.show {
                opacity: 1;
                visibility: visible;
            }

            .drawer-header {
                padding: 2rem;
                border-bottom: 1px solid var(--neutral-200);
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .drawer-title {
                font-size: 1.5rem;
                font-weight: 500;
                color: var(--text-primary);
                margin: 0;
            }

            .drawer-close {
                background: none;
                border: none;
                color: var(--text-secondary);
                font-size: 1.5rem;
                cursor: pointer;
                padding: 0.5rem;
                transition: color 0.2s ease;
            }

            .drawer-close:hover {
                color: var(--text-primary);
            }

            .drawer-body {
                padding: 2rem;
            }

            .detail-card {
                background: var(--neutral-100);
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
            }

            .detail-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 1rem;
                padding-bottom: 1rem;
                border-bottom: 1px solid var(--neutral-200);
            }

            .detail-row:last-child {
                border-bottom: none;
                margin-bottom: 0;
                padding-bottom: 0;
            }

            .detail-label {
                color: var(--text-secondary);
                font-size: 0.95rem;
            }

            .detail-value {
                color: var(--text-primary);
                font-weight: 500;
            }

            .expense-card {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                margin-top: 1.5rem;
                border: 1px solid var(--neutral-200);
            }

            .expense-row {
                display: flex;
                justify-content: space-between;
                padding: 0.75rem 0;
                border-bottom: 1px solid var(--neutral-200);
            }

            .expense-row:last-child {
                border-bottom: none;
                font-weight: 600;
                color: var(--primary-color);
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .drawer {
                    width: 100%;
                    right: -100%;
                }

                .page-header {
                    padding: 2rem 0;
                }

                .page-header h2 {
                    font-size: 2rem;
                }

                .transaction-card {
                    flex-direction: column;
                    align-items: flex-start;
                }

                .transaction-amount {
                    margin-left: 0;
                    margin-top: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header Section -->
        <div class="page-header">
            <div class="container">
                <h2>Lịch sử giao dịch</h2>
                <p>Xem lại các khoản chi tiêu của bạn khi đặt phòng</p>
            </div>
        </div>

        <div class="container">

            <!-- Filter Section -->
            <div class="filter-section">
                <form class="row g-3" action="transaction-history" method="GET">
                    <div class="col-md-4">
                        <label class="form-label">Từ ngày</label>
                        <input type="date" class="form-control" name="fromDate">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Đến ngày</label>
                        <input type="date" class="form-control" name="toDate">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Tìm kiếm</label>
                        <div class="position-relative">
                            <input type="text" class="form-control" name="search" placeholder="Nhập mã giao dịch hoặc mô tả">
                            <i class="fas fa-search position-absolute top-50 end-0 translate-middle-y me-3 text-muted"></i>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Transaction List -->
            <div class="transactions-list">
                <!-- Transaction Card 1 -->
                <div class="transaction-card" onclick="showTransactionDetail('#TXN20250620XYZ')">
                    <div class="transaction-info">
                        <div class="transaction-date">20/06/2025 – 14:00</div>
                        <div class="transaction-id">#TXN20250620XYZ</div>
                        <div class="hotel-name">Luxury Hotel & Spa</div>
                    </div>
                    <div class="transaction-amount">5.000.000đ</div>
                </div>

                <!-- Transaction Card 2 -->
                <div class="transaction-card" onclick="showTransactionDetail('#TXN20250618ABC')">
                    <div class="transaction-info">
                        <div class="transaction-date">18/06/2025 – 09:45</div>
                        <div class="transaction-id">#TXN20250618ABC</div>
                        <div class="hotel-name">Riverside Resort</div>
                    </div>
                    <div class="transaction-amount">2.850.000đ</div>
                </div>

                <!-- Transaction Card 3 -->
                <div class="transaction-card" onclick="showTransactionDetail('#TXN20250612DEF')">
                    <div class="transaction-info">
                        <div class="transaction-date">12/06/2025 – 16:10</div>
                        <div class="transaction-id">#TXN20250612DEF</div>
                        <div class="hotel-name">Ocean View Hotel</div>
                    </div>
                    <div class="transaction-amount">6.300.000đ</div>
                </div>

                <!-- Transaction Card 4 -->
                <div class="transaction-card" onclick="showTransactionDetail('#TXN20250605GHI')">
                    <div class="transaction-info">
                        <div class="transaction-date">05/06/2025 – 11:30</div>
                        <div class="transaction-id">#TXN20250605GHI</div>
                        <div class="hotel-name">Mountain View Resort</div>
                    </div>
                    <div class="transaction-amount">3.200.000đ</div>
                </div>

                <!-- Transaction Card 5 -->
                <div class="transaction-card" onclick="showTransactionDetail('#TXN20250601JKL')">
                    <div class="transaction-info">
                        <div class="transaction-date">01/06/2025 – 08:15</div>
                        <div class="transaction-id">#TXN20250601JKL</div>
                        <div class="hotel-name">City Center Hotel</div>
                    </div>
                    <div class="transaction-amount">4.750.000đ</div>
                </div>
                                
                     
                  
        <!-- Transaction Detail Modal -->
     

        <script src="../js/bootstrap.bundle.min.js"></script>
        <script>
            function showTransactionDetail(transactionId) {
                const modal = new bootstrap.Modal(document.getElementById('transactionDetailModal'));
                
                // Dữ liệu mẫu cho từng giao dịch
                const transactionDetails = {
                    '#TXN20250620XYZ': {
                        hotelName: 'Luxury Hotel & Spa',
                        stayDuration: '3 đêm (20/06 - 23/06)',
                        paymentMethod: 'Thẻ VISA',
                        expenses: [
                            { item: 'Phí phòng Deluxe', amount: '4.500.000' },
                            { item: 'Dịch vụ Spa', amount: '500.000' },
                            { total: '5.000.000' }
                        ]
                    },
                    '#TXN20250618ABC': {
                        hotelName: 'Riverside Resort',
                        stayDuration: '2 đêm (18/06 - 20/06)',
                        paymentMethod: 'Thẻ Mastercard',
                        expenses: [
                            { item: 'Phí phòng Superior', amount: '2.400.000' },
                            { item: 'Dịch vụ ăn uống', amount: '450.000' },
                            { total: '2.850.000' }
                        ]
                    },
                    '#TXN20250612DEF': {
                        hotelName: 'Ocean View Hotel',
                        stayDuration: '4 đêm (12/06 - 16/06)',
                        paymentMethod: 'Chuyển khoản',
                        expenses: [
                            { item: 'Phí phòng Suite', amount: '5.600.000' },
                            { item: 'Dịch vụ đưa đón', amount: '700.000' },
                            { total: '6.300.000' }
                        ]
                    },
                    '#TXN20250605GHI': {
                        hotelName: 'Mountain View Resort',
                        stayDuration: '2 đêm (05/06 - 07/06)',
                        paymentMethod: 'Tiền mặt',
                        expenses: [
                            { item: 'Phí phòng Standard', amount: '2.800.000' },
                            { item: 'Dịch vụ giặt ủi', amount: '400.000' },
                            { total: '3.200.000' }
                        ]
                    },
                    '#TXN20250601JKL': {
                        hotelName: 'City Center Hotel',
                        stayDuration: '3 đêm (01/06 - 04/06)',
                        paymentMethod: 'Thẻ VISA',
                        expenses: [
                            { item: 'Phí phòng Premium', amount: '4.200.000' },
                            { item: 'Dịch vụ phòng', amount: '550.000' },
                            { total: '4.750.000' }
                        ]
                    }
                };

                const details = transactionDetails[transactionId];
                if (details) {
                    document.getElementById('modalTransactionId').textContent = transactionId;
                    document.getElementById('modalHotelName').textContent = details.hotelName;
                    document.getElementById('modalStayDuration').textContent = details.stayDuration;
                    document.getElementById('modalPaymentMethod').textContent = details.paymentMethod;

                    const expenseTableBody = document.getElementById('modalExpenseDetails');
                    expenseTableBody.innerHTML = details.expenses.map(expense => {
                        if (expense.total) {
                            return `
                                <tr class="fw-bold expense-total">
                                    <td>Tổng cộng</td>
                                    <td>${expense.total}đ</td>
                                </tr>
                            `;
                        }
                        return `
                            <tr>
                                <td>${expense.item}</td>
                                <td>${expense.amount}đ</td>
                            </tr>
                        `;
                    }).join('');
                }
                
                modal.show();
            }
        </script>
    </body>
</html>
