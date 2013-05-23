package {
	// The Class for the Helicopter enemy
    import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.setTimeout;
	
	public class Helicopter extends Sprite {
		// Load the 3 images for the helicopter animation
		[Embed(source="./resources/Helicopter.png")]
		public var helicopter:Class;
		
		[Embed(source="./resources/Helicopter2.png")]
		public var helicopter2:Class;
		
		[Embed(source="./resources/Helicopter3.png")]
		public var helicopter3:Class;
		
		public var frames:Vector.<BitmapData>;
		public var count:int = 0;
		public var index:int = 0;
		
		public var heli:Bitmap;
		public var velocity:Number;
		public var isShaking:Boolean;
		
		public var health:Number = 3;
		
		public function Helicopter(x:Number, y:Number, v:Number) {
			var heli_frame1:Bitmap = new helicopter() as Bitmap;
			var heli_frame2:Bitmap = new helicopter2() as Bitmap;
			var heli_frame3:Bitmap = new helicopter3() as Bitmap;
			frames = new Vector.<BitmapData>();
			frames.push(heli_frame1.bitmapData);
			frames.push(heli_frame2.bitmapData);
			frames.push(heli_frame3.bitmapData);
			heli = new Bitmap(heli_frame1.bitmapData);
			addChild(heli);
			heli.x = x;
			heli.y = y;
			velocity = v;
			isShaking = false;
		}
		
		
		public function update(dt:Number):void {
		    if (count % 3 == 0) {
				heli.bitmapData = frames[index % 3];
				index += 1;
			}
			
			heli.x += dt * velocity;
			count += 1;
			
			if (isShaking) {
				var n:Number = Math.sin(2 * count);
				heli.rotation = n * 3;
			}
		}
		
		public function in_screen():Boolean {
			if (scaleX == 1) {
				if (heli.x + heli.width < 0) {
					return false;
				}
			}
			else {
				if (-heli.x - heli.width > 600) {
					return false;
				}
			}
			return true;
		}
		
		public function shake(time:Number):void {
			isShaking = true;
			setTimeout(stop_shake, 1000 * time);
			
		}
		
		public function stop_shake():void {
			isShaking = false;
			heli.rotation = 0;
		}
	}
}