package controller.reception;

import dao.ServiceDao;
import model.Service;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.File;
import java.nio.file.Paths;

@WebServlet("/reception/addService")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AddServiceReceptionServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and is reception staff
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        if (!"Reception".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            // Get form parameters
            String serviceName = request.getParameter("serviceName");
            String serviceTypeStr = request.getParameter("serviceType");
            String servicePriceStr = request.getParameter("servicePrice");
            String serviceDescription = request.getParameter("serviceDescription");
            
            // Validate required fields
            if (serviceName == null || serviceName.trim().isEmpty() ||
                serviceTypeStr == null || serviceTypeStr.trim().isEmpty() ||
                servicePriceStr == null || servicePriceStr.trim().isEmpty()) {
                
                response.sendRedirect(request.getContextPath() + "/reception/serviceManagement?error=missing_fields");
                return;
            }
            
            // Parse numeric values
            int serviceTypeId = Integer.parseInt(serviceTypeStr);
            double servicePrice = Double.parseDouble(servicePriceStr);
            
            if (servicePrice <= 0) {
                response.sendRedirect(request.getContextPath() + "/reception/serviceManagement?error=invalid_price");
                return;
            }
            
            // Handle file upload
            String imageUrl = null;
            Part filePart = request.getPart("serviceImage");
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                
                // Validate file type
                String contentType = filePart.getContentType();
                if (contentType != null && contentType.startsWith("image/")) {
                    
                    // Create upload directory if it doesn't exist
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "images" + File.separator + "services";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    // Generate unique filename
                    String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                    String uniqueFileName = System.currentTimeMillis() + "_" + serviceName.replaceAll("[^a-zA-Z0-9]", "_") + fileExtension;
                    
                    // Save file
                    String filePath = uploadPath + File.separator + uniqueFileName;
                    filePart.write(filePath);
                    
                    // Set image URL for database
                    imageUrl = "images/services/" + uniqueFileName;
                    
                    System.out.println("File uploaded successfully: " + imageUrl);
                } else {
                    System.out.println("Invalid file type: " + contentType);
                }
            }
            
            // Create Service object
            Service newService = new Service();
            newService.setName(serviceName.trim());
            newService.setTypeId(serviceTypeId);
            newService.setPrice(servicePrice);
            newService.setDescription(serviceDescription != null ? serviceDescription.trim() : "");
            newService.setImageUrl(imageUrl);
            
            // Insert service using DAO
            ServiceDao serviceDao = new ServiceDao();
            serviceDao.insertService(newService);
            
            System.out.println("Service added successfully: " + serviceName);
            
            // Redirect back to service management with success message
            response.sendRedirect(request.getContextPath() + "/reception/serviceManagement?success=service_added");
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid number format: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/reception/serviceManagement?error=invalid_format");
            
        } catch (Exception e) {
            System.err.println("Error adding service: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/reception/serviceManagement?error=server_error");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect GET requests to service management
        response.sendRedirect(request.getContextPath() + "/reception/serviceManagement");
    }
} 