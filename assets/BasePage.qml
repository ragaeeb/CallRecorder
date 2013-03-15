import bb.cascades 1.0

Page {
    property alias contentContainer: contentContainer.controls

    Container {
		background: back.imagePaint
		horizontalAlignment: HorizontalAlignment.Fill
		verticalAlignment: VerticalAlignment.Fill
		
	    attachedObjects: [
            ImagePaintDefinition {
                id: back
                imageSource: "asset:///images/background.amd"
                repeatPattern: RepeatPattern.XY
            }
	    ]
        
		Container
		{
		    id: titleBar
		    layout: DockLayout {}
		
		    horizontalAlignment: HorizontalAlignment.Fill
		    verticalAlignment: VerticalAlignment.Top
		    
		    ImageView {
		        imageSource: "asset:///images/title_bg.amd"
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
		        
		        onCreationCompleted:
		        {
		            if ( app.getValueFor("animations") == 1 ) {
		                translate.play()
		            }
		        }
		    }

            Container
            {
		        horizontalAlignment: HorizontalAlignment.Left
		        verticalAlignment: VerticalAlignment.Center
		        leftPadding: 20
                
			    ImageView {
			        imageSource: "asset:///images/logo.png"
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
			        
			        onCreationCompleted:
			        {
			            if ( app.getValueFor("animations") == 1 )
			            {
			                translateFade.play()
			            }
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
            background: titleBar.background
            
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
        }
    }
}