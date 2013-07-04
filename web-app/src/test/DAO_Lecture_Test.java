package test;

import java.util.ArrayList;
import dao.*;

public class DAO_Lecture_Test {

    public DAO_Lecture_Test() {
        ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
        Lecture lectureTest = new Lecture();
        
        //Lecture Test 1
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
        
        //Close connection at end
        lectureTest.closeConnection();
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