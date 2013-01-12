package  
{
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.graphics.Image;

	public class Ball extends Entity
	{
		//constants
		private const SIZE:int = 14;
		private const SPEED:Number = 400; //constant speed of ball  --TODO: change speed based on where ball hits paddle
		private const MIN_ANGLE:Number = .15; //minimum angle the ball can travel to an axis
		private const MAX_AXIS_SPEED:Number = SPEED * (1 - MIN_ANGLE); //max speed on one axis
		private const MIN_AXIS_SPEED:Number = SPEED * MIN_ANGLE; //min speed on one axis
		
		//vars
		public var velX:Number = 0;
		public var velY:Number = 0;
		public var bounceOffBottom:Boolean = false;
		
		public function Ball(x:int=0, y:int=0) 
		{
			this.x = x;
			this.y = y;
			if (Main.artOn)
				graphic = new Image(Resources.BALL);
			else
				graphic = Image.createRect(SIZE, SIZE);
			setHitbox(SIZE, SIZE);
			type = "ball";
		}
		
		override public function update():void 
		{
			//test case
			if (Input.released(Key.SHIFT))
			{
				x = FP.width - 100;
				y = FP.height - 100;
				velX = 20;
				velY = -calcYVelocity();
			}
			
			movementAndCollision();
		}
		
		private function movementAndCollision():void 
		{
			var newX:int = x + velX * FP.elapsed;
			var newY:int = y + velY * FP.elapsed;
			var newXFloat:Number = x + Math.ceil(velX * FP.elapsed);
			var newYFloat:Number = y + Math.ceil(velY * FP.elapsed);
			
			//{game walls collision
			if (newYFloat < 0) //top
			{
				newY = 0;
				velY = -velY;
			}
			if (newYFloat + height > FP.height) //bot
			{
				if (bounceOffBottom)
				{
					newY = FP.height - height;
					velY = -velY;
				}
				else
					destroy();
			}
			if (newXFloat < 0) //left
			{
				newX = 0;
				velX = -velX;
			}
			if (newXFloat + width > FP.width) //right
			{
				newX = FP.width - width;
				velX = -velX;
			}
			//}
			
			//paddle collision (special case)
			if (collide("paddle", newX, newY))
				paddleBounce();
				
			//{ other collision
			var entity:Entity = collideTypes(["button", "ball", "menu", "brick"], newX, newY);
			var velModX:int = 1;
			var velModY:int = 1;
			
			while(entity) //if colliding
			{
				if (collideWith(entity, newX, y) && !collideWith(entity, x, newY)) //horizontal only
				{
					//set up against entity border
					if (FP.sign(velX) > 0) //is left of
						newX = entity.left - width;
					else //is right of
						newX = entity.right + 1;
						
					//flip velocity
					velModX = -1;
				}
				else if (!collideWith(entity, newX, y) && collideWith(entity, x, newY)) //vertical only
				{
					//set up against entity border
					if (FP.sign(velY) > 0) //is top of
						newY = entity.top - height;
					else //is bottom of
						newY = entity.bottom + 1;
						
					//flip velocity
					velModY = -1
				}
				else //horizontal and vertical collision
				{
					//set up against entity border
					if (FP.sign(velX) > 0) //is left of
						newX = entity.left - width;
					else //is right of
						newX = entity.right + 1;
						
					if (FP.sign(velY) > 0) //is top of
						newY = entity.top - height;
					else //is bottom of
						newY = entity.bottom + 1;
						
					//flip velocity
					velModX = -1;
					velModY = -1
				}
				
				//BRICKS MUST DIE
				if (entity.type == "brick")
					Brick(entity).destroy();
					
				//grab new colliding entity
				entity = collideTypes(["button", "ball", "menu", "brick"], newX, newY);
			}
			
			//flip velocity as needed
			velX *= velModX;
			velY *= velModY;
			
			//}
				
			//update position
			x = newX;
			y = newY;
		}
		
		public function hoverOverPaddle():void 
		{
			x = Game.paddle.centerX - width / 2;
			y = Game.paddle.top - height - 10;
		}
		
		//given the x velocity and the speed (constant), get the y velocity
		private function calcYVelocity():Number
		{
			return Math.sqrt(Math.pow(SPEED, 2) - Math.pow(Math.abs(velX), 2));
		}
		
		//fire from paddle with random upward direction}
		public function fireFromPaddle():void 
		{
			velX = FP.sign(FP.random - .5) * Util.rand(MIN_AXIS_SPEED, MAX_AXIS_SPEED);
			velY = -calcYVelocity();
		}
		
		public function fireRandomDirection():void 
		{
			velX = FP.sign(FP.random - .5) * Util.rand(MIN_AXIS_SPEED, MAX_AXIS_SPEED); //MIN_ANGLE
			velY = FP.sign(FP.random - .5) * calcYVelocity();
		}
		
		//special handling for player control over ball
		public function paddleBounce():void
		{
			var offsetFromPaddle:int = centerX - Game.paddle.centerX;
			var speedPerPixel:Number = MAX_AXIS_SPEED / (Game.paddle.width / 2);
			var dirVel:Number = offsetFromPaddle * speedPerPixel;
			
			//tweak x velocity based on spot hit
			//velX = dirVel;
			
			//set x velocity based on spot hit
			//velX = dirVel;
			
			//tweak x velocity based on paddle velocity
			//velX = Game.paddle.Velocity;
			
			//tweak x velocity based on paddle velocity and spot hit
			//velX = (Game.paddle.Velocity + dirVel) / 2;
			
			//new velocity based on spot hit (major) and ball velocity (minor) ONLY if not hit in center
			if (dirVel != 0)
				velX = dirVel * .7 + velX * .3;
			
			//keep speed within limits
			if (velX < -MAX_AXIS_SPEED)
				velX = -MAX_AXIS_SPEED;
			if (velX > MAX_AXIS_SPEED)
				velX = MAX_AXIS_SPEED;
			
			velY = -calcYVelocity();
		}
		
		public function destroy():void
		{
			FP.world.remove(this);
		}
	}
}