<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel='stylesheet' type='text/css' href='css/calendar_layout.css'/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@ page import="java.sql.*, javax.sql.*, javax.naming.*;" %>
        <%
            String sValue = request.getParameter("view");
            if (sValue == null || sValue == "null") {
                sValue = "sLastName";
            }
        %>
        <script>
            var selected;
            function search() {
                document.getElementById("searchResults").innerHTML = "Search results displayed here";
            }
            function goPage() {
                window.location.href = "edit_user.jsp?create=true"
            }
            function run() {
                var drop = document.getElementById("orderBy")
                selected = drop.selectedIndex;
            }
        </script>
        <title>Manage Users</title>
    </head>
    <body>
        <div id="header">
            <h1>Manage Users</h1>
            <p id="layoutdims">

            </p>
        </div>
        <div class="colmask leftmenu">
            <div class="colleft">
                <div class="col1">
                    <div id="content">
                        Search for users <input type="search" name="search" id="search"/><input type="button" name="doSearch" onclick="search()" value="Search"/><br/><br/>
                        <div id="searchResults"></div>
                        <h2>Users in system</h2>
                        <form name="orderForm" method="post" action="">
                            Sort by: 
                            <select id="orderBy" name="view">
                                <option value="sUserID">User Name</option>
                                <option value="sLastName">Last Name</option>
                                <option value="iUserType">User Type</option>
                                <option value="iUserType">Online</option>
                            </select>
                            <input onclick="run()" type="submit">
                        </form>
                        <table border="1">
                            <tr>
                                <td>User Name</td>
                                <td>Name</td>
                                <td>Email</td>
                                <td>Department</td>
                                <td>Online</td>
                                <td>User Type</td>
                                <td>Ban</td>
                                <td>View Meetings/Lectures</td>
                                <td>Modify</td>
                            </tr>
                            <%
                                Connection conn = null;
                                Class.forName("com.mysql.jdbc.Driver").newInstance();
                                conn = DriverManager.getConnection("jdbc:derby://localhost:1527/usermaster", "db", "db");

                                ResultSet rsdoLogin = null;
                                PreparedStatement psdoLogin = null;

                                try {
                                    String sqlOption = "SELECT * FROM usermaster";

                                    psdoLogin = conn.prepareStatement(sqlOption);
                                    rsdoLogin = psdoLogin.executeQuery();

                                    while (rsdoLogin.next()) {
                                        out.write("<tr>");
                                        String sUserName = rsdoLogin.getString("sUserId");
                                        String sEmail = rsdoLogin.getString("sEmail");
                                        String sFirst = rsdoLogin.getString("sFirstName");
                                        String sLast = rsdoLogin.getString("sLastName");
                                        String sDepartment = rsdoLogin.getString("DEPARTMENT");
                                        String sName = sFirst + " " + sLast;
                                        String iUserType = rsdoLogin.getString("iUserType");
                                        out.write("<td>");
                                        out.write(sUserName);
                                        out.write("</td>");
                                        out.write("<td>");
                                        out.write(sName);
                                        out.write("</td>");
                                        out.write("<td>");
                                        out.write(sEmail);
                                        out.write("</td>");
                                         out.write("<td>");
                                        out.write(sDepartment);
                                        if (sLast.equals("Butts"))
                                            out.write("<strong> (Head)</strong>");
                                        out.write("</td>");
                                        if (iUserType.equals("employee") || iUserType.equals("professor") || iUserType.equals("superadmin")) {
                                            out.write("<td>Offline</td>");
                                        } else {
                                            out.write("<td><strong>Online</strong></td>");
                                        }
                                        out.write("<td>");
                                        out.write(iUserType);
                                        out.write("</td>");
                                        out.write("<td>");
                                        out.write("Banned: <input type=\"checkbox\"");
                                        out.write("</td>");
                                        out.write("<td><a href=\"calendar.jsp\">View</a></td>");
                                        out.write("<td><a href=\"edit_user.jsp?create=false&user=" + sUserName + "&fname=" + sFirst + "&lname=" + sLast + "&email=" + sEmail + "&usertype=" + iUserType + "\">Edit</a></td>");
                                        out.write("</tr>");
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
                        </table>
                        <input type="button" value="Create User" onclick="goPage()">
                    </div>
                </div>
                <div class="col2">
                    <a href="calendar.jsp"><strong>Back to Calendar</strong></a>
                </div>
            </div>
        </div>
        <div id="footer">
            This is the footer
        </div>
    </body>
</html>
