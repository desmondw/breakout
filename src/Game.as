package  
{
	import gui.Button;
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.graphics.*;

	public class Game extends World
	{
		//constants
		private const BRICK_SPACING:int = 2;
		private const STARTING_LIVES:int = 2;
		
		//vars
		private var ballFired:Boolean = false;
		public static var paused:Boolean;
		
		//entities
		public static var paddle:Paddle;
		public static var ball:Ball;
		private var pauseMenu:PauseMenu = new PauseMenu();
		
		//{ GRAPHICS / GUI
		private const BG_SCROLL_SPEED:int = 60; //background constantly scrolling rate
		private const PLX_RATIO:Number = .08; //parallaxing ratio - percent bg moves left/right when paddle moves
		private const ICON_BORDER_SPACING:Number = 5; //space of icons from side of screen
		private const ICON_SPACING:Number = 5; //space between icons
		private const ICON_SIZE:Number = 10; //icon width/height
		
		//entities
		private var bg:Entity;
		private var bg2:Entity;
		private var bgOrigin:int;
		
		private var lives:Array = new Array();
		private var soundBtn:Button;
		private var musicBtn:Button;
		private var pauseBtn:Button;
		
		public var fade:Fader = new Fader();
		//}
		
		
		public function Game() 
		{
			//{ INITIALIZATION
			//variables
			paused = false;
			
			//entities
			paddle = new Paddle();
			ball = new Ball();
			ball.hoverOverPaddle();
			
			//{ GRAPHICS
			var img:Image = new Image(Resources.BG);
			bgOrigin = -(img.width - FP.screen.width) / 2
			
			bg = new Entity(bgOrigin, 0, img);
			bg.setHitbox(img.width, img.height);
			bg2 = new Entity(bgOrigin, -bg.height, img);
			bg2.setHitbox(img.width, img.height);
			
			var img:Image = new Image(Resources.ICON_BALL)
			var livesX:Number = ICON_BORDER_SPACING;
			var livesY:Number = FP.height - ICON_SIZE - ICON_BORDER_SPACING;
			
			//icons
			for (var i:int = 0; i < STARTING_LIVES; i++) //lives
				lives.push(new Entity(livesX + ((i) * (img.width + ICON_SPACING)), livesY, img));
			
			//bottom right icons
			var iconsX:Number = FP.width - (3 * (ICON_SIZE + ICON_SPACING) - ICON_SPACING + ICON_BORDER_SPACING);
			var iconsY:Number = FP.height - ICON_SIZE - ICON_BORDER_SPACING;
			
			//sound
			soundBtn = new Button(iconsX, iconsY);
			soundBtn.setGraphic(new Image(Resources.ICON_SOUND_ON), ICON_SIZE, ICON_SIZE);
			soundBtn.onClick(soundBtn_onClick);
			
			//music
			musicBtn = new Button(iconsX + ICON_SIZE + ICON_SPACING, iconsY);
			musicBtn.setGraphic(new Image(Resources.ICON_MUSIC_ON), ICON_SIZE, ICON_SIZE);
			musicBtn.onClick(musicBtn_onClick);
			
			//pause
			pauseBtn = new Button(iconsX + (ICON_SIZE + ICON_SPACING)*2, iconsY);
			pauseBtn.setGraphic(new Image(Resources.ICON_PAUSE), ICON_SIZE, ICON_SIZE);
			pauseBtn.onClick(pauseBtn_onClick);
			
			//}
			
			//add entities to world
			//background
			add(bg);
			add(bg2);
			
			//game
			addBricks();
			add(ball);
			add(paddle);
			
			//gui
			for (var i:int = 0; i < lives.length; i++) //lives
				add(lives[i]);
			add(soundBtn);
			add(musicBtn);
			add(pauseBtn);
			
			//whole screen effects
			fade.fadeIn(2);
			add(fade);
			//}
			
			//define input
			Input.define("fire", Key.SPACE, Key.W, Key.UP);
			Input.define("pause", Key.ESCAPE, Key.P);
		}
		
		private function addBricks():void 
		{
			var brickOffset:int = (FP.width - (7 * (Brick.SIZE_X + BRICK_SPACING) - BRICK_SPACING)) / 2;
			
			//create bricks 7x5 with 5 pixels inbetween
			for (var i:int = 0; i < 7; i++)
			{
				for (var j:int = 0; j < 5; j++)
				{
					var brickX:int = i * (Brick.SIZE_X + BRICK_SPACING) + brickOffset;
					var brickY:int = j * (Brick.SIZE_Y + BRICK_SPACING) + brickOffset;
					var color:uint;
					
					switch(j)
					{
						case 0:
							color = 0x999999;
							break;
						case 1:
							color = 0xBBBBBB;
							break;
						case 2:
							color = 0xDDDDDD;
							break;
						case 3:
							color = 0xEEEEEE;
							break;
						case 4:
							color = 0xFFFFFF;
							break;
					}
					
					var brick:Brick = new Brick(brickX, brickY, color);
					add(brick);
				}
			}
		}

		override public function update():void
		{
			//if paused, handle pause specific-behavior ONLY
			if (paused)
			{
				pauseMenu.update();
				super.update();
				return;
			}
			
			super.update();
			
			handleInput();
			if (paddle.Autopilot)
				manageAutopilot();
			
			//move ball with paddle
			if (!ballFired)
				ball.hoverOverPaddle();
			
			checkHandleNoBalls();
			checkHandleNoBricks();
			
			updateGraphics();
		}
		
		private function handleInput():void 
		{
			//back out to menu
			//if (Input.pressed(Key.ESCAPE))
				//FP.world = new Menu();
				
			//pause
			if (Input.pressed("pause"))
			{
				add(pauseMenu);
				Game.paused = true;
			}
			
			//paddle autopilot
			//if (Input.pressed(Key.E))
				//paddle.toggleAutopilot();
				
			//firing ball from paddle
			if (!ballFired && Input.pressed("fire"))
			{
				ballFired = true;
				ball.fireFromPaddle();
			}
		}
		
		private function manageAutopilot():void 
		{
			if (!ballFired)
			{
				ballFired = true;
				ball.fireFromPaddle();
			}
		}
		
		private function updateGraphics():void 
		{
			//bg scrolling
			bg.y += BG_SCROLL_SPEED * FP.elapsed;
			bg2.y += BG_SCROLL_SPEED * FP.elapsed;
			
			if (bg.y > FP.screen.height)
				bg.y = bg2.y - bg.height;
			if (bg2.y > FP.screen.height)
				bg2.y = bg.y - bg2.height;
			
			bg.x = bgOrigin + -(paddle.centerX - FP.width / 2) * PLX_RATIO;
			bg2.x = bgOrigin + -(paddle.centerX - FP.width / 2) * PLX_RATIO;
		}
		
		//check if all balls destroyed
		private function checkHandleNoBalls():void 
		{
			if (classCount(Ball) <= 0) //no balls on screen
			{
				if (lives.length <= 0) //no backup balls
					gameOver(); //game over
				else //setup a backup ball
				{
					//remove old ball
					remove(lives[lives.length-1]);
					lives.pop();
					
					ballFired = false;
					ball = new Ball();
					ball.hoverOverPaddle();
					add(ball);
				}
			}
		}
		
		private function checkHandleNoBricks():void 
		{
			if (classCount(Brick) <= 0) //no bricks left
				win();
		}
		
		private function gameOver():void 
		{
			FP.world = new Menu();
		}
		
		private function win():void 
		{
			FP.world = new Menu();
		}
		
		//{ event handling
		private function soundBtn_onClick(b:Button):void 
		{
			if (Main.soundOn)
			{
				Main.soundOn = false;
				b.setGraphic(new Image(Resources.ICON_SOUND_OFF), ICON_SIZE, ICON_SIZE);
			}
			else
			{
				Main.soundOn = true;
				b.setGraphic(new Image(Resources.ICON_SOUND_ON), ICON_SIZE, ICON_SIZE);
			}
		}
		
		private function musicBtn_onClick(b:Button):void 
		{
			if (Main.musicOn)
			{
				Main.musicOn = false;
				b.setGraphic(new Image(Resources.ICON_MUSIC_OFF), ICON_SIZE, ICON_SIZE);
			}
			else
			{
				Main.musicOn = true;
				b.setGraphic(new Image(Resources.ICON_MUSIC_ON), ICON_SIZE, ICON_SIZE);
			}
		}
		
		private function pauseBtn_onClick(b:Button):void 
		{
			add(pauseMenu);
			Game.paused = true;
		}
		//}
	}
}