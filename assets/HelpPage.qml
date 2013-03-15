import bb.cascades 1.0
import bb 1.0

BasePage
{
    attachedObjects: [
        ApplicationInfo {
            id: appInfo
        },

        PackageInfo {
            id: packageInfo
        }
    ]

    contentContainer: Container
    {
        topPadding: 20; leftPadding: 20; rightPadding: 20;

        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Fill

        ScrollView {
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Fill

            Label {
                multiline: true
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                textStyle.textAlign: TextAlign.Center
                textStyle.fontSize: FontSize.Small
                textStyle.color: Color.White
                content.flags: TextContentFlag.ActiveText
                text: qsTr("(c) 2013 %1. All Rights Reserved.\n%2 %3\n\nPlease report all bugs to:\nsupport@canadainc.org\n\nThe intent of this application is for businesses that need to record their calls for documentation purposes. To successfully record record a phone call, follow these steps:\n\n1) Start a phone call.\n2) Put the call in speakerphone.\n3) Press the Record button.\n4) When the call is complete, and you want to stop recording, press the Stop button.\n5) The recorded conversation should show in the list below. The recorded call can also now be accessed from the native Music app and file manager for further organization. If a DropBox or Box cloud storage is set up on the device, the user can just as easily directly save the recordings to the cloud storage. The location to save the files can be set from the Settings page (swipe-down from the top-bezel and choose Settings).\n\nYou can also start this app while a call is already in progress, put the phone in speaker and press the record button and that should work as well.\n\n").arg(packageInfo.author).arg(appInfo.title).arg(appInfo.version)
            }
        }
    }
}