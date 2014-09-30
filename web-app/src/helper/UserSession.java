package helper;
import java.util.ArrayList;
import java.util.HashMap;

public class UserSession {
    
    private String userId ="";
    private String firstName ="";
    private String lastName ="";
    private String userLevel ="";
    private String givenName="";
    private String nick="";
    private String email="";
    private HashMap<String, Integer> userSettingsMask = new HashMap<String, Integer>();
    private HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    private HashMap<String, Integer> userMeetingSettingsMask = new HashMap<String, Integer>();
    private boolean isLDAP = false;
    private boolean isSuper = false;
    private boolean isProfessor = false;
    private boolean isDepartmentAdmin = false;
    private ArrayList<ArrayList<String>> permissionList;
    
    public UserSession() {
        permissionList = new ArrayList<ArrayList<String>>();
    }
    
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getFirstName() {
        return firstName;
    }
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    public String getLastName() {
        return lastName;
    }
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    public boolean isLDAP() {
        return isLDAP;
    }
    public void setLDAP(boolean isLDAP) {
        this.isLDAP = isLDAP;
    }
    public String getUserLevel() {
        return userLevel;
    }
    public void setUserLevel(String userLevel) {
        this.userLevel = userLevel;
    }
    public String getGivenName() {
        return givenName;
    }
    public void setGivenName(String givenName) {
        this.givenName = givenName;
    }
    
    public boolean isSuper() {
        return isSuper;
    }
    
    public void setSuper(boolean isSuper) {
        this.isSuper = isSuper;
    }
    
    public boolean isProfessor() {
        return isProfessor;
    }
    
    public void setProfessor(boolean isProfessor) {
        this.isProfessor = isProfessor;
    }
    
    public boolean isDepartmentAdmin() {
        return isDepartmentAdmin;
    }
    
    public void setDepartmentAdmin(boolean isDepartmentAdmin) {
        this.isDepartmentAdmin = isDepartmentAdmin;
    }
    
    public String getNick() {
        return nick;
    }
    
    public void setNick(String nick) {
        this.nick = nick;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public HashMap<String, Integer> getRoleMask() {
        return roleMask;
    }
    
    public void setRoleMask(HashMap<String,Integer> roleMask) {
        this.roleMask = new HashMap<String,Integer>(roleMask);
    }
    
    public HashMap<String, Integer> getUserSettingsMask() {
        return userSettingsMask;
    }
    
    public void setUserSettingsMask(HashMap<String, Integer> userSettingsMask) {
        this.userSettingsMask = new HashMap<String,Integer>(userSettingsMask);
    }
    
    public HashMap<String, Integer> getUserMeetingSettingsMask() {
        return userMeetingSettingsMask;
    }
    
    public void setUserMeetingSettingsMask(HashMap<String, Integer> userMeetingSettingsMask) {
        this.userMeetingSettingsMask = new HashMap<String,Integer>(userMeetingSettingsMask);
    }
    
    public boolean inPermissionList(String type, String scheduleId, String eventId) {
        int i = 0;
        boolean flag = false;
        while (!flag && i<permissionList.size()) {
            if (permissionList.get(i).get(0).equals(type) && permissionList.get(i).get(1).equals(scheduleId) && permissionList.get(i).get(2).equals(eventId)) {
                flag = true;
            }
            i++;
        }
        return flag;
    }
    
    public void addToPermissionList(String type, String scheduleId, String eventId, String status) {
        ArrayList<String> toAdd = new ArrayList<String>();
        toAdd.add(type);
        toAdd.add(scheduleId);
        toAdd.add(eventId);
        toAdd.add(status);
        permissionList.add(toAdd);
    }
    
    public void setPermission(String type, String scheduleId, String eventId, String status) {
        int i = 0;
        boolean flag = false;
        while (!flag && i<permissionList.size()) {
            if (permissionList.get(i).get(0).equals(type) && permissionList.get(i).get(1).equals(scheduleId) && permissionList.get(i).get(2).equals(eventId)) {
                flag = true;
                permissionList.get(i).set(3, status);
            }
            i++;
        }   
    }
}
