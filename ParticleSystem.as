package {
    // A class for making a particle system
    // Goal of creating effects like fire
    
    import flash.display.Sprite;
    import flash.display.Graphics;
    import Particle;
    
    public class ParticleSystem {
        
        public var canvas:Graphics;
        public var particles:Vector.<Particle>;
        
        public var x_start:Number;
        public var y_start:Number;
        public var particle_rate:Number; // particles per second emitted
        public var particles_per_frame:Number; // number of particles created per frame
        public var velocity:Number;
        public var color_list:Array;
        public var radius:Number;
        public var angle_start:Number;
        public var angle_stop:Number;
        public var life_min:Number = 2;
        public var life_max:Number = 4;
		
		public var count:int = 0;
		public var time:Number = 0;
		public var rate_dec:Number = 1; // A number to change the velocity of each particle over time
        
        public function ParticleSystem(g:Graphics, x:Number, y:Number, v:Number,
                                       rate:Number, r:Number, colors:Array,
                                       angle1:Number, angle2:Number) {
            canvas = g;
            x_start = x;
            y_start = y;
            velocity = v;
            //particle_rate = rate;
            particles_per_frame = rate;
            radius = r;
            color_list = colors
            angle_start = angle1;
            angle_stop = angle2;
            
            particles = new Vector.<Particle>();
        }
        
        public function choose_color():uint {
            return color_list[int(Math.random() * color_list.length)];
        }
        
        public function choose_angle():Number {
            return Math.random() * (angle_stop - angle_start) + angle_start;
        }
        
        public function choose_lifespan():Number {
            return Math.random() * (life_max - life_min) + life_min;
        }
        
        public function add_particle(c:uint, a:Number, l:Number):void {
            var p:Particle = new Particle(x_start, y_start, velocity, a, l,
                                          c, radius);
            particles.push(p);
        }
        
		public function is_alive(dt:Number):Boolean {
			if (particles.length == 0 && count * dt > time) {
				return false;
			}
			else {
				return true;
			}
		}
		
        public function update(dt:Number):void {
            // first create new particles
//            var prob:Number = dt * particle_rate;
//            if (prob > 1) {
//                // if we need more than 1 particle per frame
//                add_particle(choose_color(), choose_angle(), choose_lifespan());
//                prob = prob - 1;
//            }
                
//            if (Math.random() < prob) {
//                add_particle(choose_color(), choose_angle(), choose_lifespan());
//            }
            
			count += 1;
			if (count * dt < time || time == 0) {
	            for (var index:int=0; i < particles_per_frame; ++i) {
	                add_particle(choose_color(), choose_angle(), choose_lifespan());
	            }
			}

            
            // next, update, draw and check if the particles are alive
            var i:int = 0;
            for each (var p:Particle in particles) {
                if (p.alive) {
                    // update and draw a particle
                    p.update(dt);
					p.vel_x *= rate_dec;
					p.vel_y *= rate_dec;
                    canvas.beginFill(p.fill_color, p.cur_alpha);
                    canvas.drawCircle(p.x, p.y, p.radius);
                }
                else {
                    // remove a particle from the list
                    particles.splice(i, 1);
                }
                i += 1;
            }
        }
    }
}
                    