<%@page import="config.*"%>
<%!
// This is the security salt that must match the value set in the BigBlueButton server
//String salt = "3e563d1d6be259ffa26f916299128a48";
String salt=Config.getProperty("salt");
String BigBlueButtonURL = Config.getProperty("bigbluebuttonurl");
// This is the URL for the BigBlueButton server
//String BigBlueButtonURL = "http://192.168.30.131/bigbluebutton/";
%>
