// The MissileSprite class will represent 1 missile

package {
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.display.Graphics;
    import ParticleSystem;
    
    public class MissileSprite {
        public var missile_bitmap:Bitmap;
        public var velocity:Number;
        public var isBig:Boolean;
        public var canvas:Graphics;
        public var engine1:ParticleSystem;
        
        public function MissileSprite(g:Graphics, image:Bitmap, v:Number, x:int, y:int, angle:int, big:Boolean=false) {
            canvas = g;
            isBig = big;
            velocity = v;
            missile_bitmap = image;
            missile_bitmap.x = x;
            missile_bitmap.y = y;
            missile_bitmap.rotation = angle
            missile_bitmap.scaleX = 0.5;
            missile_bitmap.scaleY = 0.5;

			
            if (isBig) {
                var x1:Number = missile_bitmap.x - missile_bitmap.height * Math.sin(Math.PI / 195 * angle);
                var y1:Number = missile_bitmap.y + missile_bitmap.height * Math.cos(Math.PI / 195 * angle);
                
                var colors:Array = new Array(0xFF0000, 0xFFFF00, 0xFF7900, 0xCE2029, 0xFFA500, 0xFFD700);
                var degs:Number = missile_bitmap.rotation - 90;
                engine1 = new ParticleSystem(canvas, x1, y1, velocity / 2, 5, 1, colors, degs-30, degs+30);
				
				if (isBig) {
	                engine1.life_min = 0.2;
	                engine1.life_max = 0.8;
				}
				else {
				    engine1.life_min = 0.1;
				    engine1.life_max = 0.6;
				}

            }
        }

        public function update(dt:Number):void {
            var radians:Number = (-missile_bitmap.rotation + 90) * Math.PI / 180.0;
            var dx:Number = velocity * Math.cos(radians);
            var dy:Number = velocity * Math.sin(radians);
            
            missile_bitmap.x += dt * dx;
            missile_bitmap.y -= dt * dy;
            
            if (isBig) {
                engine1.update(dt);
                engine1.x_start += dt * velocity * Math.cos(radians);
                engine1.y_start -= dt * velocity * Math.sin(radians);
            }
        }
    }
}