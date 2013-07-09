package test;

import java.util.ArrayList;
import dao.*;

public class DAO_User_Test {
    static ArrayList<ArrayList<String>> _result = null;
    static User _user = null;
    static int _counter;
    public static final int TEN_SECONDS = 20000;

    public DAO_User_Test() {
        _user = new User();
        _result = new ArrayList<ArrayList<String>>();
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
        display(_user.getUserSetting(_result, "bli64"));
        
      //User Test 14
        //display(_user.getUserMeetingSetting(_result, "bli64"));
         
        //Clean
        if (!_user.clean()) {
            System.out.println(_user.getErrLog() + "\n");
        }
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

}