package
{
	import net.flashpunk.*;
	import net.flashpunk.debug.*;
	import net.flashpunk.graphics.Text;
	
	public class Main extends Engine
	{
		public static const SCREEN_WIDTH:int = 700;
		public static const SCREEN_HEIGHT:int = 500;
		
		public static var soundVol:Number = 1;
		public static var musicVol:Number = 1;
		public static var soundOn:Boolean = true;
		public static var musicOn:Boolean = true;
		
		public function Main()
		{
			super(SCREEN_WIDTH, SCREEN_HEIGHT, 60, false);
			Registry.menu = new Menu();
			FP.world = Registry.menu;
		}

		override public function init():void
		{
			//FP.console.enable();
			FP.screen.color = 0x7777FF;
		}
	}
}