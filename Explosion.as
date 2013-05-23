// Explosion.as
// A class for controlling the explosion in the game

package {
    import flash.display.Bitmap;
    import flash.display.Sprite;
    
    public class Explosion {
        public var explosionBitmap:Bitmap;
        public var x:Number;
        public var y:Number;
        public var increaseFactor:Number;
        public var maxScale:Number;
        public var count:int;
        public var alive:Boolean;
        
        public function Explosion(image:Bitmap, x_pos:Number, y_pos:Number, increase:Number, max:Number) {
            explosionBitmap = image;
            x = x_pos;
            y = y_pos;
            increaseFactor = increase;
            maxScale = max;
            alive = true;
            count = 1;
            
            explosionBitmap.scaleX = 0.2;
            explosionBitmap.scaleY = 0.2;
            
            explosionBitmap.x = x - explosionBitmap.width / 2;
            explosionBitmap.y = y + explosionBitmap.height / 2;
        }
        
        public function update():void {
            if (explosionBitmap.scaleX > 0.5) {
                increaseFactor = 0.03
            }
            else {
                increaseFactor = 0.03
            }
            
            explosionBitmap.scaleX += increaseFactor;
            explosionBitmap.scaleY += increaseFactor;
            
            
            if (explosionBitmap.scaleX >= maxScale) {
                alive = false
            }
                
            explosionBitmap.x = x - explosionBitmap.width / 2;
            explosionBitmap.y = y - explosionBitmap.height / 2;
        }
    }
}