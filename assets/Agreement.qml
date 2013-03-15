import bb.cascades 1.0

Sheet
{
    id: root
    
    Page
    {
        titleBar: TitleBar {
            title: qsTr("Agreement") + Retranslate.onLanguageChanged

            acceptAction: ActionItem {
                title: qsTr("Accept") + Retranslate.onLanguageChanged
                
                onTriggered: {
                    if (hideNextTime.checked) {
                        app.saveValueFor("hideAgreement", 1);
                    }
                    
                    root.close();
                }
            }
        }
        
        Container
        {
            layout: DockLayout {}
            
            Label {
                multiline: true
                textStyle.textAlign: TextAlign.Center
                verticalAlignment: VerticalAlignment.Center
                text: qsTr("Warning: Recording phone calls may not be permitted under local law. You should confirm that this is permitted before continuing.") + Retranslate.onLanguageChanged
            }

            CheckBox {
                id: hideNextTime
                text: qsTr("Don't show again")
                verticalAlignment: VerticalAlignment.Bottom
            }
            
            bottomPadding: 30; leftPadding: 20; rightPadding: 20;
        }
    }
}
