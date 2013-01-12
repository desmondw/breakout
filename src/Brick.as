package  
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.Image;

	public class Brick extends Entity
	{
		public static const SIZE_X:int = 90;
		public static const SIZE_Y:int = 20;
		
		public function Brick(x:int, y:int, color:uint) 
		{
			var img:Image;
			if (Main.artOn)
				img = new Image(Resources.BRICK);
			else
				img = Image.createRect(SIZE_X, SIZE_Y);
			
			if (color)
				img.color = color;
			graphic = img;
			setHitbox(SIZE_X, SIZE_Y);
			type = "brick";
			
			this.x = x;
			this.y = y;
		}
		
		override public function update():void 
		{
			
		}
		
		public function destroy():void
		{
			FP.world.remove(this);
		}
	}
}