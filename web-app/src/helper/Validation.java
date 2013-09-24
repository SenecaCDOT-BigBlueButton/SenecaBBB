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
    
    public static boolean checkEmpty(String target, String methodName, String fieldName) {
        boolean flag = true;
        if (target.equals("")) {
            flag = false;
            _errMsg = methodName + " failed:<br />" +
                    fieldName + " cannot be empty";
        }
        return flag;
    }
    
    public static boolean deptCodeCreate(String deptCode) {
        boolean flag = checkEmpty(deptCode, "Create Department", "Department Code");
        return flag;
    }
    
    public static boolean deptNameCreate(String deptName) {
        boolean flag = checkEmpty(deptName, "Create Department", "Department Name");
        return flag;
    }
    
    public static boolean deptCodeRemove(String deptCode) {
        boolean flag = checkEmpty(deptCode, "Remove Department", "Department Code");
        return flag;
    }

    public static boolean deptCodeMod(String deptCode) {
        boolean flag = checkEmpty(deptCode, "Modify Department", "Department Code");
        return flag;
    }
    
    public static boolean deptNameMod(String deptName) {
        boolean flag = checkEmpty(deptName, "Modify Department", "Department Name");
        return flag;
    }
    
    public static boolean deptCodeOldMod(String deptCode) {
        boolean flag = checkEmpty(deptCode, "Modify Department", "Original Department Code");
        return flag;
    }
}
