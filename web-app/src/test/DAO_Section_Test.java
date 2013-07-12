package test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import dao.*;
import db.DBQuery;

public class DAO_Section_Test {
    static ArrayList<ArrayList<String>> _result = null;
    static Section _section = null;
    static int _counter;

    public DAO_Section_Test(DBQuery source) {
        _result = new ArrayList<ArrayList<String>>();
        _section = new Section(source);
        _counter = 1;
        
        //Section Test 1
        display(_section.getSectionInfo(_result));
        
        //Section Test 2
        display(_section.getSectionInfo(_result, "PSY100", "A", "201305"));
        
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