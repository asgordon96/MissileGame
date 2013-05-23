package {
    // The particle class for a Particle System
    // It will be used to created particle effects like fire, smoke
    import flash.display.Sprite;
    import flash.display.Graphics;
    
    public class Particle {
        public var canvas:Graphics;
        public var x:Number;
        public var y:Number;
        public var vel_x:Number;
        public var vel_y:Number;
        public var fill_color:uint;
        public var alive:Boolean;
        public var lifespan:Number; // in seconds
        public var update_count:int;
        public var radius:Number;
		public var cur_alpha:Number = 1.0;
		public var alpha_sub:Number = 0.05; // subraction of alpha values each frame
        
        public function Particle(x_pos:Number, y_pos:Number, v:Number, 
                                 angle:Number, life:Number, color:uint, r:Number) {

            // x_pos - starting x coordinate
            // y_pos - starting y coordinate
            // v - velocity
            // angle - angle of motion (in degrees)
            // life - lifespan of the particle (in seconds)
            // color - fill color 
            // r - radius
            x = x_pos;
            y = y_pos;
            vel_x = v * Math.cos(angle * Math.PI / 180);
            vel_y = v * Math.sin(angle * Math.PI / 180);
            fill_color = color;
            lifespan = life;
            radius = r;
            update_count = 0;
            alive = true;
        }
        
        public function update(dt:Number):void {
            // first update the position
            update_count += 1;
            cur_alpha -= alpha_sub;
			
            if (update_count * dt > lifespan) {
                alive = false;
            }
            
            x += vel_x * dt;
            y += vel_y * dt;
        }
    }
}
        
        
        
        
        
        