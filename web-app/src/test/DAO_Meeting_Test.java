package test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import dao.*;
import db.DBAccess;

public class DAO_Meeting_Test {
    static ArrayList<ArrayList<String>> _result = null;
    static HashMap<String, Integer> _hm = null;
    static Meeting _meeting = null;
    static int _counter;

    public DAO_Meeting_Test(DBAccess source) {
        _result = new ArrayList<ArrayList<String>>();
        _hm = new HashMap<String, Integer>();
        _meeting = new Meeting(source);
        _counter = 1;
        
        display(_meeting.getMeetingInfo(_result));
        
        display(_meeting.getMeetingInfo(_result, "1", "1"));
        
    }
    
    public static void display (boolean flag) {
        System.out.println("+++ Meeting Test " + _counter + ": " + _meeting.getSQL());
        _counter++;
        if (flag) {
            if (_meeting.getSQL().substring(0, 6).equals("SELECT")) {
                if(!_result.isEmpty()) {
                    printData(_result);
                }
                else {
                    printData(_hm);
                }
            }
        }
        else {
            System.out.println(_meeting.getErrLog() + "\n");
        }
        System.out.println();
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