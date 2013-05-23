package {
    // a file to store game constants and level data
    
    public class constants {
        // constants about speed of things
        // all velocities are in pixels/second
        public static const small_missile_velocity:int = 50;
        public static const big_missile_velocity:int = 100;
        public static const laser_velocity:int = 300;
		public static const heli_velocity:int = 50;
        
        // health and damage data
        public static const player_health:int = 100;
        public static const small_missile_damage:int = 10;
        public static const big_missile_damage:int = 20;
        
		public static const heli_missile_rate:Number = 0.5; // number of missiles fired by a heli each second
		
		// The point values for destroying each type of enemy
		public static const missile_points:int = 100;
		public static const big_missile_points:int = 200;
		public static const heli_points:int = 350;

        public static function levels():Array {
            // return the level data
            // in the form [level_length, small_missile/second, big_missile/second, heli/second]
            var level1:Array = [20, 0.8,  0.00, 0.0];
            var level2:Array = [30, 1.0,  0.00, 0.0];
            var level3:Array = [40, 1.2,  0.00, 0.0];
            var level4:Array = [40, 1.0,  0.05, 0.0];
            var level5:Array = [30, 0.8,  0.10, 0.0];
			var level6:Array = [40, 0.8,  0.10, 0.05];
			var level7:Array = [40, 0.9,  0.15, 0.05];
			var level8:Array = [40, 1.0,  0.20, 0.05];
			var level9:Array = [30, 1.1,  0.20, 0.08];
			var level10:Array = [40, 1.2, 0.25, 0.08];
            
            var levels:Array = [level1, level2, level3, level4, level5, level6, level7, level8, level9, level10];
			//var levels:Array = [level1];
            return levels;
        }
    }
}