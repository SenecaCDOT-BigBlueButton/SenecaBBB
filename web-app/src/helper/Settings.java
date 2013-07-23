/**
 * Please use the values stored in these arrays when constructing setting HashMaps
 * For example:
 * result.put(settings.meeting_setting[0], "1");
 */
package helper;

public class Settings {

    public static final String[] bu_setting = {"autoShareWebcam", "autoShareAudio", "showLanuageSelector"};
    public static final String[] meeting_setting = {"isRecorded", "isMultiWhiteboard", "isPrivateChatEnabled", "isViewerWebcamEnabled", "layout"};
    public static final String[] section_setting = {"isRecorded", "isMultiWhiteboard", "isPrivateChatEnabled", "isViewerWebcamEnabled", "layout"};
    public static final String[] ur_rolemask = {"guestAccountCreation", "recordableMeetings"};

}
