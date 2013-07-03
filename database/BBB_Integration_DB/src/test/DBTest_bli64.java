package test;

import java.util.ArrayList;
import dao.*;

public class DBTest_bli64 {

    public static void main(String[] args) {
        ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
        User userTest = new User();
        Meeting meetingTest = new Meeting();

        //User Test 1: getUserInfo()
        if (userTest.getUserInfo(result)) {
            System.out.println(userTest.getQuery());
            printData(result);
        }
        else {
            System.out.println(userTest.getErrLog());
        }
        
        //General Test: close and open connection
        userTest.closeConnection();
        userTest.openConnection();

        //User Test 2: getUserInfo(String bu_id)
        if (userTest.getUserInfo(result, "bli64")) {
            System.out.println(userTest.getQuery());
            printData(result);
        }
        else {
            System.out.println(userTest.getErrLog());
        }
        
        //User Test 3: getSaltAndHash(String bu_id)
        if (userTest.getSaltAndHash(result, "non_ldap1")) {
            System.out.println(userTest.getQuery());
            printData(result);
        }
        else {
            System.out.println(userTest.getErrLog());
        }
        
        //Clean userTest
        if (!userTest.clean()) {
            System.out.println(userTest.getErrLog());
        }
        
        //Meeting Test 1: getMeetingInfo()
        meetingTest.openConnection(); //reconnect
        if (meetingTest.getMeetingInfo(result)) {
            System.out.println(meetingTest.getQuery());
            printData(result);
        }
        else {
            System.out.println(meetingTest.getErrLog());
        }
        
        //Meeting Test 2: getMeetingInfo(String ms_id, String m_id)
        if (meetingTest.getMeetingInfo(result, "1", "1")) {
            System.out.println(meetingTest.getQuery());
            printData(result);
        }
        else {
            System.out.println(meetingTest.getErrLog());
        }
        
        //Clean meetingTest
        if (!meetingTest.clean()) {
            System.out.println(meetingTest.getErrLog());
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