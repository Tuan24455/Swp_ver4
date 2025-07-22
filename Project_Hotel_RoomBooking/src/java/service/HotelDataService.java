package service;

import dao.RoomDao;
import dao.ServiceDao;
import model.Room;
import model.Service;
import java.util.List;
import java.util.Comparator;
import java.util.stream.Collectors;

/**
 * Service class to provide hotel data context for the chatbot
 */
public class HotelDataService {
    
    private RoomDao roomDao;
    private ServiceDao serviceDao;
    
    public HotelDataService() {
        this.roomDao = new RoomDao();
        this.serviceDao = new ServiceDao();
    }
    
    /**
     * Get hotel context information for the chatbot
     * @return String containing hotel information
     */
    public String getHotelContext() {
        StringBuilder context = new StringBuilder();
        
        context.append("THÔNG TIN KHÁCH SẠN:\n");
        context.append("- Tên: Hệ thống quản lý khách sạn\n");
        context.append("- Chuyên cung cấp dịch vụ đặt phòng và dịch vụ khách sạn\n");
        context.append("- Giờ nhận phòng: 12:00\n");
        context.append("- Giờ trả phòng: 11:00\n\n");
        
        // Add room information
        try {
            List<Room> rooms = roomDao.getAllRooms();
            if (!rooms.isEmpty()) {
                context.append("LOẠI PHÒNG HIỆN CÓ:\n");
                
                // Group rooms by type and find min/max prices
                rooms.stream()
                    .collect(Collectors.groupingBy(Room::getRoomTypeName))
                    .forEach((type, roomList) -> {
                        Room sample = roomList.get(0);
                        double minPrice = roomList.stream().mapToDouble(Room::getRoomPrice).min().orElse(0);
                        double maxPrice = roomList.stream().mapToDouble(Room::getRoomPrice).max().orElse(0);
                        
                        context.append(String.format("- %s: Sức chứa %d người, Giá từ %.0f - %.0f VND/đêm\n", 
                            type, sample.getCapacity(), minPrice, maxPrice));
                    });
                
                // Find cheapest and most expensive rooms
                Room cheapestRoom = rooms.stream()
                    .min(Comparator.comparing(Room::getRoomPrice))
                    .orElse(null);
                Room expensiveRoom = rooms.stream()
                    .max(Comparator.comparing(Room::getRoomPrice))
                    .orElse(null);
                
                if (cheapestRoom != null) {
                    context.append(String.format("\nPHÒNG RẺ NHẤT: %s (ID: %d) - %.0f VND/đêm\n", 
                        cheapestRoom.getRoomTypeName(), cheapestRoom.getId(), cheapestRoom.getRoomPrice()));
                }
                
                if (expensiveRoom != null) {
                    context.append(String.format("PHÒNG ĐẮT NHẤT: %s (ID: %d) - %.0f VND/đêm\n", 
                        expensiveRoom.getRoomTypeName(), expensiveRoom.getId(), expensiveRoom.getRoomPrice()));
                }
                context.append("\n");
            }
        } catch (Exception e) {
            context.append("- Thông tin phòng: Liên hệ để biết chi tiết\n\n");
        }
        
        // Add service information
        try {
            List<Service> services = serviceDao.getAllServices();
            if (!services.isEmpty()) {
                context.append("DỊCH VỤ KHÁCH SẠN:\n");
                services.stream()
                    .collect(Collectors.groupingBy(Service::getTypeName))
                    .forEach((type, serviceList) -> {
                        context.append(String.format("- %s:\n", type));
                        serviceList.forEach(service -> {
                            context.append(String.format("  + %s: %.0f VND\n", 
                                service.getName(), service.getPrice()));
                        });
                    });
                context.append("\n");
            }
        } catch (Exception e) {
            context.append("- Dịch vụ: Liên hệ để biết chi tiết\n\n");
        }
        
        context.append("HƯỚNG DẪN SỬ DỤNG:\n");
        context.append("- Để đặt phòng: Chọn phòng từ danh sách và làm theo hướng dẫn\n");
        context.append("- Để đặt dịch vụ: Truy cập trang dịch vụ\n");
        context.append("- Hỗ trợ: Liên hệ qua form liên hệ hoặc chat trực tuyến\n\n");
        
        context.append("HƯỚNG DẪN TẠO LINK:\n");
        context.append("- Khi giới thiệu phòng cụ thể, hãy tạo link: [Xem chi tiết phòng](room-detail?id=ROOM_ID)\n");
        context.append("- Thay ROOM_ID bằng ID thực của phòng từ thông tin trên\n");
        context.append("- Ví dụ: [Xem phòng Standard](room-detail?id=1)\n\n");
        
        return context.toString();
    }
    
