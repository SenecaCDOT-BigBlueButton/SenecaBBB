package test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import dao.*;
import db.DBQuery;

public class DAO_Lecture_Test {
    static ArrayList<ArrayList<String>> _result = null;
    static HashMap<String, Integer> _hm = null;
    static Lecture _lecture = null;
    static int _counter;
    
    public DAO_Lecture_Test(DBQuery source) {
        _result = new ArrayList<ArrayList<String>>();
        _hm = new HashMap<String, Integer>();
        _lecture = new Lecture(source);
        _counter = 1;
        
        //Lecture Test 1
        display(_lecture.getLectureInfo(_result));
        
        //Lecture Test 2
        display(_lecture.getLectureInfo(_result, "1", "1"));
        
    }
    
    public static void display (boolean flag) {
        System.out.println("Lecture Test " + _counter + ": " + _lecture.getQuery());
        _counter++;
        if (flag) {
            printData(_result);
        }
        else {
            System.out.println(_lecture.getErrLog() + "\n");
        }
    }
    
    public static void displayMap (boolean flag) {
        System.out.println("User Test " + _counter + ": " + _lecture.getQuery());
        _counter++;
        if (flag) {
            printData(_hm);
        }
        else {
            System.out.println(_lecture.getErrLog() + "\n");
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