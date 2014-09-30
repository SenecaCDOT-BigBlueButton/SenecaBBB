<%@page import="sql.User"%>
<%@page import="ldap.LDAPAuthenticate" %>
<%@page import="db.DBAccess" %>
<%@page import="java.util.ArrayList" %>

<%!
public boolean findUser(DBAccess dbaccess, LDAPAuthenticate ldap, String bu_id) {
    if (dbaccess.getFlagStatus() == false) {
        return false;
    } else {
        if (bu_id == "") {
            return false;
        } else {
            // search the db first
            User user = new User(dbaccess);
            ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
            user.getUserInfo(result, bu_id);
            
            if (result.size() > 0) { // user is already in the DB
                return true;
            } else {
                // if found in LDAP create new bbb_user row in db
                if (ldap.search(bu_id)) {
                    if (ldap.getPosition().equals("Employee"))
                        user.createEmployeeUser(bu_id, " ", true);
                    else
                        user.createStudentUser(bu_id, " ", true);
                    return true;
                } else {
                    return false;
                }
            }
        }
    }
}
%>