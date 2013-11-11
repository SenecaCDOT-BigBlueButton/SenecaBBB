<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.io.InputStream"%>
<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%@page import="java.util.List"%>
<html>
<head>
</head>
<%
// (request.getParameter("testData") != null) {
	try {
	    List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
	    System.out.println(items.size());
	    for (FileItem item : items) {
	        if (item.isFormField()) {
	            // Process regular form field (input type="text|radio|checkbox|etc", select, etc).
	            String fieldname = item.getFieldName();
	            String fieldvalue = item.getString();
	            System.out.println(fieldname + ": " + fieldvalue);
	        } else {
	            // Process form file field (input type="file").
	            String fieldname = item.getFieldName();
	            String filename = FilenameUtils.getName(item.getName());
	            InputStream filecontent = item.getInputStream();
	            int letter = filecontent.read();
	            while (letter != -1) {
	            	System.out.println((char)letter);
	            	letter = filecontent.read();
	            }
	            System.out.println(item.toString());
	        }
	    }
	} catch (FileUploadException e) {
	    //throw new ServletException("Cannot parse multipart request.", e);
	    System.out.println("Exception");
	}
//}
%>
<body>
<form action="uploadfile.jsp" method="post" enctype="multipart/form-data">
    <input type="file" name="file" />
    <input type="hidden" name="testData" value="TESTING" />
    <input type="submit" />
</form>
</body>
</html>