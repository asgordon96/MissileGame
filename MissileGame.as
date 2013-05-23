package {
    // The main .as file for a Missile Defense game 
    // that is based on the old game "Missile Command"
    
    import flash.display.Sprite;
    import flash.display.Bitmap;
	import flash.display.GradientType;
    import flash.utils.Timer;
    import flash.utils.setTimeout;
    import flash.events.TimerEvent;
    import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
    import flash.media.Sound;
	import flash.media.SoundChannel;
    import flash.geom.Matrix;
	
	// imports for the kongregate api
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.system.Security;
	
    import MissileSprite;
    import Player;
    import Explosion;
    import Button;
	import Helicopter;
    import constants;
    
	[Frame(factoryClass="Preloader")]
	[SWF(width="550", height="400")]
    public class MissileGame extends Sprite {
        [Embed(source="./resources/small_missile.png")] // load the missile image
        public var missileImage:Class;
        
        [Embed(source="./resources/bigMissileNew.png")] // load the big missile image
        public var bigMissileImage:Class;
        
        [Embed(source="./resources/player.png")] // load the player base
        public var playerImage:Class;
        
        [Embed(source="./resources/player_gun.png")] // load the player gun
        public var playerGunImage:Class;
        
        [Embed(source="./resources/ground.png")] // load the ground image
        public var groundImage:Class;
        public var ground:Bitmap;
		
		[Embed(source="./resources/cloud.png")] // load the cloud image
		public var cloudImage:Class;
        
		[Embed(source="./resources/new_tree.png")] // load the tree image
		public var treeImage:Class;
		
        [Embed(source="./resources/healthBarBack.png")]
        public var healthBarBackImage:Class;
        public var healthBarBack:Bitmap;
        
        [Embed(source="./resources/healthBarFront.png")]
        public var healthBarFrontImage:Class;
        public var healthBarFront:Bitmap;

        [Embed(source="./resources/explosion.png")]
        public var explo:Class;
        
		[Embed(source="./resources/rockhybrid2.mp3")]
		public var backgroundMusic:Class;
		
        // load the sound effects
        [Embed(source="./resources/Explode.mp3")]
        public var explodeSound:Class;
        
        // Embed the font "Freedom"
        [Embed(source="./resources/Millennia.otf", 
                fontName = "Millennia", 
                mimeType = "application/x-font", 
                fontWeight="normal", 
                fontStyle="normal", 
                unicodeRange="U+0020-U+007E", 
                advancedAntiAliasing="true", 
                embedAsCFF="false")]
        private var embeddedFont:Class;
        
		public var kongregate:*;
		
		public var music:Sound;
		public var music_channel:SoundChannel;
		
        public var missile_list:Vector.<MissileSprite>;
		public var heli_list:Vector.<Helicopter>;
		
        public var final_player:Player;
        
        public var explosion_list:Vector.<Explosion>;
		public var air_explosions:Vector.<ParticleSystem>;
        
		public var drawer:Sprite;
		public var background_drawer:Sprite;
		
        public var dt:Number;
        public var update_timer:Timer;
        public var update_counter:int;
        
        // variables that control the levels and genereation of missiles
        public var time_length:int;
        public var small_missile_prob:Number;
        public var big_missile_prob:Number;
		public var heli_prob:Number;
        public var current_level:int = 1;
        
		public var score:int = 0;
        public var missiles_hit:int = 0;
		public var big_missiles_hit:int = 0;
		public var helis_destroyed:int = 0;
        public var laser_hits:int = 0;
        
        public var score_text:TextField = new TextField();
        public var debug_counter:int = 0;
        
        public var big_text:TextField = new TextField();
        public var format:TextFormat = new TextFormat();
        
        public var tf:TextFormat;
        
        public var title_text:TextField = new TextField();
        public var play_button:Button;
		public var credits_button:Button;
		
		// The objects in the Game Over Screen
        public var menu_button:Button;
		public var game_over_text:TextField;
		public var player_score:TextField;
		
		// The objects in the start menu screen
        public var menu_objects:Vector.<Bitmap>;
		public var disp_heli:Helicopter;
		
		public var credits_objects:Array;
		
		public var clouds:Vector.<Bitmap>;
        public var trees:Vector.<Bitmap>;
		
		public var can_pause:Boolean = false;
		
		public function MissileGame() {
			addEventListener(Event.ADDED_TO_STAGE, initGame);
		}
		
        public function initGame(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, initGame);
			
			// initialize the background music
			music = new backgroundMusic() as Sound;
			play_music();
						
            init_menu();
			drawer = new Sprite();
			addChild(drawer);
			background_drawer = new Sprite();
			addChildAt(background_drawer, 0);
			
			// the the background sky as a gradient
			var grad_matrix:Matrix = new Matrix();
			grad_matrix.createGradientBox(550, 400, Math.PI / 2);
			
			background_drawer.graphics.beginGradientFill(GradientType.LINEAR, [0x6EA5D1, 0xAADCFF], [1.0, 1.0], [0, 127], grad_matrix);
			background_drawer.graphics.drawRect(0, 0, 550, 400);
			background_drawer.graphics.endFill();
			
			initKongregateAPI();

        }
        
		private function initKongregateAPI():void {
			// Pull the API path from the FlashVars
			var paramObj:Object = LoaderInfo(root.loaderInfo).parameters;

			// The API path. The "shadow" API will load if testing locally. 
			var apiPath:String = paramObj.kongregate_api_path || 
			  "http://www.kongregate.com/flash/API_AS3_Local.swf";

			// Allow the API access to this SWF
			Security.allowDomain(apiPath);

			// Load the API
			var request:URLRequest = new URLRequest(apiPath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.load(request);
			this.addChild(loader);        
		}
		
		// This function is called when loading is complete
		public function loadComplete(event:Event):void {
		    // Save Kongregate API reference
		    kongregate = event.target.content;
         
		    // Connect to the back-end
		    kongregate.services.connect();
		}
		
		public function play_music():void {
			music_channel = music.play();
			music_channel.addEventListener(Event.SOUND_COMPLETE, loop_music);
		}
		
		public function loop_music(e:Event):void {
		    music_channel.removeEventListener(Event.SOUND_COMPLETE, loop_music);
			play_music();
		}
		
        public function init_menu():void {
			var text_format:TextFormat = new TextFormat("Millennia", 72, 0x000000);
            play_button = new Button(215, 165, "PLAY", play_game, text_format);
            play_button.set_font_size(80);
			play_button.font_size_rollover = 90;
            play_button.set_color(0x0000);
            play_button.rollover_color = 0xFF0000;
            play_button.display_text.x = 275 - play_button.display_text.width / 2;
            play_button.display_text.y = 150;
            
            addChild(play_button);
            
			var credits_format:TextFormat = new TextFormat("Millennia", 50, 0x000000);
			credits_button = new Button(0, 0, "CREDITS", show_credits, credits_format);
			credits_button.set_font_size(40);
			credits_button.font_size_rollover = 45;
			credits_button.set_color(0x0000);
			credits_button.rollover_color = 0xFF0000;
			credits_button.display_text.x = 275 - credits_button.display_text.width / 2;
			credits_button.display_text.y = 240;
			
			addChild(credits_button);
			
            tf = new TextFormat("Millennia", 70, 0xFF0000);
            // the text format MUST be set BEFORE the actual text
            // otherwise the text will not appear
            title_text.defaultTextFormat = tf;
            title_text.embedFonts = true;
            title_text.text = "LASER DEFENSE";
            title_text.autoSize = TextFieldAutoSize.CENTER;
            title_text.x = 275 - title_text.width / 2;
            title_text.y = 15;
			title_text.selectable = false;
            

			
			// the display graphics for the menu screen
            var disp_missile1:Bitmap = new bigMissileImage() as Bitmap;
            var disp_missile2:Bitmap = new missileImage() as Bitmap;
			var disp_missile3:Bitmap = new missileImage() as Bitmap;
			var disp_missile4:Bitmap = new missileImage() as Bitmap;
			var disp_missile5:Bitmap = new bigMissileImage() as Bitmap;
            disp_missile1.x = 400;
            disp_missile1.y = 175;
            disp_missile1.rotation = 165;
            disp_missile2.x = 450;
            disp_missile2.y = 225;
			disp_missile2.rotation = 195;
			disp_missile3.x = 400;
			disp_missile3.y = 280;
			disp_missile3.rotation = 210;
			disp_missile4.x = 250;
			disp_missile4.y = 350;
			disp_missile4.rotation = 150;
			disp_missile5.x = 140;
			disp_missile5.y = 300;
			disp_missile5.rotation = 200;
			
			var disp_explo:Bitmap = new explo() as Bitmap;
			disp_explo.x = 300;
			disp_explo.y = 300;
			disp_explo.scaleX = 1.5;
			disp_explo.scaleY = 1.5;
			
			disp_heli = new Helicopter(0, 50, 0);
			disp_heli.scaleX = 2.0;
			disp_heli.scaleY = 2.0;
			addChild(disp_heli);
			
			menu_objects = new Vector.<Bitmap>();
			menu_objects.push(disp_missile1, disp_missile2, disp_missile3, disp_missile4, disp_missile5, disp_explo);
			
			for each (var object:Bitmap in menu_objects) {
			    addChild(object);
			}
			
            addChild(title_text);
            
        }
        
        public function back_to_menu():void {
            // clear the game screen and draw the start menu
            for each (var e:Explosion in explosion_list) {
                removeChild(e.explosionBitmap);
            }
            
            for each (var m:MissileSprite in missile_list) {
                removeChild(m.missile_bitmap);
            }
			
			for each (var h:Helicopter in heli_list) {
				removeChild(h);
			}
            
			for each (var t:Bitmap in trees) {
				removeChild(t);
			}
			
			for each (var c:Bitmap in clouds) {
				removeChild(c);
			}
			
            removeChild(healthBarBack);
            removeChild(healthBarFront);
            removeChild(ground);
            removeChild(final_player.player_base);
            removeChild(final_player.player_gun);
            removeChild(menu_button);
            removeChild(score_text);
			removeChild(game_over_text);
			removeChild(player_score);

            big_text.text = "";
            drawer.graphics.clear();
            
            current_level = 1;
			score = 0;
            missiles_hit = 0;
			big_missiles_hit = 0;
			helis_destroyed = 0;
            init_menu();
        }
            
		
        public function play_game():void {
            // first delete the menu
            removeChild(play_button);
			removeChild(credits_button);
            removeChild(title_text);
			removeChild(disp_heli);
            for each (var menu_disp:Bitmap in menu_objects) {
			    removeChild(menu_disp);
			}
            
            // create the list all the in game sprite and bitmaps
			// including missiles, explosions, helicopter, clouds and trees
            missile_list = new Vector.<MissileSprite>();
            explosion_list = new Vector.<Explosion>();
			air_explosions = new Vector.<ParticleSystem>();
			heli_list = new Vector.<Helicopter>();
			clouds = new Vector.<Bitmap>();
			trees = new Vector.<Bitmap>();
			
			// add the clouds in the sky
			for (var i:int = 0; i < 10; i++) {
				var cloud:Bitmap = new cloudImage() as Bitmap;
				cloud.scaleX = 0.6;
				cloud.scaleY = 0.6;
				cloud.x = Math.random() * (550 - cloud.width);
				cloud.y = Math.random() * (130 - cloud.height);
				addChildAt(cloud, 1);
				clouds.push(cloud);
			}

            // the sprite for the ground
            ground = new groundImage() as Bitmap;
            ground.x = 0;
            ground.y = 400 - ground.height;
			ground.width = 550;
            addChild(ground);
			
            // the sprite for the player
            var player:Bitmap = new playerImage() as Bitmap;
            var player_gun:Bitmap = new playerGunImage() as Bitmap;
            addChild(player);
            addChild(player_gun)
            final_player = new Player(player, player_gun, drawer.graphics, 275, ground.y);
            
			// add the trees on the ground
			var x_positions:Array = [20, 100, 350, 450];
			for (var j:int = 0; j < 4; j++) {
				var a_tree:Bitmap = new treeImage() as Bitmap;
				a_tree.scaleX = 0.6;
				a_tree.scaleY = 0.6;
				a_tree.y = ground.y - a_tree.height + 5;
				a_tree.x = x_positions[j];
				trees.push(a_tree);
				addChild(a_tree);
			}
			
			
			var t_format:TextFormat = new TextFormat("Millennia", 24, 0x000000);
			score_text.defaultTextFormat = t_format;
			score_text.embedFonts = true;
            score_text.text = "Score: " + String(score);
			score_text.width = 200;
			score_text.selectable = false;
            addChild(score_text);
            
            // create the health bar
            healthBarFront = new healthBarFrontImage() as Bitmap;
            healthBarBack = new healthBarBackImage() as Bitmap;
            
            healthBarBack.x = 275 - healthBarBack.width / 2;
            healthBarBack.y = stage.height - ground.height / 2 - healthBarBack.height / 2;
            healthBarFront.x = healthBarBack.x + 2
            healthBarFront.y = healthBarBack.y + 2
            healthBarFront.scaleX = 1.0
            
            addChild(healthBarBack);
            addChild(healthBarFront);
            
            // initialize the main center text field
            format.size = 60;
            format.align = "center";
            big_text.autoSize = TextFieldAutoSize.CENTER;
			big_text.defaultTextFormat = tf;
			big_text.embedFonts = true;
            big_text.text = "";
            big_text.selectable = false;
            big_text.x = 275 - big_text.width / 2;
            big_text.y = 150;
            addChildAt(big_text, 1);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, on_key_down);
			
            dt = 1 / 30;
            
            update_timer = new Timer(dt * 1000);
            update_timer.addEventListener(TimerEvent.TIMER, update);
			
            begin_level(current_level);
        }
        
        public function add_explosion(x:int, y:int):void {
            // create a new explosion and add it to the explosion_list
            var image:Bitmap = new explo() as Bitmap;
            var ex:Explosion = new Explosion(image, x, y, 0.1, 1.2);
            addChild(image);
            explosion_list.push(ex);
        }
        
		public function add_air_explosion(xval:int, yval:int):void {
			var c:Array = new Array(0xFF0000, 0xFFFF00, 0xFF7900, 0xCE2029, 0xFFA500, 0xFFD700); 
			var air_explo:ParticleSystem = new ParticleSystem(drawer.graphics, xval, yval, 100, 15, 1, c, 0, 360);
			air_explo.time = 0.4;
			air_explo.life_min = 0.15;
			air_explo.life_max = 0.35;
			air_explo.rate_dec = 0.85;
			air_explosions.push(air_explo);
		}
		
		public function add_big_air_explosion(xval:int, yval:int):void {
			var c:Array = new Array(0xFF0000, 0xFFFF00, 0xFF7900, 0xCE2029, 0xFFA500, 0xFFD700); 
			var explosion:ParticleSystem = new ParticleSystem(drawer.graphics, xval, yval, 100, 25, 1, c, 0, 360);
			explosion.time = 0.4;
			explosion.life_min = 0.6;
			explosion.life_max = 0.8;
			explosion.rate_dec = 0.95;
			air_explosions.push(explosion);
		}
		
        public function add_missile(vel:Number, x:int, y:int, angle:int):void {
            // Add a missile to the missile_list and the screen
            var m_bitmap:Bitmap = new missileImage() as Bitmap;
            var m:MissileSprite = new MissileSprite(drawer.graphics, m_bitmap, vel, x, y, angle);
            missile_list.push(m);
            addChild(m_bitmap);
        }
        
        public function add_big_missile(x:int, y:int, angle:int):void {
            var big_bitmap:Bitmap = new bigMissileImage() as Bitmap;
            var v:Number = constants.big_missile_velocity;
            
            var big_missile:MissileSprite = new MissileSprite(drawer.graphics, big_bitmap, v, x, y, angle, true);
            missile_list.push(big_missile);
            addChild(big_bitmap);
        }
        
        public function add_random_missile(big:Boolean=false):void {
            // add a missile to the game at a random starting location
            var x_val:Number = Math.random() * 530 + 10;
            var y_val:int = 0;

            // calculate possible angle that keep the missile on the screen
            var angle1:Number = Math.atan((x_val - 5) / ground.y) * 180 / Math.PI;
            var angle2:Number = Math.atan((550 - x_val) / ground.y) * 180 / Math.PI;
            var final_angle:Number = Math.random() * (angle1 + angle2) - angle2 + 180;
            
            if (big) {
                add_big_missile(x_val, y_val, final_angle);
            }
            else {
                var velo:Number = constants.small_missile_velocity;
                add_missile(velo, x_val, y_val, final_angle);
            }
        }
        
		public function add_helicopter():void {
			var y_val:Number = Math.random() * 180;
			var x_val:Number = 0;
			var scale_x:Number = 1;
			
			// arrives from the right or the left
			if (Math.random() > 0.5) {
				x_val = 0;
				scale_x = -1;
			}
			else {
				x_val = 600;
				scale_x = 1;
			}

			var h:Helicopter = new Helicopter(x_val, y_val, -constants.heli_velocity);
			h.scaleX = scale_x;
			addChild(h);
			heli_list.push(h);
			
		}
		
        public function begin_level(number:int):void {
            // start a new level 
            update_timer.stop();
            big_text.text = "LEVEL " + String(number);
            big_text.setTextFormat(format);
			setChildIndex(big_text, this.numChildren - 1);
            setTimeout(resume, 1000 * 1.5);
            
			// check if we have specific level definitions
			if (number > constants.levels().length) {
				var diff:Number = number - constants.levels().length;
				time_length = 40;
				small_missile_prob = (1.2 + 0.05 * diff) * dt;
				big_missile_prob = (0.25 + 0.025 * diff) * dt;
				heli_prob = (0.08 + 0.02 * diff) * dt;
			}
			
			else {
	            var level_data:Array = constants.levels() [number-1];
	            time_length = level_data[0];
	            small_missile_prob = level_data[1] * dt;
	            big_missile_prob = level_data[2] * dt;
				heli_prob = level_data[3] * dt;
			}
			
            update_counter = 0;
            final_player.health = constants.player_health;
            final_player.game_active = true;
            healthBarFront.scaleX = 1;
        }
            
            
        public function update(evt:TimerEvent):void {
            // first clear the drawing graphics
            drawer.graphics.clear();
            
            for each (var missile:MissileSprite in missile_list) {
                if (missile != null) {
                    missile.update(dt);
                }
            }
            
			for each (var heli:Helicopter in heli_list) {
				if (heli.in_screen()) {
					heli.update(dt);
				
					var center_x:Number = 0;
					if (heli.scaleX == 1) {
						center_x = heli.heli.x + heli.heli.width / 2;
					}
					else {
						center_x = -heli.heli.x - heli.heli.width / 2;
					}
				
					
					var n:int = 1 / (dt * constants.heli_missile_rate)
					if (heli.count % n == 0 && center_x > 100 && center_x < 500) {
						// calculate possible angles that keep the missile on the screen
						var x_val:Number = center_x;
						var y_val:Number = heli.heli.y + heli.heli.height + 27;
						var angle1:Number = Math.atan((x_val - 5) / (ground.y - y_val)) * 180 / Math.PI;
						var angle2:Number = Math.atan((500 - x_val) / (ground.y - y_val)) * 180 / Math.PI;
						var final_angle:Number = Math.random() * (angle1 + angle2) - angle2 + 180;
						add_missile(constants.small_missile_velocity, x_val, y_val, final_angle);
					}
				}
				else {
					removeChild(heli);
					var h_index:int = heli_list.indexOf(heli);
					heli_list.splice(index, 1);
				}
				
			}
			
            for each (var exp:Explosion in explosion_list) {
                if (exp.alive) {
                    exp.update();
                }
                else {
                    removeChild(exp.explosionBitmap);
                    var index:int = explosion_list.indexOf(exp);
                    explosion_list.splice(index, 1);
                }
            }
            
			for each (var a_exp:ParticleSystem in air_explosions) {
				if (a_exp.is_alive(dt)) {
					a_exp.update(dt);
				}
				else {
					air_explosions.splice(air_explosions.indexOf(a_exp), 1);
				}
			}
			
            final_player.update(dt);
            check_collisions();
            check_ground_collisions();
            
            // if the level time in complete and there are no more missiles
            // end the levels and start the next
            
            if (update_counter > (time_length / dt) && missile_list.length == 0
			&& explosion_list.length == 0 && final_player.laser_list.length == 0
			&& heli_list.length == 0 && air_explosions.length == 0) {
                    
                update_timer.stop();
                final_player.game_active = false;
				can_pause = false;
                big_text.text = "Level " + String(current_level) + " Complete";
                big_text.setTextFormat(format);
                current_level += 1;

                setTimeout(begin_level, 1000 * 1.5, current_level);
            }
                
            
            // only add more missiles if the time hasn't run out
            if (update_counter < (time_length / dt)) {
                // generate random missiles according to the level
                var prob:Number = Math.random();
                if (prob < small_missile_prob) {
                    add_random_missile();
                }
                
                var prob2:Number = Math.random();
                if (prob2 < big_missile_prob) {
                    add_random_missile(true);
                }
				
				var prob3:Number = Math.random();
				if (prob3 < heli_prob) {
					add_helicopter();
				}
            }
            
			setChildIndex(drawer, this.numChildren - 1);
			
            // check if the player is stil alive
            if (final_player.health <= 0) {
                healthBarFront.scaleX = 0;
				final_player.game_active = false;
                can_pause = false;
				
                update_timer.stop();
				game_over_screen();
            }
            
			
            update_counter += 1;
            
            //score_text.text = String(missiles_hit) + " / " + String(final_player.fire_count);
        }
        
		public function on_key_down(key_event:KeyboardEvent):void {
			// if the escape key or "p" is pressed pause or unpause the game
			if (can_pause) {
				if (String.fromCharCode(key_event.charCode) == "p" || key_event.keyCode == 27) {
					if (update_timer.running) {
						update_timer.stop();
						big_text.text = "PAUSED";
						final_player.game_active = false;
					}
					else {
						big_text.text = "";
						update_timer.start();
						final_player.game_active = true;
					}
				}
			}
		}
		
        public function win_screen():void {
            big_text.text = "You Win!";
            big_text.setTextFormat(format)
        }
        
		public function game_over_screen():void {
			// Draw the Game Over text showing the score
			
			// draw the "Game Over" Text
			var text_format:TextFormat = new TextFormat("Millennia", 72, 0xFF0000);
			game_over_text = new TextField();
			game_over_text.defaultTextFormat = text_format;
			game_over_text.embedFonts = true;
			game_over_text.text = "GAME OVER";
			game_over_text.autoSize = TextFieldAutoSize.CENTER;
			game_over_text.selectable = false;
			game_over_text.x = 275 - game_over_text.width / 2;
			game_over_text.y = 50;
			addChild(game_over_text);
			
			// Show the player's score
			player_score = new TextField();
			var score_format:TextFormat = new TextFormat("Millennia", 56, 0x000000);
			player_score.defaultTextFormat = score_format;
			player_score.embedFonts = true;
			player_score.text = "SCORE: " + String(score);
			player_score.autoSize = TextFieldAutoSize.CENTER;
			player_score.x = 275 - player_score.width / 2;
			player_score.y = 150;
			addChild(player_score);
			
            // draw the "Main Menu" button
			var text_f:TextFormat = new TextFormat("Millennia", 24, 0x000000)
            menu_button = new Button(200, 300, "Main Menu", back_to_menu, text_f);
            menu_button.set_font_size(36);
            menu_button.font_size_rollover = 44;
			menu_button.display_text.x = 275 - menu_button.display_text.width / 2;
            addChild(menu_button);
			
			// submit the player's score
			kongregate.stats.submit("Score", int(score));
		}
		
        public function check_ground_collisions():void {
            // check for collisions between missiles and the ground
            for each (var mi:MissileSprite in missile_list) {
                if (mi != null) {
                    if (mi.missile_bitmap.hitTestObject(ground)) {
                        
                        add_explosion(mi.missile_bitmap.x, mi.missile_bitmap.y);
                        var sound:Sound = new explodeSound() as Sound;
                        sound.play();
                        
                        // remove the missile from the screen
                        removeChild(mi.missile_bitmap);
                        var i:int = missile_list.indexOf(mi);
                        missile_list[i] = null;
                        missile_list.splice(i, 1);
                        
                        if (mi.isBig) {
                            final_player.health -= constants.big_missile_damage;
                        }
                        else {
                            final_player.health -= constants.small_missile_damage;
                        }
                        healthBarFront.scaleX = final_player.health / 100;
                    }
                }
            }
        }
        
        public function check_collisions():void {
            // check the collisions between lasers fired and incoming missiles
            for each (var laser:Laser in final_player.laser_list) {
                
				for each (var h:Helicopter in heli_list) {
					
					if (h.scaleX == 1) {
						if (point_in_bitmap(h.heli, laser.x_pos, laser.y_pos)) {
							h.health -= 1;
							h.shake(0.5);
							var rem_i:Number = final_player.laser_list.indexOf(laser);
							final_player.laser_list.splice(rem_i, 1)
						}
					}
					else {
						if (point_in_bitmap_flipped(h.heli, laser.x_pos, laser.y_pos)) {
							h.health -= 1;
							h.shake(0.5);
							var rem_index:Number = final_player.laser_list.indexOf(laser);
							final_player.laser_list.splice(rem_index, 1)
						}
					}
					if (h.health == 0) {
						helis_destroyed += 1;
						update_score();
						
						add_big_air_explosion(laser.x_pos, laser.y_pos);
						removeChild(h);
						heli_list.splice(heli_list.indexOf(h), 1);
						
					}
				}
				
                for each (var missile:MissileSprite in missile_list) {
                    if (missile != null) {
                        var mx:Number = missile.missile_bitmap.x;
                        var my:Number = missile.missile_bitmap.y;
                        
                        if (distance(laser.x_pos, laser.y_pos, mx, my) < 25) {
                            if (distance(laser.x_finish, laser.y_finish, mx, my) < 25) {
                                
                                // the missile has been hit!
                                // remove the missile
                                var index:int = missile_list.indexOf(missile);
                                missile_list[index] = null;
                                missile_list.splice(index, 1);
                                removeChild(missile.missile_bitmap);
                                
								add_air_explosion(mx, my);
								
								if (missile.isBig) {
                                	big_missiles_hit += 1;
								}
								else {
									missiles_hit += 1;
								}
								
								update_score();
                            }
                        }
                    }
                }
            }
        }
        
		public function show_credits():void {
            removeChild(play_button);
			removeChild(credits_button);
			removeChild(disp_heli);
            for each (var menu_disp:Bitmap in menu_objects) {
			    removeChild(menu_disp);
			}
			
			title_text.text = "CREDITS"
			
			var text_format:TextFormat = new TextFormat("Arial", 18, 0x000000)
			var text1:TextField = new TextField();
			text1.defaultTextFormat = text_format;
			text1.text = "Programming and Artwork: Aaron Gordon";
			text1.x = 50;
			text1.y = 100;
			text1.width = 500;
			text1.selectable = false;

			var text2:TextField = new TextField();
			text2.defaultTextFormat = text_format;
			text2.text = "Music: Rock Hybrid Kevin McLeod (imcompetech.com)";
			text2.x = 50;
			text2.y = 130;
			text2.width = 500;
			text2.selectable = false;
			
			var text3:TextField = new TextField();
			text3.defaultTextFormat = text_format;
			text3.text = "Explosion Sound Effect: eRco Inc.";
			text3.x = 50;
			text3.y = 160;
			text3.width = 500;
			text3.selectable = false;
			
			var text4:TextField = new TextField();
			text4.defaultTextFormat = text_format;
			text4.text = "Laser Sound Effect: Public Domain";
			text4.x = 50;
			text4.y = 190;
			text4.width = 500;
			text4.selectable = false;
			
			addChild(text1);
			addChild(text2); 
			addChild(text3);
			addChild(text4);
			
			var menu_format:TextFormat = new TextFormat("Millennia", 24, 0x000000)
            var back:Button = new Button(200, 300, "Back to Menu", menu_from_credits, menu_format);
            back.set_font_size(36);
            back.font_size_rollover = 44;
			back.display_text.x = 275 - back.display_text.width / 2;
            addChild(back);
			
			credits_objects = new Array(text1, text2, text3, text4, back);
		}
		
		public function menu_from_credits():void {
			for (var i:Number = 0; i < credits_objects.length; i++) {
				removeChild(credits_objects[i]);
			}
			init_menu();
		}
		
		public function update_score():void {
			var missile_part:Number = missiles_hit * constants.missile_points;
			var big_missile_part:Number = big_missiles_hit * constants.big_missile_points;
			var heli_part:Number = helis_destroyed * constants.heli_points;
			score = missile_part + big_missile_part + heli_part;
			score_text.text = "Score: " + String(score);
		}
		
        public function resume():void {
            // start the timer after it has been stopped
            update_timer.start();
            big_text.text = "";
			can_pause = true;
        }
        
        public function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number {
            // return the straight line distance between 2 points
            var x_part:Number = Math.pow(x2 - x1, 2);
            var y_part:Number = Math.pow(y2 - y1, 2);
            return Math.sqrt(x_part + y_part);
        }
		
		public function point_in_bitmap(bit:Bitmap, x_coord:Number, y_coord:Number):Boolean {
			if (x_coord > bit.x && x_coord < bit.x + bit.width && y_coord > bit.y && y_coord < bit.y + bit.height) {
				return true;
			}
			else {
				return false;
			}
		}
		
		public function point_in_bitmap_flipped(bit:Bitmap, x_coord:Number, y_coord:Number):Boolean {
			if (x_coord > -bit.x - bit.width && x_coord < -bit.x && y_coord > bit.y && y_coord < bit.y + bit.height) {
				return true;
			}
			else {
				return false;
			}
		}
    }
}