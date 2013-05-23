// a Preloader for the ActionScript Game
package {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Preloader extends MovieClip {
		
		public var label:TextField = new TextField();
		
		public function Preloader() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			var f:TextFormat = new TextFormat("Arial", 36, 0x000000)
			label.x = 200;
			label.y = 220;
			label.width = 400;
			label.defaultTextFormat = f;
			addChild(label);
		}
		
		public function onEnterFrame(event:Event):void {
			graphics.clear();
			if (framesLoaded == totalFrames) {
				stop();
				removeChild(label);
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				var mainClass:Class = getDefinitionByName("MissileGame") as Class;
				addChild(new mainClass() as DisplayObject)
			}
			else {
				var percent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
				graphics.beginFill(0);
				graphics.drawRect(50, 190, 50 + 450 * percent, 20);
				graphics.endFill();
				label.text = "Loading... " + String(Math.floor(percent * 100)) + "%"
			}
		}
	}
}