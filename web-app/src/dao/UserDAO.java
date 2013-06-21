package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.User;
import db.DBConnection;

public class UserDAO {
	
	@SuppressWarnings("null")
	public User getUserByID(String userID) throws SQLException {

		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		User user = new User();

		try {

			DBConnection conn = DBConnection.getInstance();
			connection = conn.getConnection();

			String sqlQuery = "SELECT bbb_user.*, non_ldap_user.*, user_role.pr_name, user_role.ur_rolemask "
					+ "FROM bbb_user "
					+ "INNER JOIN non_ldap_user "
					+ "ON bbb_user.bu_id = non_ldap_user.bu_id "
					+ "INNER JOIN user_role "
					+ "ON bbb_user.ur_id = user_role.ur_id "
					+ "WHERE bbb_user.bu_id = '" + userID + "'";
			resultSet = preparedStatement.executeQuery(sqlQuery);

			while (resultSet.next()) {
				user.setUserID(resultSet.getString("bu_id"));
				user.setName(resultSet.getString("nu_name"));
				user.setLastname(resultSet.getString("nu_lastname"));
				user.setUserLevel(resultSet.getString("pr_name"));
				user.setUserType(resultSet.getString("pr_name"));

				// 0 means that is a non_ldap_user
				if (0 == resultSet.getByte("bu_isldap")) {
					user.setLDAP(false);
				} else {
					user.setLDAP(true);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (null != resultSet) {
				try {
					resultSet.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}

			if (null != preparedStatement) {
				try {
					resultSet.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}

			if (null != connection) {
				try {
					resultSet.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}

		}
		return user;
	}

	@SuppressWarnings("null")
	public List<User> getUsersWithinRange(int page, int size, boolean isSuper) throws SQLException {

		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		List<User> users = new ArrayList<User>();

		try {

			DBConnection conn = DBConnection.getInstance();
			connection = conn.getConnection();
			
			// First page is 1; and first row in the database is also 1.
			int minRow = (page * size) - (++size);
			int maxRow = page * size;
			
			String sqlQuery = "SELECT bbb_user.*, non_ldap_user.*, user_role.pr_name, user_role.ur_rolemask "
					+ "FROM bbb_user "
					+ "INNER JOIN non_ldap_user "
					+ "ON bbb_user.bu_id = non_ldap_user.bu_id "
					+ "INNER JOIN user_role "
					+ "ON bbb_user.ur_id = user_role.ur_id "
					+ "WHERE bbb_user.bu_issuper = '" + (isSuper==false?"0":"1") + "'";  
			
			// Pagination
			String orderedSqlQuery = "SELECT * FROM (SELECT paginated.*, ROWNUM rnum FROM (" + sqlQuery + ") paginated WHERE ROWNUM <= " + maxRow + " WHERE rnum >= " + minRow;
						
			resultSet = preparedStatement.executeQuery(orderedSqlQuery);
			
			while (resultSet.next()) {
				User user = new User();
				user.setUserID(resultSet.getString("bu_id"));
				user.setName(resultSet.getString("nu_name"));
				user.setLastname(resultSet.getString("nu_lastname"));
				user.setUserLevel(resultSet.getString("pr_name"));
				user.setUserType(resultSet.getString("pr_name"));
				// 0 means that is a non_ldap_user
				if (0 == resultSet.getByte("bu_isldap")) {
					user.setLDAP(false);
				} else {
					user.setLDAP(true);
				}
				users.add(user);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (null != resultSet) {
				try {
					resultSet.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}

			if (null != preparedStatement) {
				try {
					resultSet.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}

			if (null != connection) {
				try {
					resultSet.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}

		}
		return users;
	}
	
	public int getCount(String tableName){

		int count = 0;
		Connection connection = null;
		
		try {
			//connection = DBConnection.getInstance().getConnection();
			//DBConnection.openConnection();
			
			connection = DBConnection.getConnection();
			
			String sqlQuery = "SELECT COUNT(*) AS size FROM " + tableName;
			
			PreparedStatement preparedStatement = connection.prepareStatement(sqlQuery);
			ResultSet resultSet = preparedStatement.executeQuery();
			
			System.out.println("Count: " + resultSet.getString("size"));
			if (null == resultSet && !resultSet.isClosed()){
				resultSet.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return count;		
	}

	@SuppressWarnings("null")
	public List<User> getAllUsersOrderedByFilter(String filter)
			throws SQLException {

		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		List<User> users = new ArrayList<User>();

		try {
			connection = DBConnection.getConnection();

			// Insert more filters here.
			switch (filter) {
			case "name":
				filter = "nu_name";
			case "lastname":
				filter = "nu_lastname";
			default:
				filter = "nu_lastname";
			}

			String sqlQuery = "SELECT bbb_user.*, non_ldap_user.*, user_role.pr_name, user_role.ur_rolemask "
					+ "FROM bbb_user "
					+ "INNER JOIN non_ldap_user "
					+ "ON bbb_user.bu_id = non_ldap_user.bu_id "
					+ "INNER JOIN user_role "
					+ "ON bbb_user.ur_id = user_role.ur_id "
					+ "WHERE bbb_user.bu_issuper = 'false' "
					+ "ORDER BY '" + filter + "'";
			resultSet = preparedStatement.executeQuery(sqlQuery);

			while (resultSet.next()) {
				User user = new User();
				user.setUserID(resultSet.getString("bu_id"));
				user.setName(resultSet.getString("nu_name"));
				user.setLastname(resultSet.getString("nu_lastname"));
				user.setUserLevel(resultSet.getString("pr_name"));
				user.setUserType(resultSet.getString("pr_name"));
				// 0 means that is a non_ldap_user
				if (0 == resultSet.getByte("bu_isldap")) {
					user.setLDAP(false);
				} else {
					user.setLDAP(true);
				}
				users.add(user);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (null != resultSet) {
				try {
					resultSet.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}

			if (null != preparedStatement) {
				try {
					resultSet.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}

			if (null != connection) {
				try {
					resultSet.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}

		}
		return users;
	}
}
