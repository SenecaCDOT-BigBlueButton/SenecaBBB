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
        
        _lecture.resetErrorFlag();
        
        display(_lecture.getLectureInfo(_result, 1, 1));
        
        display(_lecture.getLectureInfo(_result, 1));
        
        display(_lecture.getLectureScheduleInfo(_result, 1));
        
        display(_lecture.getLectureScheduleInfo(_result));
        
        display(_lecture.getLectureDescription(_result, 1, 1));
        
        display(_lecture.getLectureInitialDatetime(_result, 1, 1));
        
        display(_lecture.getLectureDuration(_result, 1, 1));
        
        display(_lecture.getIsLectureCancelled(_result, 1, 1));
        
        display(_lecture.getLectureModPass(_result, 1, 1));
        
        display(_lecture.getLectureUserPass(_result, 1, 1));
        
        display(_lecture.getLecturePresentation(_result, 1, 1));
        
        display(_lecture.getLectureAttendance(_result, 1, 1));
        
        display(_lecture.getLectureAttendance(_result, 1, 1, "bli64"));
        
        display(_lecture.getLectureGuest(_result, 1, 1));
        
        display(_lecture.getLectureGuest(_result, 1, 1, "chad.pilkey"));
        
        display(_lecture.setLectureDescription(1, 1, "test"));
        
        display(_lecture.setLectureIsCancel(1, 1, true));
        
        display(_lecture.getLectureInfo(_result, 1, 1));
        
        display(_lecture.setLectureAttendance("bli64", 1, 1, true));
        
        display(_lecture.getLectureAttendance(_result, 1, 1));
       
        display(_lecture.setLectureGuestIsMod("chad.pilkey", 1, 1, false));
        
        display(_lecture.getLectureGuest(_result, 1, 1));
        
        display(_lecture.updateLectureDuration(2, 1, 9, 200));
        
        display(_lecture.updateLectureTime(3, 1, 10, "10:10:10"));
        
        //display(_lecture.createLecturePresentation("testing1", 1, 1));
        
        //display(_lecture.createLecturePresentation("testing2", 1, 1));
        
        //display(_lecture.createLectureGuest("bli64", 1, 1, true));
        
        //display(_lecture.createLectureGuest("bo.li", 1, 1, false));
        
        //display(_lecture.createLectureAttendance("bo.li", 1, 1, true));
        
        //display(_lecture.removeLectureAttendance("bo.li", 1, 1));
        
        //display(_lecture.removeLecturePresentation("testing1", 1, 1));
        
        //display(_lecture.removeLectureGuest("bo.li", 1, 1));
        
        //display(_lecture.createLectureSchedule("PSY150", "A", "201305", "2013-10-01 10:20:30", 7, 10, 50, "PSY150"));
        
        display(_lecture.removeMeetingSchedule(2));
        
        //display(_lecture.removeMeetingSchedule(1));
        
        //display(_lecture.createLectureSchedule("PSY150", "A", "201305", "2013-08-01 10:00:00", "3;1;6;1;0110010", 50, "m_description"));
        
        display(_lecture.editLectureSchedule(10, "2013-10-01 10:00:00", "4;1;5;3;30", "abc"));
    }
}