package  
{
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.graphics.*;
	
	public class Paddle extends Entity
	{
		//constants
		private const SIZE_X:int = 120;
		private const SIZE_Y:int = 20;
		private const MAX_SPEED:Number = 400;
		private const ACCELERATION:Number = 30;
		
		//vars
		private var autopilot:Boolean = false;
		private var velocity:Number = 0;
		private var acceleration:Number = 0;
		
		//properties
		public function get Autopilot():Boolean { return autopilot; }
		public function get Velocity():Number { return velocity; }
		
		public function Paddle() 
		{
			//graphic / hitbox
			if (Main.artOn)
				graphic = new Image(Resources.PADDLE);
			else
				graphic = Image.createRect(SIZE_X, SIZE_Y);
			setHitbox(SIZE_X, SIZE_Y);
			x = FP.halfWidth - SIZE_X/2;
			y = FP.height - SIZE_Y - 10;
			type = "paddle";
			
			//define movement keys
			Input.define("left", Key.A, Key.LEFT);
			Input.define("right", Key.D, Key.RIGHT);
		}
		
		override public function update():void 
		{
			acceleration = -FP.sign(velocity) * ACCELERATION; //accelerate opposite of velocity
				
			input();
			movement();
		}
		
		private function input():void 
		{
			if (autopilot) //automate movement
			{
				if (Game.ball.centerX + 10 < centerX) //ball left of paddle
					acceleration = -ACCELERATION;
				else if (Game.ball.centerX - 10 > centerX) //ball right of paddle
					acceleration = ACCELERATION;
			}
			else //key movement
			{
				if (Input.check("left")) acceleration = -ACCELERATION;
				if (Input.check("right")) acceleration = ACCELERATION;
			}
		}
		
		private function movement():void 
		{
			if (FP.sign(velocity) == -FP.sign(velocity + acceleration))
				velocity = 0; //if slowing to a stop, stop
			else
				velocity += acceleration; //add accel to velocity
			
			//keep velocity within limits
			if (velocity > MAX_SPEED)
				velocity = MAX_SPEED;
			else if (velocity < -MAX_SPEED)
				velocity = -MAX_SPEED;
				
			x += velocity * FP.elapsed; //update position
			
			//keep paddle on screen
			if (right > FP.width)
			{
				x = FP.width - SIZE_X;
				velocity = 0;
			}
			else if (left < 0)
			{
				x = 0;
				velocity = 0;
			}
		}
		
		public function toggleAutopilot():void 
		{
			autopilot = !autopilot;
		}
	}
}