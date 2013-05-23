// A class to control the player
package {
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.events.MouseEvent;
    import flash.display.Graphics;
    import flash.media.Sound;
    
    import Laser;
    import constants
    
    public class Player {
                
        [Embed(source="./resources/LaserSound3.mp3")]
        public var laserSound:Class;
        
        public var player_base:Bitmap;
        public var player_gun:Bitmap;
        public var health:Number;
        public var fire_count:int = 0;
        public var drawer:Graphics;
        public var game_active:Boolean = false;
        
        public var laser_list:Vector.<Laser>;
        
        public function Player(base:Bitmap, gun:Bitmap, g:Graphics, x_val:int, y_val:int) {
            drawer = g;
            laser_list = new Vector.<Laser>;
            
            // setup the player position 
            player_base = base;
            player_gun = gun;
            
            player_base.x = x_val - player_base.width / 2;
            player_base.y = y_val - player_base.height;
            player_gun.x = x_val - player_gun.width / 2;
			player_gun.y = player_base.y - player_gun.height;
            
            health = constants.player_health;
            
            player_gun.stage.addEventListener(MouseEvent.CLICK, on_mouse_click);

        }
        public function on_mouse_click(evt:MouseEvent):void {
            if (game_active) {
				// only allow 2 lasers to be in the air at a time
				if (laser_list.length < 2) {
	                var laser_fx:Sound = new laserSound() as Sound;
	                laser_fx.play();
	                fire_count += 1;
                
	                fire(evt.stageX, evt.stageY);
				}
            }
        }
        
        public function fire(x_val:int, y_val:int):void {
            // fire the laser from the player
            var x_begin:Number = player_gun.x + player_gun.width / 2;
            var y_begin:Number = player_gun.y
            
            var laser_vel:int = constants.laser_velocity;
            var laser1:Laser = new Laser(drawer, laser_vel, x_begin, y_begin, x_val, y_val);
            laser_list.push(laser1);
        }
        
        public function update(dt:Number):void {
            for each (var laser:Laser in laser_list) {
                if (laser.alive) {
                    laser.update(dt);
                }
                
                else {
                    var index:Number = laser_list.indexOf(laser);
                    laser_list.splice(index, 1);
                }
            }
        }
    }
}