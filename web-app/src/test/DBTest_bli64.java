package test;

import java.util.ArrayList;
import dao.*;

public class DBTest_bli64 {

    public static void main(String[] args) {
        ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
        User userTest = new User();
        Meeting meetingTest = new Meeting();
        Lecture lectureTest = new Lecture();
        Section sectionTest = new Section();

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
        
        //Meeting Test 1
        meetingTest.openConnection(); //reconnect
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
        
        //Lecture Test 1
        lectureTest.openConnection(); //reconnect
        if (lectureTest.getLectureInfo(result)) {
            System.out.println(lectureTest.getQuery());
            printData(result);
        }
        else {
            System.out.println(lectureTest.getErrLog() + "\n");
        }
        
        //Lecture Test 2
        if (lectureTest.getLectureInfo(result, "1", "1")) {
            System.out.println(lectureTest.getQuery());
            printData(result);
        }
        else {
            System.out.println(lectureTest.getErrLog() + "\n");
        }
        
        //Clean lectureTest
        if (!lectureTest.clean()) {
            System.out.println(lectureTest.getErrLog() + "\n");
        }
        
        //Section Test 1
        sectionTest.openConnection(); //reconnect
        if (sectionTest.getSectionInfo(result)) {
            System.out.println(sectionTest.getQuery());
            printData(result);
        }
        else {
            System.out.println(sectionTest.getErrLog() + "\n");
        }
        
        //Section Test 2
        if (sectionTest.getSectionInfo(result, "PSY100", "A", "201305")) {
            System.out.println(sectionTest.getQuery());
            printData(result);
        }
        else {
            System.out.println(sectionTest.getErrLog() + "\n");
        }
        
        //Clean lectureTest
        if (!sectionTest.clean()) {
            System.out.println(sectionTest.getErrLog() + "\n");
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