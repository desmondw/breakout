package
{
	import net.flashpunk.*;
	import net.flashpunk.debug.*;
	import net.flashpunk.graphics.Text;
	
	public class Main extends Engine
	{
		public static var con:Console = new Console(); //debug console
		public static var artOn:Boolean = true;
		
		public function Main()
		{
			super(700, 500, 60, false);
			FP.world = new Menu();
		}

		override public function init():void
		{
			//con.enable();
			
			FP.screen.color = 0x7777FF;
		}
		
		override public function update():void 
		{
			super.update();
			con.update();
		}
	}
}