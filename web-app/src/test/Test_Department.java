package test;

import sql.*;

import db.DBAccess;

public class Test_Department extends Test_Helper {
    static Department _department = null;

    public Test_Department(DBAccess source) {
        super();
        _department = new Department(source);
        _test = _department;
        _counter = 1;
        
        _department.resetErrorFlag();
        
        display(_department.getDepartment(_result));
        
        display(_department.getDepartment(_result, "bli64"));
        
        display(_department.getDepartmentUser(_result));
        
        display(_department.getDepartmentUser(_result, "ABC"));
        
        display(_department.getDepartmentUser(_result, "bli64", "ICT"));
        
        display(_department.setDepartmentAdmin("xdeng7", "ICT", true));
        
        display(_department.setDepartmentName("IAT", "whatever"));
        
        display(_department.setDepartmentCode("ICT", "ABC"));
        
        display(_department.createDepartment("XIV", "guess"));
        
        display(_department.createDepartmentUser("non_ldap1", "IAT", true));
        
        display(_department.removeDepartment("XIV"));
        
        display(_department.removeDepartmentUser("non_ldap1", "IAT"));
        
        try
        {
            System.out.println(Integer.parseInt("2323sss"));
        }
        catch (NumberFormatException e)
        {
            System.out.println("sdsd");
        }
    }
}