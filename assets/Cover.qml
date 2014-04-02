import bb.cascades 1.0

Container
{
    attachedObjects: [
        ImagePaintDefinition {
            id: back
            imageSource: "images/cover_bg.png"
        }
    ]
    
    background: back.imagePaint
    topPadding: 20; leftPadding: 20; rightPadding: 20
    
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Center
    
    ImageView {
        imageSource: "images/logo.png"
        topMargin: 0
        leftMargin: 0
        rightMargin: 0
        bottomMargin: 0

        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
    }
    
    Label {
        text: recorder.recording ? qsTr("Recording...") : qsTr("Idle")
        horizontalAlignment: HorizontalAlignment.Fill
        textStyle.textAlign: TextAlign.Center
        textStyle.base: SystemDefaults.TextStyles.SubtitleText
    }
}