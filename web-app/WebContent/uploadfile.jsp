<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.io.InputStream"%>
<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%@page import="java.util.List"%>
<%@page import="java.util.*"%>
<%@page import="sql.*"%>
<%@page import="helper.*"%>
<%@page import="db.DBConnection"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<jsp:useBean id="ldap" class="ldap.LDAPAuthenticate" scope="session" />
<%@ include file="search.jsp" %>
<%

	//Start page validation
	String userId = usersession.getUserId();
	Boolean isSuper = usersession.isSuper();
	Boolean isProfessor = usersession.isProfessor();
	if (userId.equals("")) {
	    response.sendRedirect("index.jsp?error=Please log in");
	    return;
	}
	if (dbaccess.getFlagStatus() == false) {
	    response.sendRedirect("index.jsp?error=Database connection error");
	    return;
	} 
	if (!isSuper && !isProfessor) {
	    response.sendRedirect("calendar.jsp?message=You don't have permissions to view that page.");
	    return;
	}
	
	//End page validation
	
// (request.getParameter("testData") != null) {
    ArrayList<String> singleResult = new ArrayList<String>();
    ArrayList<String> studentListResult = new ArrayList<String>();
    Section section = new Section(dbaccess);
    Lecture lecture = new Lecture(dbaccess);
    MyBoolean myBool = new MyBoolean();  
    User user = new User(dbaccess);
    String classSection=null;
    String bu_id=null;
    String message="";
    String errMessage="";
    int userNameColumn=1;
    Boolean isUsername=false;
    int totalColumns =1;
    int counter=0;
	try {
	    List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
	    System.out.println(items.size());
	    for (FileItem item : items) {
	        if (item.isFormField()) {
	            // Process regular form field (input type="text|radio|checkbox|etc", select, etc).
	            String fieldname = item.getFieldName();
	            String fieldvalue = item.getString();
	            //get the class information
	            if(fieldname.equals("class")){
	            	classSection = fieldvalue;
	            }
	        } else {
	            // Process form file field (input type="file").
	            String fieldname = item.getFieldName();
	            String filename = FilenameUtils.getName(item.getName());
	            
	            //convert file into a String
	            String contentType = item.getContentType();
	            String filecontent="";
	            System.out.println(contentType);
	            // xls file format with 'tab' 
	            if(contentType.equals("application/vnd.ms-excel")){
	               filecontent = item.getString("UTF-16");
	               for ( int i =0; i<filecontent.length();i++) {
	                    if(filecontent.charAt(i)=='\t')
	                        totalColumns++;
	                    if(filecontent.charAt(i)=='\n'){
	                        i=filecontent.length();
	                    }
	               }
	                filecontent = filecontent.replace('\n', '\t');
	            }
	            //csv file format with 'comma'
	            else if(contentType.equals("text/csv")){
	              filecontent = item.getString();
	              System.out.println(filecontent);
	              for ( int i =0; i<filecontent.length();i++) {
	                    if(filecontent.charAt(i)==',')
	                        totalColumns++;
	                    if(filecontent.charAt(i)=='\n'){
	                        i=filecontent.length();
	                    }
	                }
	                filecontent = filecontent.replace('\n', ',');
	            }
	            else{
	            	errMessage = "Sorry,we only support CSV with comma separated or XLS with tab separated file format!";
	            	response.sendRedirect("class_settings.jsp?errMessage=" + errMessage + "&class=" + classSection);
	            	return;
	            }
	            
                StringBuilder builder = new StringBuilder();
                           
                //read each character of the file-string
                //escape 'tab','double-quote' characters
                //get each cell content of the file and store in an ArrayList
	            for ( int i =0; i<filecontent.length();i++) {
                    if(filecontent.charAt(i) != '\t' && filecontent.charAt(i) != ','){                	
                        char temp = filecontent.charAt(i);
                        if(temp=='"')
                        	temp=' ';
                    	builder.append(temp);
                    }
                    else {
                        if(!builder.toString().isEmpty()){
                    	    singleResult.add(builder.toString().trim());
                        }
                        builder.delete(0,builder.length());                     
                    }                      
                }
	        }
	    }
	    
	} catch (FileUploadException e) {
	    //throw new ServletException("Cannot parse multipart request.", e);
	    System.out.println("Exception");
	}
	

    //find the "Username" column number
	for(int k=0;k< singleResult.size();k++){			
		if(singleResult.get(k).replace('"',' ').trim().equals("Username")){
			userNameColumn = k;
			isUsername = true;
		}
    } 
    if(!isUsername){
        errMessage = "Sorry,can't find student 'Username' column in your file";
        response.sendRedirect("class_settings.jsp?errMessage=" + errMessage + "&class=" + classSection);
        return;
    }
	//get student username to add		
    int firstStudent =  userNameColumn + totalColumns; 
    while(firstStudent<singleResult.size()){
	  studentListResult.add(singleResult.get(firstStudent).trim());
	  firstStudent += totalColumns;
    }

	//validate student username and add each qualified student username to the class
	
    for(int j=0;j<studentListResult.size();j++){
	   bu_id = studentListResult.get(j).trim();
	// Start User Search
	    int i = 0;
	    boolean searchSucess = false;
	    if (bu_id!=null) {
	        bu_id = Validation.prepare(bu_id);
	        if (!(Validation.checkBuId(bu_id))) {
	            message = Validation.getErrMsg();
	        } else {
	            if (!user.isLectureStudent(myBool, classSection.split("-")[0], classSection.split("-")[1],classSection.split("-")[2],bu_id)) {
	                message += user.getErrMsg("AS03"); 
	                response.sendRedirect("logout.jsp?message=" + message);
	                return;   
	            }
	            // User already added
	            if (myBool.get_value()) {
	            	errMessage += bu_id+ "  already added in the class </br>";
	            } else {
	                if (!user.isUser(myBool, bu_id)) {
	                    message += user.getErrMsg("AS04");
	                    response.sendRedirect("logout.jsp?message=" + message);
	                    return;   
	                }
	                // User already in Database
	                if (myBool.get_value()) {   
	                    searchSucess = true;
	                } else {
	                    // Found userId in LDAP
	                    if (findUser(dbaccess, ldap, bu_id)) {
	                        searchSucess = true;
	                    } else {
	                    	errMessage += bu_id + " Not Found </br>";
                        }
	                }
	            }
	        }
	    }
	    // End User Search
	    
		if (searchSucess) {
		    ArrayList<ArrayList<String>> curCourse = new ArrayList<ArrayList<String>>();
		    if (!section.createStudent(bu_id, classSection.split("-")[0], classSection.split("-")[1],classSection.split("-")[2], false)) {
		        message = section.getErrMsg("AS06");
	            response.sendRedirect("logout.jsp?message=" + message);
	            return;  
		    } else {
		    	counter += 1;
		    	message = "Total of: "+ counter +  " students added to the class </br>";
		    }
		}
   }
   response.sendRedirect("class_settings.jsp?message=" + message + "&class=" + classSection + "&errMessage=" + errMessage);   
%>
