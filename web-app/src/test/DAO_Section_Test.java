package test;

import java.util.ArrayList;
import dao.*;

public class DAO_Section_Test {
    static ArrayList<ArrayList<String>> _result = null;
    static Section _section = null;
    static int _counter;

    public DAO_Section_Test() {
        _result = new ArrayList<ArrayList<String>>();
        _section = new Section();
        _counter = 1;
        
        //Section Test 1
        display(_section.getSectionInfo(_result));
        
        //Section Test 2
        display(_section.getSectionInfo(_result, "PSY100", "A", "201305"));
        
        //Clean
        if (!_section.clean()) {
            System.out.println(_section.getErrLog() + "\n");
        }
    }
    
    public static void display (boolean flag) {
        System.out.println("Section Test " + _counter + ": " + _section.getQuery());
        _counter++;
        if (flag) {
            printData(_result);
        }
        else {
            System.out.println(_section.getErrLog() + "\n");
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