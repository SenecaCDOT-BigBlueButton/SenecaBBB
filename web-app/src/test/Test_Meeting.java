package test;

import sql.*;

import db.DBAccess;

public class Test_Meeting extends Test_Helper {
    static Meeting _meeting = null;

    public Test_Meeting(DBAccess source) {
        super();
        _meeting = new Meeting(source);
        _test = _meeting;
        _counter = 1;
        
        display(_meeting.getMeetingInfo(_result));
        
        display(_meeting.getMeetingInfo(_result, "1", "1"));
        
    }
}