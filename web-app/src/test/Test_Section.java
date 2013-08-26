package test;

import sql.*;

import db.DBAccess;

public class Test_Section extends Test_Helper {
    static Section _section = null;

    public Test_Section(DBAccess source) {
        super();
        _section = new Section(source);
        _test = _section;
        _counter = 1;
        
        _section.resetErrorFlag();
        
        display(_section.getSectionInfo(_result));
        
        display(_section.getSectionInfo(_result, "PSY100", "A", "201305"));
        
        display(_section.getSectionInfo(_result, "PSY100", "201305"));
        
        display(_section.getCourse(_result));
        
        display(_section.getProfessor(_result));

        display(_section.getProfessor(_result, "PSY100", "A", "201305"));
        
        display(_section.getStudent(_result));
        
        display(_section.getStudent(_result, "OOP344", "A", "201305"));
        
        //display(_section.createCourse("AAA", "guess"));
        
        //display(_section.createSection("AAA", "Z", "12345", "ICT"));
        
        //display(_section.createProfessor("bo.li", "???", "Z", "12345"));
        
        //display(_section.createStudent("bli64", "???", "Z", "12345", true));
        
        //display(_section.removeSection("AAA", "Z", "12345"));
        
        //display(_section.removeCourse("AAA"));
        
        //display(_section.removeStudent("bli64", "???", "Z", "12345"));
        
        //display(_section.removeProfessor("bo.li", "???", "Z", "12345"));
        
        display(_section.setBannedFromSection("rwstanica", "OOP344", "B", "201305", true));
        
        display(_section.setCourseName("OOP344", "test"));
        
        display(_section.setCourseId("IPC144", "ABC"));
        
    }
}