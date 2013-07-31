import bb.cascades 1.0
import CustomComponent 1.0

BasePage
{
    contentContainer: ScrollView
    {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
	    Container
	    {
	        leftPadding: 20
	        rightPadding: 20
	        bottomPadding: 20
	        horizontalAlignment: HorizontalAlignment.Fill
	        verticalAlignment: VerticalAlignment.Fill
	        
	        Container
	        {
			    attachedObjects: [
					FilePicker {
					    id: filePicker
					    type : FileType.Music
					    title : qsTr("Select Folder") + Retranslate.onLanguageChanged
					    mode: FilePickerMode.SaverMultiple
					    onFileSelected : {
					        var result = selectedFiles[0]
							outputLabel.outputDirectory = result
							persist.saveValueFor("output", result)
			            }
					}
			    ]
	            
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
			            var outDir = persist.getValueFor("output")
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
	
	        PersistDropDown {
	            title: qsTr("Auto-Record") + Retranslate.onLanguageChanged
	            horizontalAlignment: HorizontalAlignment.Fill
	            key: "autoRecord"
	
	            Option {
	                text: qsTr("Off") + Retranslate.onLanguageChanged
	                description: qsTr("No automatic recording.") + Retranslate.onLanguageChanged
	                imageSource: "images/ic_mobile.png"
	                value: 0
	            }
	
	            Option {
	                text: qsTr("On App Start") + Retranslate.onLanguageChanged
	                description: qsTr("Recording will begin as soon as the app is loaded.") + Retranslate.onLanguageChanged
	                imageSource: "images/ic_app_start.png"
	                value: 1
	            }
	
	            Option {
	                text: qsTr("On Call Connected") + Retranslate.onLanguageChanged
	                description: qsTr("Recording will begin as soon as the call is connected.") + Retranslate.onLanguageChanged
	                imageSource: "images/ic_call_connected.png"
	                value: 2
	            }
	
	            onSelectedIndexChanged: {
	                if (selectedIndex == 0) {
	                    infoText.text = qsTr("Recording will begin once the user taps the record button.");
	                } else if (selectedIndex == 1) {
	                    infoText.text = qsTr("Recording will begin once the app starts.");
	                } else if (selectedIndex == 2) {
	                    infoText.text = qsTr("Recording will begin once the call is connected.");
	                }
	            }
	        }
	        
	        SettingPair {
	            topPadding: 20
	            title: qsTr("Auto-End on Disconnect")
	            key: "autoEnd"
	    
	            toggle.onCheckedChanged: {
	        		if (checked) {
	        		    infoText.text = qsTr("Recording will end as soon as the call is disconnected.")
	        		} else {
	        		    infoText.text = qsTr("Recording will end once the user taps the stop button.")
	        		}
	            }
	        }
	        
	        SettingPair {
	            topPadding: 20
	            title: qsTr("Reject if < 10 seconds")
	            key: "rejectShort"
	            bottomPadding: 40
	    
	            toggle.onCheckedChanged: {
	        		if (checked) {
	        		    infoText.text = qsTr("Recordings less than 10 seconds in duration will be immediately deleted.")
	        		} else {
	        		    infoText.text = qsTr("Recordings less than 10 seconds in duration will be allowed.")
	        		}
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
    }
}