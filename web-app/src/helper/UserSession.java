package helper;

public class UserSession {
	
	private String userId ="";
	private String firstName ="";
	private String lastName ="";
	private boolean isLDAP = false;
	private String userLevel ="";
	private String givenName="";
	
	public UserSession() {
		
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
}
