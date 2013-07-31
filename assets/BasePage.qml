import bb.cascades 1.0

Page {
    property alias contentContainer: contentContainer.controls
    
    function hideTitleBar() {
        if (titleBar.visible) {
            hider.play()
        }
    }

    Container {
		background: Color.create("#2f5b78")
		horizontalAlignment: HorizontalAlignment.Fill
		verticalAlignment: VerticalAlignment.Fill
        
		Container
		{
		    id: titleBar
		    layout: DockLayout {}
		    
		    animations: [
		        TranslateTransition {
		            id: hider
		            toY: -300
		            
		            onEnded: {
		                titleBar.visible = false
		            }
                }
		    ]
		
		    horizontalAlignment: HorizontalAlignment.Fill
		    verticalAlignment: VerticalAlignment.Top
		    
		    ImageView {
		        imageSource: "images/title_bg.amd"
		        topMargin: 0
		        leftMargin: 0
		        rightMargin: 0
		        bottomMargin: 0
		
		        horizontalAlignment: HorizontalAlignment.Fill
		        verticalAlignment: VerticalAlignment.Fill
		        
		        animations: [
		            TranslateTransition {
		                id: translate
		                toY: 0
		                fromY: -100
		                duration: 1000
		            }
		        ]
		        
		        onCreationCompleted: {
                    translate.play();
		        }
		    }

            Container
            {
		        horizontalAlignment: HorizontalAlignment.Left
		        verticalAlignment: VerticalAlignment.Center
		        leftPadding: 20
                
			    ImageView {
			        imageSource: "images/logo.png"
			        topMargin: 0
			        leftMargin: 0
			        rightMargin: 0
			        bottomMargin: 0
			
			        horizontalAlignment: HorizontalAlignment.Left
			        verticalAlignment: VerticalAlignment.Center
			
			        animations: [
			            ParallelAnimation {
			                id: translateFade
			                
				            FadeTransition {
				                easingCurve: StockCurve.CubicIn
				                fromOpacity: 0
				                toOpacity: 1
				                duration: 1000
				            }
				
				            TranslateTransition {
				                toX: 0
				                fromX: -300
				                duration: 1000
				            }
                        }
			        ]
			        
			        onCreationCompleted: {
                        translateFade.play();
			        }
			    }
            }
		}

        Container // This container is replaced
        {
            layout: DockLayout {
                
            }
            
            id: contentContainer
            objectName: "contentContainer"
            
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
        }
    }
}