<%@page import="sql.User"%>
<%@page import="sql.Meeting"%>
<%@page import="sql.Lecture"%>
<%@page import="java.util.ArrayList" %>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Seneca | Contact Us</title>
    <link rel="icon" href="http://www.cssreset.com/favicon.png">
    <link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
    <link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
</head>
<body>
    <div id="page">
        <jsp:include page="header.jsp"/>
        <jsp:include page="menu.jsp"/>
        <section>
            <header>
                <p><a href="calendar.jsp" tabindex="13">home</a> »<a href="contactUs.jsp" tabindex="13">contact us</a> </p>
                <h1>Contact Us</h1>               
            </header>
            <div class="contactus">
	            <h2>Seneca College of Applied Arts and Technology</h2>          
	            <p>Seneca@York Campus </p>
	            <p>70 The Pond Road  </p>
	            <p>Toronto, Ontario, M3J 3M6  </p>
	            <p>Phone: (416) 491-5050 ext 33220  </p>
	            

            </div>
            <div class="contactus">                
                <h2>Contact Persons</h2>
                <p>Fardad Soleimanloo</p>
                <p><a href="mailto:fardad.soleimanloo@senecacollege.ca?subject=senecaBBB">fardad.soleimanloo@senecacollege.ca</a></p>
                <p>Chad Pilkey</P>
                <p><a href="mailto:chad.pilkey@senecacollege.ca?subject=senecaBBB">chad.pilkey@senecacollege.ca</a></p>                             
            </div>
                            
            <!-- TODO: in order to let user contact super admin, it's better to allow use to send message here 
                <form >
                    <article>
                        <header >
                            <h2>Contact Information</h2>
                            <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content" alt="Arrow"/>
                        </header>
                        <div class="content">                               
		                    <fieldset>
		                        <div class="component">
		                            <label for="firstname" class="label">First Name:</label>
		                            <input name="firstname" id="firstname" class="input" tabindex="16" title="firstname" type="text"    autofocus>
		                        </div>
		                        <div class="component">
		                            <label for="lastname" class="label">Last Name:</label>
		                            <input name="lastname" id="lastname" class="input" tabindex="17" title="lastname" type="text" required autofocus>
		                        </div>
		                        <div class="component">
		                            <label for="email" class="label">Email:</label>
		                            <input name="email" id="email" class="input" tabindex="18" title="email" type="text"  required autofocus>
		                        </div>
		                        <div class="component">
		                            <label for="messageArea" class="label">Message:</label>
		                            <textarea id="messageArea" name="messageArea">
		                            </textarea>
		                        </div>
		              
		                        <div class="component">
		                            <div class="buttons">
		                               <input type="submit" name="sendmessage" id="sendmessage" class="button" value="Send" title="Click here to send" >
		                               <input type="reset" name="resetmessage" id="resetmessage" class="button" title="Click here to reset">		                            		                              
		                            </div>
		                        </div>
		                    </fieldset>
		                    <div id="addressbar" style="position:absolute; bottom:140px">
                                Seneca@York Campus | Seneca College | 70 The Pond Road | Toronto, Ontario, M3J 3M6 | Phone: (416) 491-5050 | Fax: (416) 491-5050
                            </div>
                           
                        </div>
                    </article>
                </form>
                -->
        </section>
        <jsp:include page="footer.jsp"/>
    </div>
</body>
</html>

