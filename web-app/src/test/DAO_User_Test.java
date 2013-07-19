package test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import db.DBAccess;
import dao.*;
import references.settings;

public class DAO_User_Test {
    static ArrayList<ArrayList<String>> _result = null;
    static HashMap<String, Integer> _hm = null;
    static User _user = null;
    static int _counter;
    static int[] _group = {0, 0, 1, 0, 0};
    static HashMap<String, Integer> _bu_map;
    static HashMap<String, Integer> _meeting_map;
    static HashMap<String, Integer> _section_map;

    public DAO_User_Test(DBAccess source) {
        _user = new User(source);
        _result = new ArrayList<ArrayList<String>>();
        _hm = new HashMap<String, Integer>();
        _counter = 1;
        
        _bu_map = new HashMap<String, Integer>();
        _bu_map.put(settings.bu_setting[0], 1);
        _bu_map.put(settings.bu_setting[1], 1);
        _bu_map.put(settings.bu_setting[2], 1);
        
        _meeting_map = new HashMap<String, Integer>();
        _meeting_map.put(settings.meeting_setting[0], 1);
        _meeting_map.put(settings.meeting_setting[1], 1);
        _meeting_map.put(settings.meeting_setting[2], 1);
        _meeting_map.put(settings.meeting_setting[3], 1);
        _meeting_map.put(settings.meeting_setting[4], 5);
        
        _section_map = new HashMap<String, Integer>();
        _section_map.put(settings.section_setting[0], 1);
        _section_map.put(settings.section_setting[1], 0);
        _section_map.put(settings.section_setting[2], 1);
        _section_map.put(settings.section_setting[3], 1);
        _section_map.put(settings.section_setting[4], 3);
             
        if (_group[0] == 1) {
            
            display(_user.getUserInfo(_result));

            display(_user.getUserInfo(_result, "bli64"));

            display(_user.getUserInfo(_result, 1, 5));

            display(_user.getUserInfo(_result, 2, 5));

            display(_user.getSaltAndHash(_result, "non_ldap5"));

            display(_user.getSalt(_result, "non_ldap1"));

            display(_user.getHash(_result, "non_ldap4"));

            display(_user.getName(_result, "non_ldap1"));

            display(_user.getLastName(_result, "non_ldap1"));

            display(_user.getNickName(_result, "bo.li"));

            display(_user.getRoleInfo(_result, "bo.li"));

            display(_user.getDepartment(_result, "bli64"));

            display(_user.isActive(_result, "bli64"));

            display(_user.isBannedFromSection(_result, "bli64", "OOP344", "A", "201305"));

            display(_user.isBannedFromSystem(_result, "bli64"));

            display(_user.getComment(_result, "bli64"));

            display(_user.isDepartmentAdmin(_result, "fardad.soleimanloo", "ICT"));

            display(_user.isSuperAdmin(_result, "fardad.soleimanloo"));
        }
        
        if (_group[1] == 1) {

            display(_user.setName("non_ldap1", "Wing"));

            display(_user.setLastName("non_ldap1", "Chen"));

            display(_user.setNickName("non_ldap1", "New"));

            display(_user.setRoleName("employee", "Emp"));

            display(_user.setSalt("non_ldap1", "newsalt"));

            display(_user.setHash("non_ldap4", "new hash"));

            display(_user.getUserInfo(_result));

            display(_user.setRoleName("Emp", "employee"));
        }
        
        if (_group[2] == 1) {
            
            display(_user.getUserSetting(_hm, "bli64"));

            display(_user.getUserMeetingSetting(_hm, "bli64"));
            
            display(_user.getUserMeetingSetting(_hm, "bo.li"));

            display(_user.getSectionSetting(_hm, "bo.li", "INT222", "A", "201305"));

            display(_user.getSectionSetting(_hm, "fardad.soleimanloo", "OOP344", "B", "201305"));
            
            display(_user.setUserSetting(_bu_map, "bli64"));
            
            display(_user.getUserSetting(_hm, "bli64"));
            
            display(_user.setUserMeetingSetting(_meeting_map, "bli64"));
            
            display(_user.getUserMeetingSetting(_hm, "bli64"));
            
            display(_user.setSectionSetting(_section_map, "bo.li", "INT222", "A", "201305"));
            
            display(_user.getSectionSetting(_hm, "bo.li", "INT222", "A", "201305"));
            
            display(_user.defaultUserSetting("bli64"));
            
            display(_user.getUserSetting(_hm, "bli64"));
        }
        
    }
    
    public static void display (boolean flag) {
        System.out.println("+++ User Test " + _counter + ": " + _user.getSQL());
        _counter++;
        if (flag) {
            if (_user.getSQL().substring(0, 6).equals("SELECT")) {
                if(!_result.isEmpty()) {
                    printData(_result);
                }
                else {
                    printData(_hm);
                }
            }
        }
        else {
            System.out.println(_user.getErrLog() + "\n");
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