import bb.cascades 1.0
import CustomComponent 1.0

BasePage
{
    contentContainer: Container
    {
        leftPadding: 20
        topPadding: 20
        rightPadding: 20
        bottomPadding: 20
        
        Container
        {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            
            Label {
                property string outputDirectory
                
                id: outputLabel
                text: qsTr("Output directory:\n%1").arg(outputDirectory)
                textStyle.fontSize: FontSize.XXSmall
                textStyle.fontStyle: FontStyle.Italic
                multiline: true
                verticalAlignment: VerticalAlignment.Center
                
		        layoutProperties: StackLayoutProperties {
		            spaceQuota: 1
		        }
		        
		        onCreationCompleted: {
		            var outDir = app.getValueFor("output")
		            filePicker.directories = [outDir, "/accounts/1000/shared/voice"]
		            outputDirectory = outDir
		        }
            }
            
            Button {
                text: qsTr("Edit")
                preferredWidth: 200
                
                onClicked: {
                    filePicker.open()
                }
            }
        }
        
        SettingPair {
            topMargin: 20
            title: qsTr("Animations")
        	toggle.checked: app.getValueFor("animations") == 1
    
            toggle.onCheckedChanged: {
        		app.saveValueFor("animations", checked ? 1 : 0)
        		
        		if (checked) {
        		    infoText.text = qsTr("Controls will be animated whenever they are loaded.")
        		} else {
        		    infoText.text = qsTr("Controls will be snapped into position without animations.")
        		}
            }
        }
        
        SettingPair {
            topMargin: 20
            title: qsTr("Auto-Record on Startup?")
        	toggle.checked: app.getValueFor("autoRecord") == 1
    
            toggle.onCheckedChanged: {
        		app.saveValueFor("autoRecord", checked ? 1 : 0)
        		
        		if (checked) {
        		    infoText.text = qsTr("Recording will begin as soon as the app is loaded.")
        		} else {
        		    infoText.text = qsTr("Recording will begin once the user taps the record button.")
        		}
            }
        }
        
        SettingPair {
            topMargin: 20
            title: qsTr("Hide Agreement Dialog")
        	toggle.checked: app.getValueFor("hideAgreement") == 1
    
            toggle.onCheckedChanged: {
        		app.saveValueFor("hideAgreement", checked ? 1 : 0)
        		
        		if (checked) {
        		    infoText.text = qsTr("The legal advice agreement dialog will be hidden on startup.")
        		} else {
        		    infoText.text = qsTr("The legal advice agreement dialog will be displayed on startup.")
        		}
            }
            
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
        }
        
        Label {
            id: infoText
            multiline: true
            textStyle.fontSize: FontSize.XXSmall
            textStyle.textAlign: TextAlign.Center
            verticalAlignment: VerticalAlignment.Bottom
            horizontalAlignment: HorizontalAlignment.Center
        }
    }
    
    attachedObjects: [
		FilePicker {
		    id: filePicker
		    type : FileType.Music
		    title : qsTr("Select Folder") + Retranslate.onLanguageChanged
		    mode: FilePickerMode.SaverMultiple
		    onFileSelected : {
		        var result = selectedFiles[0]
				outputLabel.outputDirectory = result
				app.saveValueFor("output", result)
            }
		}
    ]   
}