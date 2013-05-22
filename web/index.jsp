<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    session.invalidate();
    String error = request.getParameter("error");
    if (error == null || error == "null") {
        error = "";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <link rel='stylesheet' type='text/css' href='css/login.css' />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Login Page</title>
        <script>
            function trim(s)
            {
                return s.replace(/^\s*/, "").replace(/\s*$/, "");
            }
            function validate()
            {
                if (trim(document.formLogin.username.value) == "")
                {
                    alert("Login empty");
                    document.formLogin.username.focus();
                    return false;
                }
                else if (trim(document.formLogin.password.value) == "")
                {
                    alert("Password empty");
                    document.formLogin.password.focus();
                    return false;
                }
            }
        </script>
    </head>
    <body>
        <div id="error"><h2><%=error%></h2></div>
        <form id ="login" name="formLogin" action="response.jsp" onSubmit="return validate();" method="post">
            <h1>Log In</h1>
            <fieldset id="inputs">
                <input id="username" name="username" type="text" placeholder="Username" autofocus required>   
                <input id="password" name="password" type="password" placeholder="Password" required>
            </fieldset>
            <fieldset id="actions">
                <input type="submit" id="submit" value="Log in">
            </fieldset>
        </form>
    </body>
</html>
