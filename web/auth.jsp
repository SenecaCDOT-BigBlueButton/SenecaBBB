<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session"/>
<%@ page language="java" import="java.sql.*, javax.sql.*, javax.naming.*" errorPage="" %>
<%  
    if (request.getParameter("SenecaLDAPBBBLogin") != null && request.getParameter("SenecaLDAPBBBLoginPass") != null) {

        if (ldap.search(request.getParameter("SenecaLDAPBBBLogin"), request.getParameter("SenecaLDAPBBBLoginPass"))) {
            if (ldap.getAccessLevel() < 0) {
                response.sendRedirect("banned.jsp");
            } else {
                if (ldap.getAccessLevel() == 10) {
                    session.setAttribute("iUserType", "student");
                    session.setAttribute("iUserLevel", "student");
                } else if (ldap.getAccessLevel() == 20) {
                    session.setAttribute("iUserType", "employee");
                    session.setAttribute("iUserLevel", "employee");
                } else if (ldap.getAccessLevel() == 30) {
                    session.setAttribute("iUserType", "professor");
                    session.setAttribute("iUserLevel", "professor");
                }
                session.setAttribute("sUserName", ldap.getGivenName());
                session.setAttribute("sUserID", ldap.getUserID());
                response.sendRedirect("calendar.jsp");
            }
        } else {
            out.write("test");
            Connection conn = null;
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/usermaster", "db", "db");

            ResultSet rsdoLogin = null;
            PreparedStatement psdoLogin = null;

            String sUserID = request.getParameter("SenecaLDAPBBBLogin");
            String sPassword = request.getParameter("SenecaLDAPBBBLoginPass");
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
        }
    }
%>