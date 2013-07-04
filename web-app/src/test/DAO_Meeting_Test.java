package test;

import java.util.ArrayList;
import dao.*;

public class DAO_Meeting_Test {

    public DAO_Meeting_Test() {
        ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
        Meeting meetingTest = new Meeting();

        //Meeting Test 1
        if (meetingTest.getMeetingInfo(result)) {
            System.out.println(meetingTest.getQuery());
            printData(result);
        }
        else {
            System.out.println(meetingTest.getErrLog() + "\n");
        }
        
        //Meeting Test 2
        if (meetingTest.getMeetingInfo(result, "1", "1")) {
            System.out.println(meetingTest.getQuery());
            printData(result);
        }
        else {
            System.out.println(meetingTest.getErrLog() + "\n");
        }
        
        //Clean meetingTest
        if (!meetingTest.clean()) {
            System.out.println(meetingTest.getErrLog() + "\n");
        }
        
        meetingTest.closeConnection();
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