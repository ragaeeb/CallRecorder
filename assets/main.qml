import bb.cascades 1.0
import bb.multimedia 1.0
import bb.system 1.0
import com.canadainc.data 1.0

NavigationPane
{
    id: navigationPane

    Menu.definition: CanadaIncMenu
    {
        id: menuDef
        bbWorldID: "24152879"
        projectName: "call-recorder10"
        promoteChannel: true
    }

    onPopTransitionEnded: {
        page.destroy();
    }

	BasePage
	{
        id: mainPage
	    property bool recording: false
	    
	    onRecordingChanged: {
	        cover.active = recording
	    }
	    
	    onCreationCompleted: {
	        if ( persist.getValueFor("autoRecord") == 1 ) {
	            recordButton.clicked()
	        }
	    }
	    
	    contentContainer: Container
	    {
	        topPadding: 20; rightPadding: 20; leftPadding: 20
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
                
		        onCreationCompleted: {
                    translateTransition.play();
		        }
	        }

	        ImageButton {
	            id: recordButton
	            topMargin: 100
	            defaultImageSource: "images/button_record.png"
	            pressedImageSource: "images/button_record_down.png"
	            horizontalAlignment: HorizontalAlignment.Center
	            
	            onClicked: {
	                mainPage.hideTitleBar();
	                
	                if (mainPage.recording) {
	                    var duration = recorder.duration;
	                    recorder.reset();
			            defaultImageSource = "images/button_record.png"
			            pressedImageSource = "images/button_record_down.png"
			            
			            app.addRecording(recorder.currentUri, duration);
			            
                        mainPage.recording = !mainPage.recording;
	                } else {
    	                var now = Qt.formatDateTime( new Date(), "MMM d-yyyy h-mm-ss AP" );
    	                var outDir = persist.getValueFor("output");
    	                var output = outDir+"/"+now+".m4a";

    	                recorder.currentUri = output
	                    
	                    var ok = recorder.record();
	                    
	                    if (ok) {
                            defaultImageSource = "images/button_stop.png"
                            pressedImageSource = "images/button_stop_down.png"
                            mainPage.recording = !mainPage.recording;
	                    } else {
	                        persist.showBlockingToast( qsTr("Cannot record due to an error. This usually indicates that either the app does not have the permissions it needs to record, or the output directory is not set up properly!"), qsTr("OK") );
	                    }
	                }
	            }
	            
		        animations: [
		            RotateTransition {
		                id: rotateTransition
		                fromAngleZ: 90
		                toAngleZ: 0
		                duration: 500
		            }
		        ]
                
		        onCreationCompleted: {
                    rotateTransition.play();
		        }
            }
            
            Label {
                id: durationLabel
	            textStyle.fontSize: FontSize.Small
	            textStyle.textAlign: TextAlign.Center
	            horizontalAlignment: HorizontalAlignment.Fill
                visible: recorder.recording
	            
		        animations: [
		            FadeTransition {
		                id: fadeTransition
		                fromOpacity: 0
		                duration: 250
		            }
		        ]
                
		        onVisibleChanged: {
                    fadeTransition.play();
		        }
            }
            
            ControlDelegate
            {
                id: listDelegate
                delegateActive: app.numRecordings > 0
                
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                
                sourceComponent: ComponentDefinition
                {
                    Container {
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill
                        
                        Divider {
                            id: separator
                            topMargin: 30; bottomMargin: 0
                            visible: app.numRecordings != 0
                        }
                        
                        ListView
                        {
                            id: listView
                            horizontalAlignment: HorizontalAlignment.Fill
                            verticalAlignment: VerticalAlignment.Fill
                            
                            attachedObjects:
                            [
                                SystemPrompt {
                                    property string originalName
                                    property int index
                                    property variant activeElement
                                    
                                    id: renameDialog
                                    title: qsTr("New name") + Retranslate.onLanguageChanged
                                    body: qsTr("Enter the name of the new file.") + Retranslate.onLanguageChanged
                                    confirmButton.label: qsTr("Rename") + Retranslate.onLanguageChanged
                                    confirmButton.enabled: inputFieldTextEntry().length > 0
                                    cancelButton.label: qsTr("Cancel") + Retranslate.onLanguageChanged
                                    inputField.defaultText: originalName
                                    inputField.emptyText: qsTr("New name") + Retranslate.onLanguageChanged
                                    
                                    onFinished: {
                                        if (result == SystemUiResult.ConfirmButtonSelection) {
                                            app.renameRecording( index, inputFieldTextEntry() )
                                        }
                                    }
                                },
                                
                                TextUtils {
                                    id: textUtil
                                }
                            ]
                            
                            function deleteRecording(index) {
                                app.deleteRecording(index)
                            }
                            
                            function renameRecording(ListItemData, index) {
                                renameDialog.originalName = ListItemData.title
                                renameDialog.index = index[0]
                                renameDialog.show()
                            }
                            
                            dataModel: app.getDataModel()
                            
                            onTriggered: {
                                app.openRecording(indexPath)
                            }
                            
                            listItemComponents: [
                                ListItemComponent
                                {
                                    StandardListItem
                                    {
                                        id: rootItem
                                        
                                        title: ListItemData.title
                                        imageSource: "images/ic_recording.png"
                                        status: ListItem.view.textUtil.formatTime(ListItemData.duration)
                                        
                                        contextActions: [
                                            ActionSet {
                                                title: rootItem.title
                                                subtitle: rootItem.status
                                                
                                                ActionItem {
                                                    title: qsTr("Rename") + Retranslate.onLanguageChanged
                                                    imageSource: "images/ic_rename.png"
                                                    
                                                    onTriggered: {
                                                        rootItem.ListItem.view.renameRecording(ListItemData, rootItem.ListItem.indexPath)
                                                    }
                                                }
                                                
                                                DeleteActionItem {
                                                    title: qsTr("Delete") + Retranslate.onLanguageChanged
                                                    imageSource: "images/menu/ic_delete.png"
                                                    
                                                    onTriggered: {
                                                        rootItem.ListItem.view.deleteRecording(rootItem.ListItem.indexPath)
                                                    }
                                                }
                                            }
                                        ]
                                    }
                                }
                            ]
                        }
                    }
                }
            }
	        
	        attachedObjects: [
				LazyAudioRecorder
				{
                    id: recorder
					
					onErrorDetected: {
					    mainPage.recording = false;
                        persist.showBlockingToast( "Error encountered...", qsTr("OK") );
					}
					
					onDurationChanged: {
                        durationLabel.text = textUtil.formatTime(recorder.duration);
					}
				},
				
				PhoneService {
				    onConnectedStateChanged: {
				        if (connected && persist.getValueFor("autoRecord") == 2 && !mainPage.recording) {
				            recordButton.clicked();
				        } else if (!connected && persist.getValueFor("autoEnd") == 1 && mainPage.recording) {
				            recordButton.clicked();
				        }
				    }
				}
            ]
		}
	}
	
	onCreationCompleted: {
	    if ( !persist.contains("hideAgreement") ) {
            persist.showToast( qsTr("Warning: Recording phone calls may not be permitted under local law. You should confirm that this is permitted before continuing."), qsTr("OK"), "asset:///images/toast/warning.png" );
	        persist.saveValueFor("hideAgreement", 1);
	    }
	}
}