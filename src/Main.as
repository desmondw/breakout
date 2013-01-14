package
{
	import net.flashpunk.*;
	import net.flashpunk.debug.*;
	import net.flashpunk.graphics.Text;
	
	public class Main extends Engine
	{
		public static var soundVol:Number = .7;
		public static var musicVol:Number = .7;
		public static var soundOn:Boolean = true;
		public static var musicOn:Boolean = true;
		
		public function Main()
		{
			super(700, 500, 60, false);
			FP.world = new Menu();
		}

		override public function init():void
		{
			//FP.console.enable();
			FP.screen.color = 0x7777FF;
		}
		
		override public function update():void 
		{
			super.update();
		}
	}
}