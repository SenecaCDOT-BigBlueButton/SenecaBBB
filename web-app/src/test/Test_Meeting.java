package test;

import sql.*;

import db.DBAccess;

public class Test_Meeting extends Test_Helper {
    static Meeting _meeting = null;
    /**
     * _group[0]: regular queries only
     * _group[1]: update then query
     * _group[2]: set and get settings
     * _group[3]: 'is' testing for existence
     * _group[4]: create or remove rows
     */
    static int[] _group = {1, 0, 0, 0, 0};

    public Test_Meeting(DBAccess source) {
        super();
        _meeting = new Meeting(source);
        _test = _meeting;
        _counter = 1;
        
        if(_group[0] == 1) {
        
            display(_meeting.getMeetingInfo(_result));
        
            display(_meeting.getMeetingInfo(_result, 1, 1));
            
            display(_meeting.getMeetingDescription(_result, 1, 1));
            
            display(_meeting.getMeetingInitialDatetime(_result, 1, 1));
            
            display(_meeting.getMeetingDuration(_result, 1, 1));
            
            display(_meeting.getMeetingModPass(_result, 1, 1));
            
            display(_meeting.getMeetingUserPass(_result, 1, 1));
            
            _meeting.resetFlag();
            
            display(_meeting.getIsMeetingCancelled(_result, 1, 1));
            
            display(_meeting.gettest(_result));
        }
        
    }
}