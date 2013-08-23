<%@ page language="java" import="java.sql.*, javax.sql.*, javax.naming.*" errorPage="" %>
<%
    Connection conn = null;
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    conn = DriverManager.getConnection("jdbc:derby://localhost:1527/usermaster", "db", "db");

    ResultSet rsdoLogin = null;
    PreparedStatement psdoLogin = null;

    String sUserID = request.getParameter("username");
    String sPassword = request.getParameter("password");
    String message = "User login successfully ";

    try {
        String sqlOption = "SELECT * FROM usermaster where"
                + " \"sUserID\"=? and \"sPassword\"=?";
        psdoLogin = conn.prepareStatement(sqlOption);
        psdoLogin.setString(1, sUserID);
        psdoLogin.setString(2, sPassword);

        rsdoLogin = psdoLogin.executeQuery();

        if (rsdoLogin.next()) {
            String sUserName = rsdoLogin.getString("sFirstName") + " " + rsdoLogin.getString("sLastName");

            session.setAttribute("sUserID", rsdoLogin.getString("sUserID"));
            session.setAttribute("iUserType", rsdoLogin.getString("iUserType"));
            session.setAttribute("iUserLevel", rsdoLogin.getString("iUserLevel"));
            session.setAttribute("sUserName", sUserName);

            response.sendRedirect("calendar.jsp");
        } else {
            message = "Invalid username or password";
            response.sendRedirect("index.jsp?error=" + message);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }


    /// close object and connection
    try {
        if (psdoLogin != null) {
            psdoLogin.close();
        }
        if (rsdoLogin != null) {
            rsdoLogin.close();
        }

        if (conn != null) {
            conn.close();
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
