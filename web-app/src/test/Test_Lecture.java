package test;

import sql.*;

import db.DBAccess;

public class Test_Lecture extends Test_Helper {
    static Lecture _lecture = null;
    
    public Test_Lecture(DBAccess source) {
        super();
        _lecture = new Lecture(source);
        _test = _lecture;
        _counter = 1;
        
        display(_lecture.getLectureInfo(_result));
        
        display(_lecture.getLectureInfo(_result, "1", "1"));
        
    }
}