    /**
     * Get system prompt for the chatbot
     * @return String containing system instructions
     */
    public String getSystemPrompt() {
        return "Bạn là trợ lý ảo của một khách sạn. Hãy trả lời một cách thân thiện, hữu ích và chuyên nghiệp. " +
               "Luôn sử dụng tiếng Việt và cung cấp thông tin chính xác về khách sạn.\n\n" +
               
               "KHI NGƯỜI DÙNG CHÀO HỎI (xin chào, hello, chào, hi):\n" +
               "1. Chào lại thân thiện\n" +
               "2. Giới thiệu ngắn gọn vai trò\n" +
               "3. Giới thiệu ngắn gọn về chính sách hủy và đổi lịch: Đặt phòng này không được hoàn tiền. Không thể thay đổi lịch.\n" +
               "4. Nói 'Bạn có thể click vào câu hỏi dưới đây:'\n" +
               "5. Đưa ra 4-5 gợi ý câu hỏi cụ thể mà khách có thể hỏi\n" +
               "Định dạng gợi ý: • Câu hỏi ví dụ? (sẽ tự động thành button)\n\n" +
               
               "VÍ DỤ GỢI Ý CÂU HỎI:\n" +
               "• Phòng nào rẻ nhất?\n" +
               "• Có phòng nào cho 5 người không?\n" +
               "• Giờ nhận phòng và trả phòng là mấy giờ?\n" +
               "• Khách sạn có những dịch vụ gì?\n" +
               "• Giá phòng Presidential Suite bao nhiêu?\n\n" +
               
               "Khi người dùng hỏi về phòng cụ thể (như 'phòng rẻ nhất', 'phòng đắt nhất'), hãy:\n" +
               "1. Mô tả phòng đó (tên, giá, sức chứa)\n" +
               "2. Tạo link markdown dạng [Xem chi tiết phòng](room-detail?id=ROOM_ID)\n" +
               "3. Thay ROOM_ID bằng ID thực của phòng từ thông tin được cung cấp\n" +
               "Nếu không biết thông tin cụ thể, hãy gợi ý khách hàng liên hệ trực tiếp với khách sạn. " +
               "Hãy giữ câu trả lời ngắn gọn và dễ hiểu.\n\n" + getHotelContext();
    }
    
    /**
     * Get system prompt specifically for service page
     * @return String containing service-focused instructions
     */
    public String getServicePagePrompt() {
        return "Bạn là trợ lý ảo chuyên tư vấn dịch vụ khách sạn. Hãy trả lời một cách thân thiện và chuyên nghiệp. " +
               "Ưu tiên tư vấn về các dịch vụ có sẵn, giá cả, và cách đặt dịch vụ. " +
               "Luôn sử dụng tiếng Việt và khuyến khích khách hàng trải nghiệm các dịch vụ của khách sạn.\n\n" +
               
               "KHI NGƯỜI DÙNG CHÀO HỎI (xin chào, hello, chào, hi) TRÊN TRANG DỊCH VỤ:\n" +
               "1. Chào lại thân thiện\n" +
               "2. Giới thiệu vai trò tư vấn dịch vụ\n" +
               "3. Giới thiệu ngắn gọn về chính sách hủy và đổi lịch: Đặt phòng này không được hoàn tiền. Không thể thay đổi lịch.\n" +
               "4. Nói 'Bạn có thể click vào câu hỏi dưới đây:'\n" +
               "5. Đưa ra 4-5 gợi ý câu hỏi về dịch vụ\n" +
               "Định dạng gợi ý: • Câu hỏi ví dụ? (sẽ tự động thành button)\n\n" +
               
               "VÍ DỤ GỢI Ý CÂU HỎI VỀ DỊCH VỤ:\n" +
               "• Khách sạn có những dịch vụ gì?\n" +
               "• Giá dịch vụ spa bao nhiêu?\n" +
               "• Làm sao để đặt dịch vụ?\n" +
               "• Có dịch vụ ăn uống gì không?\n" +
               "• Dịch vụ nào phổ biến nhất?\n\n" +
               
               "Hãy giữ câu trả lời ngắn gọn và hướng dẫn cụ thể.\n\n" + getHotelContext();
    }
}