package  
{

	public class Resources 
	{
		//font
		[Embed(source = "../res/Opificio_rounded.ttf", embedAsCFF = "false", fontFamily = "opificio")] public static const FONT_FILE:Class;
		public static const FONT:String = "opificio";
		
		//main menu
		[Embed(source = "../res/mainMenuSeperator.png")] public static const MAIN_MENU_SEPERATOR:Class;
		
		//game
		[Embed(source = "../res/bg.png")] public static const BG:Class;
		[Embed(source = "../res/paddle.png")] public static const PADDLE:Class;
		[Embed(source = "../res/ball.png")] public static const BALL:Class;
		[Embed(source = "../res/brick.png")] public static const BRICK:Class;
		
		//pause
		[Embed(source = "../res/pauseBG.png")] public static const PAUSE_BG:Class;
	}
}