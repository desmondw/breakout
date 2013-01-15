package  
{
	import gui.*;
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.graphics.*;

	public class PauseMenu extends Entity
	{
		public var titleBtn:Button;
		public var continueBtn:Button;
		public var mainMenuBtn:Button;
		
		public var fade:Fader = new Fader();
		
		public function PauseMenu() 
		{
			var img:Image = new Image(Resources.PAUSE_BG);
			x = (FP.width - img.width) / 2;
			y = (FP.height - img.height) / 2;
			graphic = img;
			setHitbox(img.width, img.height);
			
			titleBtn = new Button(x + (width - Button.DEFAULT_WIDTH) / 2, y + 20);
			titleBtn.x = x + width / 2 - titleBtn.width / 2 - 60;
			titleBtn.createText("breakout", 50, Resources.FONT, 0x777777);
			titleBtn.adjustHitbox();
			
			continueBtn = new Button(x + (width - Button.DEFAULT_WIDTH) / 2, y + 105);
			continueBtn.x = x + width / 2 - continueBtn.width / 2 - 20;
			continueBtn.createText("continue", 30, Resources.FONT, 0x999999);
			continueBtn.onClick(continueBtn_onClick);
			continueBtn.adjustHitbox();
			
			mainMenuBtn = new Button(x + (width - Button.DEFAULT_WIDTH) / 2, y + 155);
			mainMenuBtn.x = x + width / 2 - mainMenuBtn.width / 2 - 40;
			mainMenuBtn.createText("main menu", 30, Resources.FONT, 0xBBBBBB);
			mainMenuBtn.onClick(mainMenuBtn_onClick);
			mainMenuBtn.adjustHitbox();
			
			//define input
			Input.define("pause", Key.ESCAPE, Key.P);
			
			fade.forceEnd();
		}
		
		override public function added():void 
		{
			world.add(titleBtn);
			world.add(continueBtn);
			world.add(mainMenuBtn);
			world.add(fade);
		}
		
		override public function removed():void 
		{
			world.remove(titleBtn);
			world.remove(continueBtn);
			world.remove(mainMenuBtn);
			world.remove(fade);
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
			fade.fadeOut(.5, menu);
		}
		
		private function menu():void 
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