<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="java.util.*"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />

 <script type='text/javascript'>
 
 	//Code for XML request
	 		function newsubmit(event){
	 			event.preventDefault();
	 		}
            window.addEventListener('submit', newsubmit, true);
            function loadXMLDoc()
            {
            var xmlhttp;
            if (window.XMLHttpRequest)
            {// code for IE7+, Firefox, Chrome, Opera, Safari
              xmlhttp=new XMLHttpRequest();
            }
            else
            {// code for IE6, IE5
              xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.onreadystatechange=function()
            {
              if (xmlhttp.readyState==4 && xmlhttp.status==200)
              {
                document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
              }
            }
            	firstName = document.getElementById("firstName").value;
            	lastName = document.getElementById("lastName").value;
            	email = document.getElementById("email").value;
	            xmlhttp.open("GET","generate_guest.jsp?firstName=" + firstName + "&lastName=" + lastName + "&email=" + email,true);
	            xmlhttp.send();
            }
</script>