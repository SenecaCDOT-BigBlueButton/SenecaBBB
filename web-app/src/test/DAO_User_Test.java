package test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import db.DBAccess;
import dao.*;

public class DAO_User_Test {
    static ArrayList<ArrayList<String>> _result = null;
    static HashMap<String, Integer> _hm = null;
    static User _user = null;
    static int _counter;

    public DAO_User_Test(DBAccess source) {
        _user = new User(source);
        _result = new ArrayList<ArrayList<String>>();
        _hm = new HashMap<String, Integer>();
        _counter = 1;
        
        display(_user.getUserInfo(_result));

        display(_user.getUserInfo(_result, "bli64"));
        
        display(_user.getUserInfo(_result, 1, 5));
 
        display(_user.getUserInfo(_result, 2, 5));
        
        display(_user.getSaltAndHash(_result, "non_ldap5"));

        display(_user.setSalt("non_ldap1", "newsalt"));
        
        display(_user.getSalt(_result, "non_ldap1"));
        
        display(_user.getHash(_result, "non_ldap1"));
        
        display(_user.getName(_result, "non_ldap1"));
        
        display(_user.getLastName(_result, "non_ldap1"));
        
        display(_user.getNickName(_result, "bo.li"));
        
        display(_user.getRoleName(_result, "bo.li"));
        
        display(_user.getDepartment(_result, "bli64"));
        
        display(_user.getUserSetting(_hm, "bli64"));
        
        display(_user.getUserMeetingSetting(_hm, "bli64"));
        
        display(_user.getSectionSetting(_hm, "bo.li"));
        
        display(_user.getSectionSetting(_hm, "fardad.soleimanloo"));
        
        display(_user.isActive(_result, "bli64"));
        
        display(_user.isBannedFromSection(_result, "bli64", "OOP344", "A", "201305"));
        
        display(_user.isBannedFromSystem(_result, "bli64"));
        
        display(_user.getComment(_result, "bli64"));
        
        display(_user.isDepartmentAdmin(_result, "fardad.soleimanloo", "ICT"));
        
        display(_user.isSuperAdmin(_result, "fardad.soleimanloo"));

    }
    
    public static void display (boolean flag) {
        System.out.println("+++ User Test " + _counter + ": " + _user.getSQL());
        _counter++;
        if (flag) {
            if (_user.getSQL().substring(0, 6).equals("SELECT")) {
                if(!_result.isEmpty()) {
                    printData(_result);
                }
                else {
                    printData(_hm);
                }
            }
        }
        else {
            System.out.println(_user.getErrLog() + "\n");
        }
        System.out.println();
    }
    
    public static void printData(ArrayList<ArrayList<String>> result) {
        int i;
        int j;
        for (i=0; i<result.size(); i++) {
            for (j=0; j<result.get(i).size(); j++) {
                System.out.print(result.get(i).get(j) + "\t");
            }
            System.out.println();
        }
        result.clear();
    }
    
    public static void printData(HashMap<String, Integer> result) {
        Iterator<String> iter = result.keySet().iterator();
        while (iter.hasNext()) {
            String key = iter.next();
            Integer val = result.get(key);
            System.out.println(key + ": " + val);
        }
        result.clear();
    }

}