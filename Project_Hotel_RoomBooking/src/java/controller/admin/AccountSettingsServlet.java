package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import dao.UserDao;
import model.User;

@WebServlet(name = "AccountSettingsServlet", urlPatterns = {"/admin/account-settings"})
public class AccountSettingsServlet extends HttpServlet {
    
    private UserDao userDao;
    
    @Override
    public void init() throws ServletException {
        userDao = new UserDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser != null) {
            // Get fresh user data from database
            User userData = userDao.getUserById(currentUser.getId());
            if (userData != null) {
                request.setAttribute("userData", userData);
            } else {
                request.setAttribute("userData", currentUser);
            }
        }
        
        // Forward to the account-settings.jsp page
        request.getRequestDispatcher("/admin/account-settings.jsp").forward(request, response);
    }    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("updateProfile".equals(action)) {
            updateUserProfile(request, response, currentUser);
        } else if ("changePassword".equals(action)) {
            changeUserPassword(request, response, currentUser);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/account-settings");
        }
    }
    
    private void updateUserProfile(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        try {
            // Get form parameters
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            String birthStr = request.getParameter("birth");
            
            // Validate required fields
            if (fullName == null || fullName.trim().isEmpty() || 
                email == null || email.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Full name and email are required.");
                doGet(request, response);
                return;
            }
            
            // Check if email already exists for other users
            if (!email.equals(currentUser.getEmail()) && userDao.isEmailExist(email)) {
                request.setAttribute("errorMessage", "Email already exists for another user.");
                doGet(request, response);
                return;
            }
            
            // Check if phone already exists for other users (if phone is provided)
            if (phone != null && !phone.trim().isEmpty() && 
                !phone.equals(currentUser.getPhone()) && userDao.isPhoneExist(phone)) {
                request.setAttribute("errorMessage", "Phone number already exists for another user.");
                doGet(request, response);
                return;
            }
            
            // Parse birth date
            Date birth = null;
            if (birthStr != null && !birthStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    birth = sdf.parse(birthStr);
                } catch (ParseException e) {
                    request.setAttribute("errorMessage", "Invalid date format.");
                    doGet(request, response);
                    return;
                }
            }
            
            // Update user object
            currentUser.setFullName(fullName.trim());
            currentUser.setEmail(email.trim());
            currentUser.setPhone(phone != null ? phone.trim() : "");
            currentUser.setAddress(address != null ? address.trim() : "");
            currentUser.setGender(gender);
            if (birth != null) {
                currentUser.setBirth(birth);
            }
            
            // Update in database
            boolean success = userDao.update(currentUser);
            
            if (success) {
                // Update session with new user data
                session.setAttribute("user", currentUser);
                request.setAttribute("successMessage", "Profile updated successfully.");
            } else {
                request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error occurred. Please try again.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred. Please try again.");
        }
        
        doGet(request, response);
    }
    
    private void changeUserPassword(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate input
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All password fields are required.");
            doGet(request, response);
            return;
        }
        
        // Check current password
        if (!currentPassword.equals(currentUser.getPass())) {
            request.setAttribute("errorMessage", "Current password is incorrect.");
            doGet(request, response);
            return;
        }
        
        // Check password confirmation
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "New password and confirmation do not match.");
            doGet(request, response);
            return;
        }
        
        // Validate password strength (optional)
        if (newPassword.length() < 6) {
            request.setAttribute("errorMessage", "New password must be at least 6 characters long.");
            doGet(request, response);
            return;
        }
          try {
            // Update password in database using the new method
            boolean success = userDao.updatePassword(currentUser.getId(), newPassword);
            
            if (success) {
                // Update session user object with new password
                currentUser.setPass(newPassword);
                session.setAttribute("user", currentUser);
                request.setAttribute("successMessage", "Password changed successfully.");
            } else {
                request.setAttribute("errorMessage", "Failed to change password. Please try again.");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error occurred. Please try again.");
        }
        
        doGet(request, response);
    }
}
