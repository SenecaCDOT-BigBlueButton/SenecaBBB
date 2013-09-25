package helper;

/**
 * Every method in class need to done, these are just skeletons
 */
public class Validation {

    static String _errMsg = "";
    
    public static String getErrMsg() {
        return _errMsg;
    }
    
    public static String prepare(String raw) {
        String ret;
        ret = raw.trim();
        return ret;
    }
    
    public static boolean checkEmpty(String target, String fieldName) {
        boolean flag = true;
        if (target.equals("")) {
            flag = false;
            _errMsg = fieldName + " cannot be empty";
        }
        return flag;
    }
    
    public static boolean isNumber(String str, String fieldName) {
        boolean flag = true;
        for(int i=0; i<str.length(); i++) {
            if (flag) {
                flag = (str.charAt(i) >= '0' && str.charAt(i) <= '9');
            }
        }
        if (!flag) {
            _errMsg = fieldName + " must be a positive integer";
        }
        return flag;
    }
    
    public static boolean checkDeptCode(String deptCode) {
        boolean flag = checkEmpty(deptCode, "Department Code");
        return flag;
    }
    
    public static boolean checkDeptName(String deptName) {
        boolean flag = checkEmpty(deptName, "Department Name");
        return flag;
    }
    
    public static boolean checkMId(String m_id) {
        boolean flag = checkEmpty(m_id, "Meeting Id") && isNumber(m_id, "Meeting Id");
        return flag;
    }
    
    public static boolean checkMsId(String ms_id) {
        boolean flag = checkEmpty(ms_id, "Meeting Schedule Id") && isNumber(ms_id, "Meeting Schedule Id");
        return flag;
    }
    
    public static boolean checkLId(String l_id) {
        boolean flag = checkEmpty(l_id, "Lecture Id") && isNumber(l_id, "Lecture Id");
        return flag;
    }
    
    public static boolean checkLsId(String ls_id) {
        boolean flag = checkEmpty(ls_id, "Lecture Schedule Id") && isNumber(ls_id, "Lecture Schedule Id");
        return flag;
    }
}
