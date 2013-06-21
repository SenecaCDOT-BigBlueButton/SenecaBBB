package model;

public class User {
	private String userID;
	private String name;
	private String lastname;
	private String userLevel;
	private String userType;
	private boolean isLDAP;

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getLastname() {
		return lastname;
	}

	public void setLastname(String lastname) {
		this.lastname = lastname;
	}

	public String getUserLevel() {
		return userLevel;
	}

	public void setUserLevel(String userLevel) {
		this.userLevel = userLevel;
	}

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}

	public boolean isLDAP() {
		return isLDAP;
	}

	public void setLDAP(boolean isLDAP) {
		this.isLDAP = isLDAP;
	}
}
