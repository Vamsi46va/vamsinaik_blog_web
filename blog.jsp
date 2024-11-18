<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Enhanced Blog System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css">
    <style>
        :root {
            --primary-color: #007bff;
            --secondary-color: #6c757d;
            --success-color: #28a745;
            --danger-color: #dc3545;
            --background-color: #f8f9fa;
            --text-color: #333;
            --border-color: #dee2e6;
            --hover-color: #0056b3;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            background-color: var(--background-color);
            color: var(--text-color);
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
        }

        .nav-bar {
            background-color: white;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-bar h1 {
            color: var(--primary-color);
            font-size: 2rem;
            font-weight: 700;
        }

        .nav-buttons {
            display: flex;
            gap: 1rem;
        }

        .btn {
            background-color: var(--primary-color);
            color: white;
            padding: 0.8rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn:hover {
            background-color: var(--hover-color);
            transform: translateY(-2px);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .auth-form {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            margin-bottom: 1rem;
        }

        .auth-form h2 {
            margin-bottom: 1.5rem;
            color: var(--primary-color);
            font-size: 1.8rem;
            text-align: center;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: var(--text-color);
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 0.8rem;
            border: 2px solid var(--border-color);
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            border-color: var(--primary-color);
            outline: none;
        }

        .blog-post {
            background-color: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            transition: transform 0.3s ease;
        }

        .blog-post:hover {
            transform: translateY(-5px);
        }

        .blog-title {
            font-size: 1.8rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .blog-meta {
            color: var(--secondary-color);
            margin-bottom: 1rem;
            display: flex;
            gap: 1.5rem;
            font-size: 0.9rem;
        }

        .blog-content {
            line-height: 1.8;
            margin-bottom: 1.5rem;
            color: var(--text-color);
        }

        .comments-section {
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--border-color);
            display: none;
        }

        .comment {
            background-color: #f8f9fa;
            padding: 1.2rem;
            border-radius: 6px;
            margin-bottom: 1rem;
            border-left: 3px solid var(--primary-color);
        }

        .comment-meta {
            display: flex;
            justify-content: space-between;
            color: var(--secondary-color);
            margin-bottom: 0.8rem;
            font-size: 0.9rem;
        }

        .comment-content {
            color: var(--text-color);
            line-height: 1.6;
        }

        .comment-form {
            margin-bottom: 2rem;
        }

        .comment-form textarea {
            width: 100%;
            padding: 1rem;
            border: 2px solid var(--border-color);
            border-radius: 6px;
            min-height: 100px;
            margin-bottom: 1rem;
            font-family: inherit;
        }

        .alert {
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 4px;
            text-align: center;
            animation: fadeIn 0.3s ease;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .post-actions {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .post-actions .btn {
            font-size: 0.9rem;
            padding: 0.6rem 1.2rem;
        }

        .btn.liked {
            background-color: var(--danger-color);
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .nav-bar {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
                padding: 1rem;
            }
            
            .nav-buttons {
                flex-direction: column;
                width: 100%;
            }
            
            .blog-title {
                font-size: 1.5rem;
            }
            
            .blog-meta {
                flex-direction: column;
                gap: 0.5rem;
            }
            
            .post-actions {
                flex-direction: column;
            }
            
            .auth-forms {
                padding: 0 1rem;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }

        #newPostForm {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            animation: fadeIn 0.3s ease;
        }

        #newPostForm h2 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .text-center { text-align: center; }
        .mt-2 { margin-top: 2rem; }
        .mb-2 { margin-bottom: 2rem; }
    </style>
</head>
<body>
    <%!
        // Database configuration
        private static final String DB_URL = "jdbc:mysql://localhost:3306/blog_system";
        private static final String DB_USER = "root";
        private static final String DB_PASSWORD = "Vamsi46va@123"; 

        // Database connection method
        private Connection getConnection() throws SQLException, ClassNotFoundException {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        }

        // Authentication methods
        private boolean authenticateUser(String username, String password) throws SQLException, ClassNotFoundException {
            try (Connection conn = getConnection();
                 PreparedStatement stmt = conn.prepareStatement("SELECT password FROM users WHERE username = ?")) {
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    return rs.getString("password").equals(password);
                }
                return false;
            }
        }

        private boolean registerUser(String username, String email, String password) throws SQLException, ClassNotFoundException {
            try (Connection conn = getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO users (username, email, password) VALUES (?, ?, ?)")) {
                stmt.setString(1, username);
                stmt.setString(2, email);
                stmt.setString(3, password);
                return stmt.executeUpdate() > 0;
            } catch (SQLException e) {
                return false;
            }
        }

        private boolean userExists(String username) throws SQLException, ClassNotFoundException {
            try (Connection conn = getConnection();
                 PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE username = ?")) {
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();
                return rs.next();
            }
        }

        // Blog interaction methods
        private int getLikeCount(Connection conn, int postId) throws SQLException {
            try (PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM blog_likes WHERE post_id = ?")) {
                stmt.setInt(1, postId);
                ResultSet rs = stmt.executeQuery();
                rs.next();
                return rs.getInt(1);
            }
        }

        private boolean hasUserLiked(Connection conn, int postId, String userIp) throws SQLException {
            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT COUNT(*) FROM blog_likes WHERE post_id = ? AND user_ip = ?")) {
                stmt.setInt(1, postId);
                stmt.setString(2, userIp);
                ResultSet rs = stmt.executeQuery();
                rs.next();
                return rs.getInt(1) > 0;
            }
        }

        private List<Map<String, String>> getComments(Connection conn, int postId) throws SQLException {
            List<Map<String, String>> comments = new ArrayList<>();
            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT * FROM blog_comments WHERE post_id = ? ORDER BY created_at DESC")) {
                stmt.setInt(1, postId);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Map<String, String> comment = new HashMap<>();
                    comment.put("author", rs.getString("author"));
                    comment.put("content", rs.getString("content"));
                    comment.put("created_at", rs.getTimestamp("created_at").toString());
                    comments.add(comment);
                }
            }
            return comments;
        }

        private boolean addBlogPost(String title, String content, String author) throws SQLException, ClassNotFoundException {
            try (Connection conn = getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO blog_posts (title, content, author) VALUES (?, ?, ?)")) {
                stmt.setString(1, title);
                stmt.setString(2, content);
                stmt.setString(3, author);
                return stmt.executeUpdate() > 0;
            }
        }
    %>

    <%
        // Initialize variables
        String message = "";

        // Handle authentication
        if (session.getAttribute("username") == null) {
            String action = request.getParameter("action");
            if (action != null) {
                switch(action) {
                    case "login":
                        if ("POST".equals(request.getMethod())) {
                            String username = request.getParameter("username");
                            String password = request.getParameter("password");
                            try {
                                if (authenticateUser(username, password)) {
                                    session.setAttribute("username", username);
                                    response.sendRedirect(request.getRequestURI());
                                    return;
                                } else {
                                    message = "Invalid username or password";
                                }
                            } catch (Exception e) {
                                message = "Login error: " + e.getMessage();
                            }
                        }
                        break;
                    
                    case "signup":
                        if ("POST".equals(request.getMethod())) {
                            String username = request.getParameter("username");
                            String email = request.getParameter("email");
                            String password = request.getParameter("password");
                            try {
                                if (!userExists(username)) {
                                    if (registerUser(username, email, password)) {
                                        session.setAttribute("username", username);
                                        response.sendRedirect(request.getRequestURI());
                                        return;
                                    } else {
                                        message = "Registration failed. Please try again.";
                                    }
                                } else {
                                    message = "Username already exists.";
                                }
                            } catch (Exception e) {
                                message = "Registration error: " + e.getMessage();
                            }
                        }
                        break;
                }
            }
        } else if ("logout".equals(request.getParameter("action"))) {
            session.invalidate();
            response.sendRedirect(request.getRequestURI());
            return;
        }
        // Handle blog interactions
        if (session.getAttribute("username") != null) {
            // Handle new post creation
            if ("POST".equals(request.getMethod()) && "CREATE_POST".equals(request.getParameter("action"))) {
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                String author = (String) session.getAttribute("username");
                try {
                    if (addBlogPost(title, content, author)) {
                        message = "Post created successfully!";
                    } else {
                        message = "Failed to create post.";
                    }
                } catch (Exception e) {
                    message = "Error creating post: " + e.getMessage();
                }
            }

            // Handle likes
            if ("POST".equals(request.getMethod()) && "LIKE".equals(request.getParameter("action"))) {
                try {
                    int postId = Integer.parseInt(request.getParameter("postId"));
                    String userIp = request.getRemoteAddr();
                    try (Connection conn = getConnection();
                         PreparedStatement stmt = conn.prepareStatement(
                             "INSERT IGNORE INTO blog_likes (post_id, user_ip) VALUES (?, ?)")) {
                        stmt.setInt(1, postId);
                        stmt.setString(2, userIp);
                        stmt.executeUpdate();
                    }
                    response.sendRedirect(request.getRequestURI());
                    return;
                } catch (Exception e) {
                    message = "Error processing like: " + e.getMessage();
                }
            }

            // Handle comments
            if ("POST".equals(request.getMethod()) && "COMMENT".equals(request.getParameter("action"))) {
                try {
                    int postId = Integer.parseInt(request.getParameter("postId"));
                    String author = (String) session.getAttribute("username");
                    String content = request.getParameter("commentContent");
                    
                    if (content != null && !content.trim().isEmpty()) {
                        try (Connection conn = getConnection();
                             PreparedStatement stmt = conn.prepareStatement(
                                 "INSERT INTO blog_comments (post_id, author, content) VALUES (?, ?, ?)")) {
                            stmt.setInt(1, postId);
                            stmt.setString(2, author);
                            stmt.setString(3, content.trim());
                            stmt.executeUpdate();
                        }
                        response.sendRedirect(request.getRequestURI());
                        return;
                    } else {
                        message = "Comment cannot be empty.";
                    }
                } catch (Exception e) {
                    message = "Error posting comment: " + e.getMessage();
                }
            }
        }
    %>

    <!-- Main Content -->
    <div class="container">
        <!-- Navigation Bar -->
        <div class="nav-bar">
            <h1>Enhanced Blog System</h1>
            <% if (session.getAttribute("username") != null) { %>
                <div class="nav-buttons">
                    <button onclick="toggleNewPost()" class="btn">
                        <i class="fas fa-plus"></i> New Post
                    </button>
                    <a href="?action=logout" class="btn">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            <% } %>
        </div>

        <!-- Alert Messages -->
        <% if (!message.isEmpty()) { %>
            <div class="alert <%= message.startsWith("Error") ? "alert-error" : "alert-success" %>">
                <%= message %>
            </div>
        <% } %>

        <!-- Authentication Forms -->
        <% if (session.getAttribute("username") == null) { %>
            <div class="auth-forms">
                <!-- Login Form -->
                <div class="auth-form" id="loginForm">
                    <h2>Login</h2>
                    <form method="POST">
                        <input type="hidden" name="action" value="login">
                        <div class="form-group">
                            <label>Username</label>
                            <input type="text" name="username" required>
                        </div>
                        <div class="form-group">
                            <label>Password</label>
                            <input type="password" name="password" required>
                        </div>
                        <button type="submit" class="btn">
                            <i class="fas fa-sign-in-alt"></i> Login
                        </button>
                    </form>
                    <p>Don't have an account? <a href="#" onclick="toggleAuthForms()">Sign up</a></p>
                </div>

                <!-- Signup Form -->
                <div class="auth-form" id="signupForm" style="display: none;">
                    <h2>Sign Up</h2>
                    <form method="POST">
                        <input type="hidden" name="action" value="signup">
                        <div class="form-group">
                            <label>Username</label>
                            <input type="text" name="username" required>
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" required>
                        </div>
                        <div class="form-group">
                            <label>Password</label>
                            <input type="password" name="password" required>
                        </div>
                        <button type="submit" class="btn">
                            <i class="fas fa-user-plus"></i> Sign Up
                        </button>
                    </form>
                    <p>Already have an account? <a href="#" onclick="toggleAuthForms()">Login</a></p>
                </div>
            </div>
        <% } %>

        <!-- Blog Content -->
        <% if (session.getAttribute("username") != null) { %>
            <!-- New Post Form -->
            <div id="newPostForm" class="blog-form" style="display: none;">
                <h2>Create New Post</h2>
                <form method="POST" onsubmit="return validateForm()">
                    <input type="hidden" name="action" value="CREATE_POST">
                    <div class="form-group">
                        <label>Title</label>
                        <input type="text" name="title" id="title" required>
                    </div>
                    <div class="form-group">
                        <label>Content</label>
                        <textarea name="content" id="content" rows="6" required></textarea>
                    </div>
                    <button type="submit" class="btn">
                        <i class="fas fa-paper-plane"></i> Publish
                    </button>
                </form>
            </div>

            <!-- Blog Posts -->
            <div id="blogPosts">
                <%
                    try (Connection conn = getConnection();
                         Statement stmt = conn.createStatement();
                         ResultSet rs = stmt.executeQuery("SELECT * FROM blog_posts ORDER BY created_at DESC")) {
                        
                        while (rs.next()) {
                            int postId = rs.getInt("id");
                            String userIp = request.getRemoteAddr();
                            boolean hasLiked = hasUserLiked(conn, postId, userIp);
                            int likeCount = getLikeCount(conn, postId);
                %>
                            <div class="blog-post">
                                <h2 class="blog-title"><%= rs.getString("title") %></h2>
                                <div class="blog-meta">
                                    <span><i class="fas fa-user"></i> <%= rs.getString("author") %></span>
                                    <span><i class="fas fa-calendar"></i> <%= rs.getTimestamp("created_at") %></span>
                                </div>

                                <div class="blog-content">
                                    <%= rs.getString("content") %>
                                </div>

                                <div class="post-actions">
                                    <form method="POST" style="display: inline;">
                                        <input type="hidden" name="action" value="LIKE">
                                        <input type="hidden" name="postId" value="<%= postId %>">
                                        <button type="submit" class="btn <%= hasLiked ? "liked" : "" %>">
                                            <i class="fas fa-heart"></i> <%= likeCount %> Likes
                                        </button>
                                    </form>

                                    <button onclick="toggleComments(<%= postId %>)" class="btn">
                                        <i class="fas fa-comments"></i> Comments
                                    </button>
                                </div>

                                <div id="comments-<%= postId %>" class="comments-section">
                                    <h3>Comments</h3>
                                    <form method="POST" class="comment-form" onsubmit="return validateComment(this);">
                                        <input type="hidden" name="action" value="COMMENT">
                                        <input type="hidden" name="postId" value="<%= postId %>">
                                        <div class="form-group">
                                            <textarea name="commentContent" placeholder="Write your comment..." required></textarea>
                                        </div>
                                        <button type="submit" class="btn">
                                            <i class="fas fa-reply"></i> Post Comment
                                        </button>
                                    </form>

                                    <div class="comments-list">
                                        <% 
                                            List<Map<String, String>> comments = getComments(conn, postId);
                                            if (comments.isEmpty()) {
                                        %>
                                            <p class="no-comments">No comments yet. Be the first to comment!</p>
                                        <% } else {
                                            for (Map<String, String> comment : comments) {
                                        %>
                                            <div class="comment">
                                                <div class="comment-meta">
                                                    <strong><i class="fas fa-user"></i> <%= comment.get("author") %></strong>
                                                    <span><i class="fas fa-clock"></i> <%= comment.get("created_at") %></span>
                                                </div>
                                                <div class="comment-content">
                                                    <%= comment.get("content") %>
                                                </div>
                                            </div>
                                        <% 
                                            }
                                        } 
                                        %>
                                    </div>
                                </div>
                            </div>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<div class='alert alert-error'>Error loading posts: " + e.getMessage() + "</div>");
                    }
                %>
            </div>
        <% } %>
    </div>

    <!-- JavaScript Functions -->
    <script src="https://cdn.ckeditor.com/4.25.0/standard/ckeditor.js"></script>
    <script>
        function toggleAuthForms() {
            const loginForm = document.getElementById('loginForm');
            const signupForm = document.getElementById('signupForm');
            loginForm.style.display = loginForm.style.display === 'none' ? 'block' : 'none';
            signupForm.style.display = signupForm.style.display === 'none' ? 'block' : 'none';
        }

        function toggleNewPost() {
            const form = document.getElementById('newPostForm');
            form.style.display = form.style.display === 'none' ? 'block' : 'none';
        }

        function toggleComments(postId) {
            const commentsSection = document.getElementById(`comments-${postId}`);
            commentsSection.style.display = commentsSection.style.display === 'none' ? 'block' : 'none';
        }

        function validateForm() {
            const title = document.getElementById('title').value.trim();
            const content = document.getElementById('content').value.trim();

            if (title.length < 5) {
                alert('Title must be at least 5 characters long');
                return false;
            }

            if (content.length < 20) {
                alert('Content must be at least 20 characters long');
                return false;
            }

            return true;
        }

        function validateComment(form) {
            const content = form.querySelector('textarea[name="commentContent"]').value.trim();
            if (content.length < 1) {
                alert('Comment cannot be empty');
                return false;
            }
            if (content.length > 1000) {
                alert('Comment is too long (maximum 1000 characters)');
                return false;
            }
            return true;
        }

        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    setTimeout(() => alert.remove(), 300);
                }, 5000);
            });

            // Initialize CKEditor
            CKEDITOR.replace('content');
        });
    </script>
</body>
</html>
