// A Laser shot
package {
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.display.Graphics;
    
    public class Laser {
        public var g:Graphics;
        public var velocity:Number;
        public var x_pos:Number;
        public var y_pos:Number;
        public var x_finish:Number;
        public var y_finish:Number;
        public var x_begin:Number;
        public var y_begin:Number;
        public var alive:Boolean;
        
        public function Laser(canvas:Graphics, vel:Number, 
                              x_start:int, y_start:int, x_end:int, y_end:int) {
            g = canvas;
            velocity = vel;
            x_pos = x_start;
            y_pos = y_start;
            x_begin = x_start;
            y_begin = y_start;
            x_finish = x_end;
            y_finish = y_end;
            alive = true;
                       
            g.lineStyle(2, 0xFF0000, 1.0);
        }
        
        public function update(dt:Number):void {
            // the update function called by the timer
            g.moveTo(x_pos, y_pos);
            
            var x_dist:Number = x_finish - x_pos
            var y_dist:Number = y_finish - y_pos
            
            var dist:Number = Math.sqrt(Math.pow(x_dist, 2) + Math.pow(y_dist, 2));
            
            if (dist <= velocity * dt / 2 + 2) {
                alive = false;
            }
            
            x_pos += (velocity / dist) * x_dist * dt;
            y_pos += (velocity / dist) * y_dist * dt;
            g.lineStyle(2, 0xFF0000, 1.0);
            g.moveTo(x_begin, y_begin);
            g.lineTo(x_pos, y_pos);
        }
    }
}
            