package  
{
	import gui.*;
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.graphics.*;

	public class PauseMenu extends Entity
	{
		public var continueBtn:Button;
		public var mainMenuBtn:Button;
		
		public function PauseMenu() 
		{
			var img:Image = new Image(Resources.PAUSE_BG);
			x = (FP.width - img.width) / 2;
			y = (FP.height - img.height) / 2;
			graphic = img;
			setHitbox(img.width, img.height);
			
			continueBtn = new Button(x + (width - Button.DEFAULT_WIDTH) / 2, y + 50);
			continueBtn.createGraphic("continue");
			continueBtn.onClick(continueBtn_onClick);
			
			mainMenuBtn = new Button(x + (width - Button.DEFAULT_WIDTH) / 2, y + 100);
			mainMenuBtn.createGraphic("main menu");
			mainMenuBtn.onClick(mainMenuBtn_onClick);
			
			//define input
			Input.define("pause", Key.ESCAPE, Key.P);
		}
		
		override public function added():void 
		{
			world.add(continueBtn);
			world.add(mainMenuBtn);
		}
		
		override public function removed():void 
		{
			world.remove(continueBtn);
			world.remove(mainMenuBtn);
		}
		
		override public function update():void
		{
			//pause
			if (Input.pressed("pause"))
				unpause();
			
			continueBtn.update();
			mainMenuBtn.update();
		}
		
		private function continueBtn_onClick(b:Button):void 
		{
			unpause();
		}
		
		private function mainMenuBtn_onClick(b:Button):void 
		{
			FP.world = new Menu();
		}
		
		private function unpause():void 
		{
				world.remove(this);
				Game.paused = false;
		}
	}
}