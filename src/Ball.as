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
		private const HOVER_SPEED:Number = 80;
		
		//vars
		public var velX:Number = 0;
		public var velY:Number = 0;
		public var hoverVel:Number = 0;
		public var hoverOffset:Number = 0;
		public var hoveringRight:Boolean = true;
		public var bounceOffBottom:Boolean = false;
		
		public function Ball(x:int=0, y:int=0) 
		{
			this.x = x;
			this.y = y;
			graphic = new Image(Resources.BALL);
			setHitbox(SIZE, SIZE);
			type = "ball";
		}
		
		override public function update():void 
		{
			//TEST CASE
			//if (Input.pressed(Key.Q))
			//{
				//x = 1;
				//y = 200;
				//velX = -55;
				//velY = calcYVelocity();
			//}
			
			movementAndCollision();
		}
		
		private function movementAndCollision():void 
		{
			var newX:Number = x + velX * FP.elapsed;
			var newY:Number = y + velY * FP.elapsed;
			
			//{game walls collision
			if (newY < 0) //top
			{
				newY = 0;
				//velY = -velY;
				bounce(false, true);
			}
			if (newY + height > FP.height) //bot
			{
				if (bounceOffBottom)
				{
					newY = FP.height - height;
					//velY = -velY;
				bounce(false, true);
				}
				else
					destroy();
			}
			if (newX < 0) //left
			{
				newX = 0;
				//velX = -velX;
				bounce(true, false);
			}
			if (newX + width > FP.width) //right
			{
				newX = FP.width - width;
				//velX = -velX;
				bounce(true, false);
			}
			//}
			
			//paddle collision (special case)
			if (collide("paddle", newX, newY))
				paddleBounce();
				
			//{ other collision
			var entity:Entity = collideTypes(["ball", "menu", "brick"], newX, newY);
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
						
					bounce(true, false);
				}
				else if (!collideWith(entity, newX, y) && collideWith(entity, x, newY)) //vertical only
				{
					//set up against entity border
					if (FP.sign(velY) > 0) //is top of
						newY = entity.top - height;
					else //is bottom of
						newY = entity.bottom + 1;
						
					bounce(false, true);
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
						
					bounce(true, true);
				}
				
				//BRICKS MUST DIE
				if (entity.type == "brick")
					Brick(entity).destroy();
					
				//grab new colliding entity
				entity = collideTypes(["button", "ball", "menu", "brick"], newX, newY);
			}
			//}
				
			//update position
			x = newX;
			y = newY;
		}
		
		public function hoverOverPaddle():void 
		{
			x = Game.paddle.centerX - width / 2;
			y = Game.paddle.top - height - 10;
			hoverOffset = 0;
		}
		
		public function patrolPaddle():void 
		{
			FP.console.log(hoverOffset);
			//hoverOffset += hoverVel;
			if (hoveringRight)
			{
				if (hoverOffset + HOVER_SPEED * FP.elapsed > Game.paddle.width / 2 - width / 2)
				{
					hoverOffset = Game.paddle.width / 2 - width / 2;
					hoveringRight = false;
				}
				else
					hoverOffset += HOVER_SPEED * FP.elapsed;
			}
			else
			{
				if (hoverOffset - HOVER_SPEED * FP.elapsed < -Game.paddle.width / 2 + width / 2)
				{
					hoverOffset = -Game.paddle.width / 2 + width / 2;
					hoveringRight = true;
				}
				else
					hoverOffset -= HOVER_SPEED * FP.elapsed;
			}
			
			x = Game.paddle.centerX - width / 2 + hoverOffset;
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
			//velX = FP.sign(FP.random - .5) * Util.rand(MIN_AXIS_SPEED, MAX_AXIS_SPEED);
			//velY = -calcYVelocity();
			paddleBounce();
		}
		
		public function fireRandomDirection():void 
		{
			velX = FP.sign(FP.random - .5) * Util.rand(MIN_AXIS_SPEED, MAX_AXIS_SPEED); //MIN_ANGLE
			velY = FP.sign(FP.random - .5) * calcYVelocity();
		}
		
		//bouncing off of non-moving object
		public function bounce(collisionX:Boolean, collisionY:Boolean):void
		{
			var newVelocities:Array;
			
			if (collisionX && collisionY)
			{
				velX = -velX;
				velY = -velY;
			}
			else if (collisionX)
			{
				newVelocities = calculateBounceVelocities(velX, velY);
				velX = -FP.sign(velX) * newVelocities[0];
				velY = FP.sign(velY) * newVelocities[1];
			}
			else if (collisionY)
			{
				newVelocities = calculateBounceVelocities(velY, velX);
				velY = -FP.sign(velY) * newVelocities[0];
				velX = FP.sign(velX) * newVelocities[1];
			}
			else
				return; //no collision
			
		}
		
		//takes in axis velocities and returns array of new axis velocities
		private function calculateBounceVelocities(velOpposite:Number, velAdjacent:Number):Array 
		{
			//calculate angle of departure with angle of entry
			var oldAngle:Number = Math.atan(velOpposite / velAdjacent);
			var newAngle:Number = (Math.PI) - Math.abs(oldAngle);
			
			//calculate velocity with old axis velocities
			var velocity:Number = Math.sqrt(Math.pow(velOpposite, 2) + Math.pow(velAdjacent, 2));
			
			//calculate axis velocities with new angle and velocity
			var axisVelocities:Array = new Array(2);
			axisVelocities[0] = Math.abs(Math.sin(newAngle) * velocity);
			axisVelocities[1] = Math.abs(Math.cos(newAngle) * velocity);
			
			return axisVelocities;
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