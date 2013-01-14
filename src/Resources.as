package  
{

	public class Resources 
	{
		//font
		[Embed(source = "../res/Opificio_rounded.ttf", embedAsCFF = "false", fontFamily = "opificio")] public static const FONT_FILE:Class;
		public static const FONT:String = "opificio";
		
		//main menu
		[Embed(source = "../res/menuBG.png")] public static const MENU_BG:Class;
		[Embed(source = "../res/mainMenuSeperator.png")] public static const MAIN_MENU_SEPERATOR:Class;
		
		//game
		[Embed(source = "../res/bg.png")] public static const BG:Class;
		[Embed(source = "../res/paddle.png")] public static const PADDLE:Class;
		[Embed(source = "../res/ball.png")] public static const BALL:Class;
		[Embed(source = "../res/brick.png")] public static const BRICK:Class;
		
		//icons
		[Embed(source = "../res/icons/icon_ball.png")] public static const ICON_BALL:Class;
		[Embed(source = "../res/icons/icon_sound_off.png")] public static const ICON_SOUND_OFF:Class;
		[Embed(source = "../res/icons/icon_sound_on.png")] public static const ICON_SOUND_ON:Class;
		[Embed(source = "../res/icons/icon_music_off.png")] public static const ICON_MUSIC_OFF:Class;
		[Embed(source = "../res/icons/icon_music_on.png")] public static const ICON_MUSIC_ON:Class;
		[Embed(source = "../res/icons/icon_pause.png")] public static const ICON_PAUSE:Class;
		
		//pause
		[Embed(source = "../res/pauseBG.png")] public static const PAUSE_BG:Class;
	}
}