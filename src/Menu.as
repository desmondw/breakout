package  
{
	import flash.events.Event;
	import gui.*;
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.graphics.*;
	
	public class Menu extends World
	{
		private const BUTTON_SIZE:int = 30;
		private const BUTTON_SIZE_SELECTED:int = 45;
		private const BUTTON_SPACING:int = 7 + BUTTON_SIZE;
		
		private const LIST_X:int = 40;
		private const LIST_Y:int = 100;
		
		public function Menu() 
		{
			//title
			var titleBtn:Button = new Button(10, 7);
			titleBtn.createText("breakout", 70, Resources.FONT);
			adjustHitbox(titleBtn);
			add(titleBtn);
			
			//title
			var seperatorBtn:Button = new Button(0, 80);
			var seperatorImg:Image = new Image(Resources.MAIN_MENU_SEPERATOR);
			seperatorBtn.setGraphic(seperatorImg, seperatorImg.width, seperatorImg.height);
			add(seperatorBtn);
			
			//continue
			var continueBtn:Button = new Button(LIST_X, LIST_Y);
			continueBtn.createText("continue", 30, Resources.FONT);
			continueBtn.onClick(continueBtn_onClick);
			continueBtn.onMouseOver(buttonMouseOver);
			continueBtn.onMouseStray(buttonMouseStray);
			adjustHitbox(continueBtn);
			add(continueBtn);
			
			//levels
			var levelsBtn:Button = new Button(LIST_X, LIST_Y + BUTTON_SPACING);
			levelsBtn.createText("levels", 30, Resources.FONT);
			levelsBtn.onClick(levelsBtn_onClick);
			levelsBtn.onMouseOver(buttonMouseOver);
			levelsBtn.onMouseStray(buttonMouseStray);
			adjustHitbox(levelsBtn);
			add(levelsBtn);
			
			//options
			var optionsBtn:Button = new Button(LIST_X, LIST_Y + BUTTON_SPACING * 2);
			optionsBtn.createText("options", 30, Resources.FONT);
			optionsBtn.onClick(optionsBtn_onClick);
			optionsBtn.onMouseOver(buttonMouseOver);
			optionsBtn.onMouseStray(buttonMouseStray);
			adjustHitbox(optionsBtn);
			add(optionsBtn);
			
			//credits
			var creditsBtn:Button = new Button(LIST_X, LIST_Y + BUTTON_SPACING * 3);
			creditsBtn.createText("credits", 30, Resources.FONT);
			creditsBtn.onClick(creditsBtn_onClick);
			creditsBtn.onMouseOver(buttonMouseOver);
			creditsBtn.onMouseStray(buttonMouseStray);
			adjustHitbox(creditsBtn);
			add(creditsBtn);
		}
		
		override public function update():void
		{
			super.update();
			
			if (Input.pressed(Key.SPACE))
				FP.world = new Game();
		}
		
		private function fireRandomBalls():void 
		{
			var balls:Array = new Array();
			for (var i:int = 0; i < 10; i++)
			{
				var ball:Ball = new Ball(FP.halfWidth, FP.halfHeight);
				ball.fireRandomDirection();
				ball.bounceOffBottom = true;
				add(ball);
				balls.push(ball);
			}
		}
		
		private function adjustHitbox(button:Button):void 
		{
			button.graphic.y -= button.height * (1 - .8) / 2;
			button.width *= .84;
			button.height *= .78;
		}
		
		//{ event handlers
		private function continueBtn_onClick(b:Button):void 
		{
			FP.world = new Game();
		}
		
		private function levelsBtn_onClick(b:Button):void 
		{
			
		}
		
		private function optionsBtn_onClick(b:Button):void 
		{
			
		}
		
		private function creditsBtn_onClick(b:Button):void 
		{
			
		}
		
		private function buttonMouseOver(b:Button):void 
		{
			var oldCenterY:int = b.centerY;
			b.setTextSize(BUTTON_SIZE_SELECTED);
			adjustHitbox(b);
			b.y += oldCenterY - b.centerY;
		}
		
		private function buttonMouseStray(b:Button):void 
		{
			var oldCenterY:int = b.centerY;
			b.setTextSize(BUTTON_SIZE);
			adjustHitbox(b);
			b.y += oldCenterY - b.centerY;
		}
		//}
	}
}