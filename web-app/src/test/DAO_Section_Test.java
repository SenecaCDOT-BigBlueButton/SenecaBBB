package test;

import java.util.ArrayList;
import dao.*;

public class DAO_Section_Test {

    public DAO_Section_Test() {
        ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
        Section sectionTest = new Section();

        //Section Test 1
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
        
        //Clean sectionTest
        if (!sectionTest.clean()) {
            System.out.println(sectionTest.getErrLog() + "\n");
        }
        
        //Close connection at end
        sectionTest.closeConnection();
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