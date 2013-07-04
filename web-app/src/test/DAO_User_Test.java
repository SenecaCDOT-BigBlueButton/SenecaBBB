package test;

import java.util.ArrayList;
import dao.*;

public class DAO_User_Test {

    public DAO_User_Test() {
        ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
        User userTest = new User();

        //User Test 1
        if (userTest.getUserInfo(result)) {
            System.out.println(userTest.getQuery());
            printData(result);
        }
        else {
            System.out.println(userTest.getErrLog() + "\n");
        }
        
        //General Test: close and open connection
        userTest.closeConnection();
        userTest.openConnection();

        //User Test 2
        if (userTest.getUserInfo(result, "bli64")) {
            System.out.println(userTest.getQuery());
            printData(result);
        }
        else {
            System.out.println(userTest.getErrLog() + "\n");
        }
        
        //User Test 3
        if (userTest.getSaltAndHash(result, "non_ldap1")) {
            System.out.println(userTest.getQuery());
            printData(result);
        }
        else {
            System.out.println(userTest.getErrLog() + "\n");
        }
        
        //Clean userTest
        if (!userTest.clean()) {
            System.out.println(userTest.getErrLog() + "\n");
        }
        
        //Close connection at end
        userTest.closeConnection();
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
        result.clear();
    }

}