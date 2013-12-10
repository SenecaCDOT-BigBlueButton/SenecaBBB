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
    GetExceptionLog elog = new GetExceptionLog();
    Boolean isSuper = usersession.isSuper();
    Boolean isProfessor = usersession.isProfessor();
    if (userId.equals("")) {
    	elog.writeLog("[uploadfile:] " + "unauthenticated user tried to access this page /n");
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
    	elog.writeLog("[uploadfile:] " + "database connection error /n");
        response.sendRedirect("index.jsp?message=Database connection error");
        return;
    } 
    if (!isSuper && !isProfessor) {
        elog.writeLog("[uploadfile:] " + " username: "+ userId + " tried to access this page, permission denied" +" /n");           
        response.sendRedirect("calendar.jsp?message=You don't have permissions to view that page.");
        return;
    }
    
    //End page validation
    
    //TODO: find a better way to detect uploaded file encode type
    //Temp solution: use the popular encode types such as ISO,UTF-8,UTF-16
    ArrayList<String> singleResult = new ArrayList<String>();
    ArrayList<String> singleResultISO = new ArrayList<String>();
    ArrayList<String> singleResultUTF8 = new ArrayList<String>();
    ArrayList<String> singleResultUTF16 = new ArrayList<String>();
    ArrayList<String> studentListResult = new ArrayList<String>();
    Section section = new Section(dbaccess);
    Lecture lecture = new Lecture(dbaccess);
    MyBoolean myBool = new MyBoolean();  
    User user = new User(dbaccess);
    String classSection=null;
    String bu_id=null;
    String message="";
    String successMessage="";
    int userNameColumn=1;
    int userNameColumnISO=1;
    int userNameColumnUTF8=1;
    int userNameColumnUTF16=1;
    Boolean isUsername=false;
    Boolean isUsernameISO=false;
    Boolean isUsernameUTF8=false;
    Boolean isUsernameUTF16=false;
    Boolean usernameFound=false;
    int totalColumns =1;
    int totalColumnsISO =1;
    int totalColumnsUTF8 =1;
    int totalColumnsUTF16 =1;
    String filetype=null;
    String filecontent="";
    String filecontentISO="";
    String filecontentUTF8="";
    String filecontentUTF16="";
    int counter=0;
    try {
        List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
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
                filecontent = item.getString();
                filecontentUTF8 = item.getString("UTF-8");
                filecontentUTF16 = item.getString("UTF-16");
                filecontentISO = item.getString("ISO-8859-1");
                filetype = filename.substring(filename.length()-3,filename.length());
                // xls file format with 'tab' 
                if(filetype.equals("xls")){
                   for ( int i =0; i<filecontent.length();i++) {
                        if(filecontent.charAt(i)=='\t')
                            totalColumns++;
                        if(filecontent.charAt(i)=='\n'){
                            i=filecontent.length();
                        }
                   }
                   for ( int i =0; i<filecontentISO.length();i++) {
                       if(filecontentISO.charAt(i)=='\t')
                    	   totalColumnsISO++;
                       if(filecontentISO.charAt(i)=='\n'){
                           i=filecontentISO.length();
                       }
                   }
                   for ( int i =0; i<filecontentUTF8.length();i++) {
                       if(filecontentUTF8.charAt(i)=='\t')
                    	   totalColumnsUTF8++;
                       if(filecontentUTF8.charAt(i)=='\n'){
                           i=filecontentUTF8.length();
                       }
                   }
                   for ( int i =0; i<filecontentUTF16.length();i++) {
                       if(filecontentUTF16.charAt(i)=='\t')
                    	   totalColumnsUTF16++;
                       if(filecontentUTF16.charAt(i)=='\n'){
                           i=filecontentUTF16.length();
                       }
                   }
                   filecontent = filecontent.replace('\n', '\t');
                   filecontentISO = filecontentISO.replace('\n', '\t');
                   filecontentUTF8 = filecontentUTF8.replace('\n', '\t');
                   filecontentUTF16 = filecontentUTF16.replace('\n', '\t');
                }
                //csv file format with 'comma'
                else if(filetype.equals("csv")){
                    for ( int i =0; i<filecontent.length();i++) {
                        if(filecontent.charAt(i)==',')
                            totalColumns++;
                        if(filecontent.charAt(i)=='\n'){
                            i=filecontent.length();
                        }
                    }
                	for ( int i =0; i<filecontentISO.length();i++) {
                        if(filecontentISO.charAt(i)==',')
                        	totalColumnsISO++;
                        if(filecontentISO.charAt(i)=='\n'){
                            i=filecontentISO.length();
                        }
                    }
                    for ( int i =0; i<filecontentUTF8.length();i++) {
                        if(filecontentUTF8.charAt(i)==',')
                            totalColumnsUTF8++;
                        if(filecontentUTF8.charAt(i)=='\n'){
                            i=filecontentUTF8.length();
                        }
                    }

                    for ( int i =0; i<filecontentUTF16.length();i++) {
                        if(filecontentUTF16.charAt(i)==',')
                    	    totalColumnsUTF16++;
                        if(filecontentUTF16.charAt(i)=='\n'){
                            i=filecontentUTF16.length();
                        }
                    }
	                filecontent = filecontent.replace('\n', ',');
	                filecontentISO = filecontentISO.replace('\n', ',');
	                filecontentUTF8 = filecontentUTF8.replace('\n', ',');
	                filecontentUTF16 = filecontentUTF16.replace('\n', ',');
                }
                else{
                    message = "Sorry,we only support CSV with comma separated or XLS with tab separated file format!";
                    response.sendRedirect("class_settings.jsp?message=" + message + "&class=" + classSection);
                    return;
                }
                
                StringBuilder builder = new StringBuilder();
                           
                //read each character of the file-string
                //escape 'tab','double-quote' characters
                //get each cell content of the file and store in an ArrayList
                
                for ( int i =0; i<filecontentISO.length();i++) {
                    if(filecontentISO.charAt(i) != '\t' && filecontentISO.charAt(i) != ','){                    
                        char temp = filecontentISO.charAt(i);
                        if(temp=='"')
                            temp=' ';
                        builder.append(temp);
                    }
                    else {
                        if(!builder.toString().isEmpty()){
                        	singleResultISO.add(builder.toString().trim());
                        }
                        builder.delete(0,builder.length());                     
                    }                      
                }
                
                builder.delete(0,builder.length());
                for ( int i =0; i<filecontentUTF8.length();i++) {
                    if(filecontentUTF8.charAt(i) != '\t' && filecontentUTF8.charAt(i) != ','){                    
                        char temp = filecontentUTF8.charAt(i);
                        if(temp=='"')
                            temp=' ';
                        builder.append(temp);
                    }
                    else {
                        if(!builder.toString().isEmpty()){
                        	singleResultUTF8.add(builder.toString().trim());
                        }
                        builder.delete(0,builder.length());                     
                    }                      
                }
                
                builder.delete(0,builder.length());
                for ( int i =0; i<filecontentUTF16.length();i++) {
                    if(filecontentUTF16.charAt(i) != '\t' && filecontentUTF16.charAt(i) != ','){                    
                        char temp = filecontentUTF16.charAt(i);
                        if(temp=='"')
                            temp=' ';
                        builder.append(temp);
                    }
                    else {
                        if(!builder.toString().isEmpty()){
                            singleResultUTF16.add(builder.toString().trim());
                        }
                        builder.delete(0,builder.length());                     
                    }                      
                }
                
                builder.delete(0,builder.length());
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
        elog.writeLog("[fileupload:] " + e.getMessage() +" /n" + e.getStackTrace() +"/n");        
    }
    

    //find the "Username" column number
    for(int k=0;k< singleResult.size();k++){            
        if(singleResult.get(k).replace('"',' ').trim().equals("Username")){
            userNameColumn = k;
            isUsername = true;
            usernameFound = true;
        }
    } 
    if(!usernameFound){
        for(int k=0;k< singleResultUTF16.size();k++){            
            if(singleResultUTF16.get(k).replace('"',' ').trim().equals("Username")){
                userNameColumnUTF16 = k;
                isUsernameUTF16 = true;
                usernameFound = true;
            }
        }
    }

    if(!usernameFound){
        for(int k=0;k< singleResultUTF8.size();k++){            
            if(singleResultUTF8.get(k).replace('"',' ').trim().equals("Username")){
                userNameColumnUTF8 = k;
                isUsernameUTF8 = true;
                usernameFound = true;
            }
        }
    }

    if(!usernameFound){
        for(int k=0;k< singleResultISO.size();k++){            
            if(singleResultISO.get(k).replace('"',' ').trim().equals("Username")){
                userNameColumnISO = k;
                isUsernameISO = true;
                usernameFound = true;
            }
        }
    }
    if(!usernameFound){
        message = "Sorry,can't find student 'Username' column in your file";
        elog.writeLog("[fileupload:] " + message + " unsupported file format" +"/n");   
        response.sendRedirect("class_settings.jsp?message=" + message + "&class=" + classSection);
        return;
    }
    //get student username to add 
    if(isUsername){
	    int firstStudent =  userNameColumn + totalColumns; 
	    while(firstStudent<singleResult.size()){
	      studentListResult.add(singleResult.get(firstStudent).trim());
	      firstStudent += totalColumns;
	    }
    }else if(isUsernameUTF16){
        int firstStudent =  userNameColumnUTF16 + totalColumnsUTF16; 
        while(firstStudent<singleResultUTF16.size()){
          studentListResult.add(singleResultUTF16.get(firstStudent).trim());
          firstStudent += totalColumnsUTF16;
        }   	
    }
    else if(isUsernameUTF8){
        int firstStudent =  userNameColumnUTF8 + totalColumnsUTF8; 
        while(firstStudent<singleResultUTF8.size()){
          studentListResult.add(singleResultUTF8.get(firstStudent).trim());
          firstStudent += totalColumnsUTF8;
        }       
    }else{
        int firstStudent =  userNameColumnISO + totalColumnsISO; 
        while(firstStudent<singleResultISO.size()){
          studentListResult.add(singleResultISO.get(firstStudent).trim());
          firstStudent += totalColumnsISO;
        }       	
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
                    elog.writeLog("[fileupload:] " + message  +"/n");
                    response.sendRedirect("logout.jsp?message=" + message);
                    return;   
                }
                // User already added
                if (myBool.get_value()) {
                    message += bu_id+ "  already added in the class </br>";
                } else {
                    if (!user.isUser(myBool, bu_id)) {
                        message += user.getErrMsg("AS04");
                        elog.writeLog("[fileupload:] " + message  +"/n");
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
                            message += bu_id + " Not Found </br>";
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
                elog.writeLog("[fileupload:] " + message  +"/n");
                response.sendRedirect("logout.jsp?message=" + message);
                return;  
            } else {
                counter += 1;
                successMessage = "Total of: "+ counter +  " students added to the class </br>";
            }
        }
   }
   response.sendRedirect("class_settings.jsp?message=" + message + "&class=" + classSection + "&successMessage=" + successMessage);   
%>
