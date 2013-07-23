package test;

import sql.*;

import db.DBAccess;

public class Test_Section extends Test_Helper {
    static Section _section = null;
    static int _counter;

    public Test_Section(DBAccess source) {
        super();
        _section = new Section(source);
        _test = _section;
        _counter = 1;
        
        display(_section.getSectionInfo(_result));
        
        display(_section.getSectionInfo(_result, "PSY100", "A", "201305"));
        
    }
}