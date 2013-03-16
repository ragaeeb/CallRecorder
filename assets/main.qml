import bb.cascades 1.0
import bb.multimedia 1.0
import Multimedia 1.0

NavigationPane
{
    id: navigationPane
    
    attachedObjects: [
        ComponentDefinition {
            id: definition
        }
    ]

    Menu.definition: MenuDefinition
    {
        settingsAction: SettingsActionItem
        {
            property Page settingsPage
            
            onTriggered:
            {
                if (!settingsPage) {
                    definition.source = "SettingsPage.qml"
                    settingsPage = definition.createObject()
                }
                
                navigationPane.push(settingsPage);
            }
        }

        helpAction: HelpActionItem
        {
            property Page helpPage
            
            onTriggered:
            {
                if (!helpPage) {
                    definition.source = "HelpPage.qml"
                    helpPage = definition.createObject();
                }

                navigationPane.push(helpPage);
            }
        }
    }

    onPopTransitionEnded: {
        page.destroy();
    }

	BasePage {
	    property bool recording: false
	    
	    onRecordingChanged: {
	        cover.active = recording
	    }
	    
	    onCreationCompleted: {
	        if ( app.getValueFor("autoRecord") == 1 ) {
	            recordButton.clicked()
	        }
	    }
	    
	    shortcuts: [
	        SystemShortcut {
	            type: SystemShortcuts.CreateNew
	            
	            onTriggered: {
	                recordButton.clicked()
	            }
	        }
	    ]
	    
	    id: mainPage
	    contentContainer: Container
	    {
	        topPadding: 20; bottomPadding: 20; rightPadding: 20; leftPadding: 20
	        horizontalAlignment: HorizontalAlignment.Fill
	        
	        Label {
	            text: qsTr("Swipe down from the top-bezel and see the Help section for information on how to use this app.\n\nYou can only record calls in SPEAKERPHONE mode!")
	            textStyle.fontSize: FontSize.XSmall
	            textStyle.textAlign: TextAlign.Center
	            multiline: true
	            horizontalAlignment: HorizontalAlignment.Fill
	            verticalAlignment: VerticalAlignment.Fill
	            
		        animations: [
		            TranslateTransition {
		                id: translateTransition
		                fromX: -1280
		                duration: 1000
		            }
		        ]
                
		        onCreationCompleted:
		        {
		            if ( app.getValueFor("animations") == 1 ) {
    	                translateTransition.play()
		            }
		        }
	        }

	        ImageButton {
	            id: recordButton
	            topMargin: 100
	            defaultImageSource: "asset:///images/button_record.png"
	            pressedImageSource: "asset:///images/button_record_down.png"
	            horizontalAlignment: HorizontalAlignment.Center
	            
	            onClicked: {
	                mainPage.hideTitleBar()
	                
	                if (mainPage.recording) {
	                    var duration = recorder.duration
	                    recorder.reset()
			            defaultImageSource = "asset:///images/button_record.png"
			            pressedImageSource = "asset:///images/button_record_down.png"
			            
			            theDataModel.insert( 0, {'uri': recorder.currentUri, 'title': recorder.currentTrack, 'duration': duration} );
	                } else {
    	                var now = Qt.formatDateTime( new Date(), "MMM d-yyyy h-mm-ss AP" );
    	                var outDir = app.getValueFor("output")
    	                var output = outDir+"/"+now+".m4a"
    	                
    	                recorder.currentTrack = now
    	                recorder.currentUri = output
    	                recorder.outputUrl = output
	                    
	                    recorder.record()
			            defaultImageSource = "asset:///images/button_stop.png"
			            pressedImageSource = "asset:///images/button_stop_down.png"
	                }
	                
	                mainPage.recording = !mainPage.recording
	            }
	            
		        animations: [
		            RotateTransition {
		                id: rotateTransition
		                fromAngleZ: 90
		                toAngleZ: 0
		                duration: 500
		            }
		        ]
                
		        onCreationCompleted:
		        {
		            if ( app.getValueFor("animations") == 1 ) {
    	                rotateTransition.play()
		            }
		        }
            }
            
            Label {
				property string seconds: "00"
				property string hours: ""
				property string minutes: "00"
                
                id: durationLabel
	            textStyle.fontSize: FontSize.Small
	            textStyle.textAlign: TextAlign.Center
	            horizontalAlignment: HorizontalAlignment.Fill
	            text: qsTr("%1%2:%3").arg(hours).arg(minutes).arg(seconds)
	            visible: recorder.mediaState == MediaState.Started
	            
		        animations: [
		            FadeTransition {
		                id: fadeTransition
		                fromOpacity: 0
		                duration: 250
		            }
		        ]
                
		        onVisibleChanged:
		        {
		            if ( visible && app.getValueFor("animations") == 1 ) {
    	                fadeTransition.play()
		            }
		        }
            }
            
            Container {
                id: separator
	            topMargin: 30
                
                horizontalAlignment: HorizontalAlignment.Fill
                preferredHeight: 1
                opacity: 0.5
                background: Color.White
                visible: false
            }
            
            ListView
	        {
	            id: listView
	            
	            dataModel: ArrayDataModel {
	                id: theDataModel
	                
	                onItemAdded: {
	                    separator.visible = true
	                }
	                
	                onItemRemoved: {
	                    separator.visible = theDataModel.size() != 0
	                }
	            }
	            
	            onActivationChanged: {
	                if (active) {
	                    actionSet.activeIndexPath = indexPath
	                }
	            }
	            
	            onTriggered: {
	                app.openRecording( "file://"+theDataModel.data(indexPath).uri )
	            }
	            
	            contextActions: [
	                ActionSet {
        	            property variant activeIndexPath
	                    id: actionSet
	                    title: activeIndexPath ? theDataModel.data(activeIndexPath).title : ""
	                    subtitle: {
	                        if (activeIndexPath)
	                        {
		                        var duration = theDataModel.data(activeIndexPath).duration
								var secs = "%1".arg(Math.floor(duration / 1000) % 60);
								var mins = "%1".arg(Math.floor((duration / (1000 * 60) ) % 60));
								var hrs = Math.floor((duration / (1000 * 60 * 60) ) % 24);
								
								var seconds = secs >= 10 ? "%1".arg(secs) : "0%1".arg(secs)
								var minutes = mins >= 10 ? "%1".arg(mins) : "0%1".arg(mins)
								var hours = hrs > 0 ? "%1:".arg(hrs) : ""
								return hours+minutes+":"+seconds
	                        } else {
	                            return ""
	                        }
	                    }
	                    
	                    DeleteActionItem {
	                        title: qsTr("Delete")
	                        
	                        onTriggered: {
	                            var result = app.deleteRecording( theDataModel.data(actionSet.activeIndexPath).uri )
	                            
	                            if (result) {
	                                theDataModel.removeAt(actionSet.activeIndexPath)
	                            }
	                        }
	                    }
	                }
	            ]
	
	            listItemComponents: [
	                ListItemComponent {
	                    StandardListItem {
	                        title: ListItemData.title
	                        status: {
	                            var duration = ListItemData.duration
								var secs = "%1".arg(Math.floor(duration / 1000) % 60);
								var mins = "%1".arg(Math.floor((duration / (1000 * 60) ) % 60));
								var hrs = Math.floor((duration / (1000 * 60 * 60) ) % 24);
								
								var seconds = secs >= 10 ? "%1".arg(secs) : "0%1".arg(secs)
								var minutes = mins >= 10 ? "%1".arg(mins) : "0%1".arg(mins)
								var hours = hrs > 0 ? "%1:".arg(hrs) : ""
								return hours+minutes+":"+seconds
	                        }
	                    }
	                }
	            ]
	            
	            horizontalAlignment: HorizontalAlignment.Fill
	            verticalAlignment: VerticalAlignment.Fill
	        }
	        
	        attachedObjects: [
				AudioRecorder
				{
				    property string currentTrack
				    property string currentUri
				    
					id: recorder
					onDurationChanged: {
						var secs = "%1".arg(Math.floor(duration / 1000) % 60);
						var mins = "%1".arg(Math.floor((duration / (1000 * 60) ) % 60));
						var hrs = Math.floor((duration / (1000 * 60 * 60) ) % 24);
						
						durationLabel.seconds = secs >= 10 ? "%1".arg(secs) : "0%1".arg(secs)
						durationLabel.minutes = mins >= 10 ? "%1".arg(mins) : "0%1".arg(mins)
						durationLabel.hours = hrs > 0 ? "%1:".arg(hrs) : ""
					}
					
					onError: {
					    mainPage.recording = false;
					}
				}
            ]
		}
	}
}