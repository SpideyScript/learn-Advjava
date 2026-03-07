<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
   
</head>
<body>
    <div class="login-container">
        <h1>Login</h1>
        
        <%
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String errorMessage = "";
            String successMessage = "";
            
            if (request.getMethod().equals("POST")) {
                // Simple validation - in production use proper authentication
                if (username != null && !username.trim().isEmpty() && 
                    password != null && !password.trim().isEmpty()) {
                    
                   
                    if (username.equals("admin") && password.equals("password")) {
                        successMessage = "Login successful! Welcome " + username;
                        // In production, create a session here
                        session.setAttribute("username", username);
                        response.sendRedirect("dashboard.jsp");
                    } else {
                        errorMessage = "Invalid username or password!";
                    }
                } else {
                    errorMessage = "Please enter both username and password!";
                }
            }
        %>
        
        <div class="error-message" id="errorMsg" <% if (!errorMessage.isEmpty()) { %>style="display: block;"<% } %>>
            <%= errorMessage %>
        </div>
        
        <div class="success-message" id="successMsg" <% if (!successMessage.isEmpty()) { %>style="display: block;"<% } %>>
            <%= successMessage %>
        </div>
        
        <form method="POST" action="new.jsp" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="Enter your username" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required>
            </div>
            
          
            
            <button type="submit">Login</button>
        </form>
        
       
    </div>
 
</body>
</html>