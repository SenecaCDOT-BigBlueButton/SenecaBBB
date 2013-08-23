<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="db" class="db.DBConnection" scope="session" />
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
            function goPage(){
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
                            </select>
                            <input onclick="run()" type="submit">
                        </form>
                        <table border="1">
                            <tr>
                                <td>User Name</td>
                                <td>Name</td>
                                <td>Email</td>
                                <td>User Type</td>
                                <td>Modify</td>
                            </tr>
                            <%
                                try {
									//////////////////////////////////////////////////////
                                	/* this table doesn't exist!!!*/
                                	//////////////////////////////////////////////////////
                                    
                                    ResultSet rsdoLogin = db.getUsers(sValue);
                                    
                                    while (rsdoLogin.next()) {
                                        out.write("<tr>");
                                        String sUserName = rsdoLogin.getString("sUserId");
                                        String sEmail = rsdoLogin.getString("sEmail");
                                        String sFirst = rsdoLogin.getString("sFirstName");
                                        String sLast = rsdoLogin.getString("sLastName");
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
                                        out.write(iUserType);
                                        out.write("</td>");
                                        out.write("<td><a href=\"edit_user.jsp?create=false&user=" + sUserName + "&fname=" + sFirst + "&lname=" + sLast + "&email=" + sEmail + "&usertype=" + iUserType + "\">Edit</a></td>");
                                        out.write("</tr>");
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
