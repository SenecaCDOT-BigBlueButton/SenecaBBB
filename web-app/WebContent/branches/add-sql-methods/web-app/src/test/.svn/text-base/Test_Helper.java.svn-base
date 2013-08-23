package test;


import helper.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import sql.*;

public class Test_Helper {
    static ArrayList<ArrayList<String>> _result = null;
    static HashMap<String, Integer> _hm = null;
    static Sql _test = null;
    static int _counter;
    static HashMap<String, Integer> _bu_map;
    static HashMap<String, Integer> _meeting_map;
    static HashMap<String, Integer> _section_map;
    static HashMap<String, Integer> _role_map;
    static MyBoolean _bool = null;

    public Test_Helper() {
        _result = new ArrayList<ArrayList<String>>();
        _hm = new HashMap<String, Integer>();
        _bool = new MyBoolean();

        _bu_map = new HashMap<String, Integer>();
        _bu_map.put(Settings.bu_setting[0], 1);
        _bu_map.put(Settings.bu_setting[1], 1);
        _bu_map.put(Settings.bu_setting[2], 1);

        _meeting_map = new HashMap<String, Integer>();
        _meeting_map.put(Settings.meeting_setting[0], 1);
        _meeting_map.put(Settings.meeting_setting[1], 1);
        _meeting_map.put(Settings.meeting_setting[2], 1);
        _meeting_map.put(Settings.meeting_setting[3], 1);
        _meeting_map.put(Settings.meeting_setting[4], 5);

        _section_map = new HashMap<String, Integer>();
        _section_map.put(Settings.section_setting[0], 1);
        _section_map.put(Settings.section_setting[1], 0);
        _section_map.put(Settings.section_setting[2], 1);
        _section_map.put(Settings.section_setting[3], 1);
        _section_map.put(Settings.section_setting[4], 3);

        _role_map = new HashMap<String, Integer>();
        _role_map.put(Settings.ur_rolemask[0], 1);
        _role_map.put(Settings.ur_rolemask[1], 0);  
    }

    public static void display (boolean flag) {
        System.out.println("+++ Test " + _counter + ": " + _test.getSQL());
        _counter++;
        if (flag) {
            if (_test.getSQL().substring(0, 8).equals("SELECT 1")) {
                System.out.println(_bool.get_value());
            }
            else if (_test.getSQL().substring(0, 6).equals("SELECT")) {
                if(!_result.isEmpty()) {
                    printData(_result);
                }
                else {
                    printData(_hm);
                }
            }
        }
        else {
            System.out.println(_test.getErrLog() + "\n");
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
        result.clear();
    }

    public static void printData(HashMap<String, Integer> result) {
        Iterator<String> iter = result.keySet().iterator();
        while (iter.hasNext()) {
            String key = iter.next();
            Integer val = result.get(key);
            System.out.println(key + ": " + val);
        }
        result.clear();
    }

}