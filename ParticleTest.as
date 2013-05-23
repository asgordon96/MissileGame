package {
    import flash.display.Sprite;
    import flash.display.Graphics;
    import flash.display.Bitmap;
	import flash.display.BitmapData;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.text.TextField;
    import Particle;
    import ParticleSystem;
	import Helicopter;
    
	// [SWF(backgroundColor="0xAADCFF")]
    public class ParticleTest extends Sprite {
        [Embed(source="./resources/bigMissileNew.png")] // load the big missile image
        public var bigMissileImage:Class;
		
		[Embed(source="./resources/cloud.png")]
		public var cloud:Class;
        
		[Embed(source="./resources/new_tree.png")]
		public var tree:Class;
		
        public var engine1:ParticleSystem;
        public var engine2:ParticleSystem;
        public var big_bitmap:Bitmap;
        public var dt:Number;
        public var update_timer:Timer;
		public var heli:Helicopter;
		public var heli2:Helicopter;
		public var a_cloud:Bitmap;
		
		public var drawer:Sprite;
		public var background_drawer:Sprite;
		
		public var explosion:ParticleSystem;
		
        public var debug:TextField = new TextField();
        public var count:int = 0;
		public var index:int = 0;
        
        public function ParticleTest() {
			drawer = new Sprite();
			addChild(drawer);
			
			background_drawer = new Sprite();
			addChildAt(background_drawer, 0);
			background_drawer.graphics.beginFill(0xAADCFF, 1.0);
			background_drawer.graphics.drawRect(0, 0, 600, 400);
			background_drawer.graphics.endFill();
						
			a_cloud = new cloud() as Bitmap;
			a_cloud.x = 300;
			a_cloud.y = 100;
			addChild(a_cloud);
			
			var a_tree:Bitmap = new tree() as Bitmap;
			a_tree.x = 100;
			a_tree.y = 200;
			addChild(a_tree);
			
			heli = new Helicopter(200, 200, -50);
			heli.heli.scaleX = 1;
			heli.shake(0.3);
			addChild(heli);
			
            big_bitmap = new bigMissileImage() as Bitmap;
            big_bitmap.x = 0;
            big_bitmap.y = 0;
            big_bitmap.scaleX = 0.5;
            big_bitmap.scaleY = 0.5;
            addChild(big_bitmap);
            
            var x1:Number = big_bitmap.x - big_bitmap.height * Math.sin(Math.PI * 2.85 / 4);
            var y1:Number = big_bitmap.y +  big_bitmap.height * Math.cos(Math.PI * 2.85 / 4);
            
            var x2:Number = big_bitmap.x - big_bitmap.height * Math.sin(Math.PI * 2.65 / 4);
            var y2:Number = big_bitmap.y + big_bitmap.height * Math.cos(Math.PI * 2.65 / 4);
            
            // red yellow and orange
            var c:Array = new Array(0xFF0000, 0xFFFF00, 0xFF7900, 0xCE2029, 0xFFA500, 0xFFD700); 
            
            engine1 = new ParticleSystem(drawer.graphics, x1, y1, -50, 5, 1, c, 20, 70);
            engine1.life_min = 0.1;
            engine1.life_max = 0.4;
            
            engine2 = new ParticleSystem(drawer.graphics, x2, y2, -50, 5, 1, c, 20, 70);
            engine2.life_min = 0.1;
            engine2.life_max = 0.4;
            
			explosion = new ParticleSystem(drawer.graphics, 300, 100, 100, 25, 1, c, 0, 360);
			explosion.time = 0.4;
			explosion.life_min = 0.6;
			explosion.life_max = 0.8;
			explosion.rate_dec = 0.95;
			
            addChild(debug);
            
            dt = 1 / 30;
            update_timer = new Timer(dt * 1000);
            update_timer.addEventListener(TimerEvent.TIMER, update);

            update_timer.start();
        }
        
        public function update(evt:TimerEvent):void {
			drawer.graphics.clear();
			var w:Number = heli.heli.width;
			var h:Number = heli.heli.height;
			
			drawer.graphics.beginFill(0x0000FF, 1.0);
			drawer.graphics.drawRect(300, 100, 100, 100);
			drawer.graphics.endFill();
			setChildIndex(drawer, this.numChildren - 1);
			
            engine1.update(dt);
            engine2.update(dt);
			explosion.update(dt);
			
			heli.update(dt);
            
            engine1.x_start += 100 * Math.cos(Math.PI / 4) * dt;
            engine1.y_start += 100 * Math.sin(Math.PI / 4) * dt;
            
            engine2.x_start += 100 * Math.cos(Math.PI / 4) * dt;
            engine2.y_start += 100 * Math.sin(Math.PI / 4) * dt;
            
            big_bitmap.x += 100 * Math.cos(Math.PI / 4) * dt;
            big_bitmap.y += 100 * Math.sin(Math.PI / 4) * dt;
            big_bitmap.rotation = 135;
        }
    }
}