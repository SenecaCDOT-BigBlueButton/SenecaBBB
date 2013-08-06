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
        
        _meeting.resetErrorFlag();

        display(_meeting.getMeetingInfo(_result, 1, 1));

        display(_meeting.getMeetingDescription(_result, 1, 1));

        display(_meeting.getMeetingInitialDatetime(_result, 1, 1));

        display(_meeting.getMeetingDuration(_result, 1, 1));

        display(_meeting.getMeetingModPass(_result, 1, 1));

        display(_meeting.getMeetingUserPass(_result, 1, 1));

        display(_meeting.getIsMeetingCancelled(_result, 1, 1));
        
        display(_meeting.getMeetingPresentation(_result, 1, 1));
        
        display(_meeting.getMeetingAttendee(_result, 1));
        
        display(_meeting.getMeetingAttendance(_result, 1, 1));
        
        display(_meeting.getMeetingSetting(_hm, 1, 1));
        
        display(_meeting.getMeetingSetting(_hm, 1, 2));
        
        display(_meeting.updateMeetingDuration(2, 1, 8, 150));
        
        display(_meeting.updateMeetingTime(2, 1, 8, "05:05:05"));
        
        display(_meeting.updateMeetingRepeats(1, 15));
        
        display(_meeting.getMeetingInfo(_result, 1));
        
        display(_meeting.updateMeetingRepeats(1, 8));
        
        display(_meeting.getMeetingInfo(_result, 1));
        
        display(_meeting.updateMeetingRepeats(1, 2));
        
        display(_meeting.getMeetingInfo(_result, 1));

    }
}