package test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import db.DBQuery;
import dao.*;

public class DAO_User_Test {
    static ArrayList<ArrayList<String>> _result = null;
    static HashMap<String, Integer> _hm = null;
    static User _user = null;
    static int _counter;

    public DAO_User_Test(DBQuery source) {
        _user = new User(source);
        _result = new ArrayList<ArrayList<String>>();
        _hm = new HashMap<String, Integer>();
        _counter = 1;
        
        //User Test 1
        display(_user.getUserInfo(_result));

        //User Test 2
        display(_user.getUserInfo(_result, "bli64"));
        
        //User Test 3
        display(_user.getUserInfo(_result, 1, 5));
 
        //User Test 4
        display(_user.getUserInfo(_result, 2, 5));
        
        //User Test 5
        display(_user.getSaltAndHash(_result, "non_ldap1"));
        
        //User Test 6
        display(_user.getSalt(_result, "non_ldap1"));
        
        //User Test 7
        display(_user.getHash(_result, "non_ldap1"));
        
        //User Test 8
        display(_user.getName(_result, "non_ldap1"));
        
        //User Test 9
        display(_user.getName(_result, "non_ldap1"));
        
        //User Test 10
        display(_user.getLastName(_result, "non_ldap1"));
        
        //User Test 11
        display(_user.getNickName(_result, "bo.li"));
        
        //User Test 12
        display(_user.getRoleName(_result, "bo.li"));
        
        //User Test 13
        display(_user.getDepartment(_result, "bli64"));
        
        //User Test 14
        displayMap(_user.getUserSetting(_hm, "bli64"));
        
        //User Test 15
        displayMap(_user.getUserMeetingSetting(_hm, "bli64"));
        
        //User Test 16
        displayMap(_user.getSectionSetting(_hm, "bo.li"));
        
        //User Test 17
        displayMap(_user.getSectionSetting(_hm, "fardad.soleimanloo"));

    }
    
    public static void display (boolean flag) {
        System.out.println("User Test " + _counter + ": " + _user.getQuery());
        _counter++;
        if (flag) {
            printData(_result);
        }
        else {
            System.out.println(_user.getErrLog() + "\n");
        }
    }
    
    public static void displayMap (boolean flag) {
        System.out.println("User Test " + _counter + ": " + _user.getQuery());
        _counter++;
        if (flag) {
            printData(_hm);
        }
        else {
            System.out.println(_user.getErrLog() + "\n");
        }
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
        System.out.println();
    }
    
    public static void printData(HashMap<String, Integer> result) {
        Iterator<String> iter = result.keySet().iterator();
        while (iter.hasNext()) {
            String key = iter.next();
            Integer val = result.get(key);
            System.out.println(key + ": " + val);
        }
        System.out.println();
    }

}