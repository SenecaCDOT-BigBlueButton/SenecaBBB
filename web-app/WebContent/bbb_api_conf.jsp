<%@page import="config.*"%>
<%!
    // The security salt that must match the value set in the BigBlueButton server
    String salt=Config.getProperty("salt");
    
    //The URL for BigBlueButton server
    String BigBlueButtonURL = Config.getProperty("bigbluebuttonurl");
%>
