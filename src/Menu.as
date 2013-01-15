package  
{
	import flash.events.Event;
	import flash.utils.Dictionary;
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
		
		private var fade:Fader = new Fader();
		
		private var mainList:Array = new Array();
		private var levelsList:Array = new Array();
		private var optionsList:Array = new Array();
		
		private var levels:Array;
		
		public function Menu() 
		{
			//levels
			levels = new Array(
					"old school",
					"level 2",
					"level 3"
					);
			
			//{ STATIC
			//background
			var bgImg:Image = new Image(Resources.MENU_BG);
			var bg:Entity = new Entity(0, 0, bgImg);
			add(bg);
			
			//seperator
			var seperatorImg:Image = new Image(Resources.MAIN_MENU_SEPERATOR);
			var seperator:Entity = new Entity(0, 80, seperatorImg);
			add(seperator);
			//}
			
			//{ MAIN
			
			var button:TextButton;
			
			//title
			button = new TextButton(10, 7, "breakout", 70, Resources.FONT);
			button.adjustHitbox();
			add(button);
			mainList.push(button);
			
			//continue
			button = new TextButton(LIST_X, LIST_Y, "play", 30, Resources.FONT);
			button.onClick(continueBtn_onClick);
			mainList.push(button);
			
			//levels
			//button = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING, "levels", 30, Resources.FONT);
			//button.onClick(levelsBtn_onClick);
			//mainList.push(button);
			
			//options
			button = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 1, "options", 30, Resources.FONT);
			button.onClick(optionsBtn_onClick);
			mainList.push(button);
			
			//credits
			button = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 2, "credits", 30, Resources.FONT);
			button.onClick(creditsBtn_onClick);
			mainList.push(button);
			
			//add graphics for mousing over and add to world
			for (var i:int = 1; i < mainList.length; i++)
			{
				mainList[i].onMouseOver(buttonMouseOver);
				mainList[i].onMouseStray(buttonMouseStray);
				mainList[i].adjustHitbox();
				add(mainList[i]);
			}
			
			//}
			
			//{ LEVELS
			//title
			levelsList[0] = new TextButton(10, 7, "levels", 70, Resources.FONT);
			levelsList[0].adjustHitbox();
			add(levelsList[0]);
			
			//1
			levelsList[1] = new TextButton(LIST_X, LIST_Y, levels[0], 30, Resources.FONT);
			levelsList[1].onClick(levelList_onClick);
			
			//2
			levelsList[2] = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING, levels[1], 30, Resources.FONT);
			levelsList[2].onClick(levelList_onClick);
			
			//3
			levelsList[3] = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 2, levels[2], 30, Resources.FONT);
			levelsList[3].onClick(levelList_onClick);
			
			//back
			levelsList[4] = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 3, "back", 30, Resources.FONT);
			levelsList[4].onClick(levelList_onClick);
			
			//add graphics for mousing over and add to world
			for (var i:int = 1; i < levelsList.length; i++)
			{
				levelsList[i].onMouseOver(buttonMouseOver);
				levelsList[i].onMouseStray(buttonMouseStray);
				levelsList[i].adjustHitbox();
				add(levelsList[i]);
			}
			//}
			
			//{ OPTIONS
			
			//title
			button = new TextButton(10, 7, "options", 70, Resources.FONT);
			button.adjustHitbox();
			add(button);
			optionsList.push(button);
			
			//sound
			if (Main.soundOn)
				button = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 0, "sound: on", 30, Resources.FONT);
			else
				button = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 0, "sound: off", 30, Resources.FONT);
			button.onClick(soundBtn_onClick);
			optionsList.push(button);
			
			//music
			if (Main.musicOn)
				button = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 1, "music: on", 30, Resources.FONT);
			else
				button = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 1, "music: off", 30, Resources.FONT);
			button.onClick(musicBtn_onClick);
			optionsList.push(button);
			
			//back
			button = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 2, "back", 30, Resources.FONT);
			button.onClick(backBtn_onClick);
			optionsList.push(button);
			
			//add graphics for mousing over and add to world
			for (var i:int = 1; i < optionsList.length; i++)
			{
				optionsList[i].onMouseOver(buttonMouseOver);
				optionsList[i].onMouseStray(buttonMouseStray);
				optionsList[i].adjustHitbox();
				add(optionsList[i]);
			}
			//}
			
			showList("main"); //display main list first
			
			//fade in to menu screen
			fade.fadeIn(2);
			add(fade);
		}
		
		override public function update():void
		{
			super.update();
			
			if (Input.pressed(Key.SPACE))
				newGame();
		}
		
		//old graphic scene
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
		
		private function newGame():void 
		{
			 FP.world = new Game();
		}
		
		//alter text boxes to have appropriate hitboxes
		//private function adjustHitbox(button:Button):void 
		//{
			//button.graphic.y -= button.height * (1 - .8) / 2;
			//button.width *= .84;
			//button.height *= .78;
		//}
		
		//changes visible list
		private function showList(list:String):void 
		{
			for each (var button:Button in mainList)
			{
				if (list == "main")
				{
					button.visible = true;
					button.interactable = true;
				}
				else
				{
					button.visible = false;
					button.forceStray();
					button.interactable = false;
				}
			}
			for each (var button:Button in levelsList)
			{
				if (list == "levels")
				{
					button.visible = true;
					button.interactable = true;
				}
				else
				{
					button.visible = false;
					button.forceStray();
					button.interactable = false;
				}
			}
			for each (var button:Button in optionsList)
			{
				if (list == "options")
				{
					button.visible = true;
					button.interactable = true;
				}
				else
				{
					button.visible = false;
					button.forceStray();
					button.interactable = false;
				}
			}
		}
		
		//go up a level in the menu
		private function back():void 
		{
			showList("main");
		}
		
		//{ event handlers
		private function continueBtn_onClick(b:TextButton):void 
		{
			fade.fadeOut(.5, newGame);
		}
		
		private function levelsBtn_onClick(b:TextButton):void 
		{
			showList("levels");
		}
		
		private function optionsBtn_onClick(b:TextButton):void 
		{
			showList("options");
		}
		
		private function creditsBtn_onClick(b:TextButton):void 
		{
			
		}
		
		//any level is clicked
		private function levelList_onClick(b:TextButton):void 
		{
			switch (b.text)
			{
				case levels[0]:
					//newGame();
				break;
				
				case levels[1]:
					//newGame();
				break;
				
				case levels[2]:
					//newGame();
				break;
				
				case "back":
					back();
				break;
			}
		}
		
		private function backBtn_onClick(b:TextButton):void 
		{
			back();
		}
		
		private function soundBtn_onClick(b:TextButton):void 
		{
			if (Main.soundOn)
			{
				Main.soundOn = false;
				b.text = "sound: off";
			}
			else
			{
				Main.soundOn = true;
				b.text = "sound: on";
			}
		}
		
		private function musicBtn_onClick(b:TextButton):void 
		{
			if (Main.musicOn)
			{
				Main.musicOn = false;
				b.text = "music: off";
			}
			else
			{
				Main.musicOn = true;
				b.text = "music: on";
			}
		}
		
		//any button is moused over
		private function buttonMouseOver(b:TextButton):void 
		{
			var oldCenterY:int = b.centerY;
			b.setTextSize(BUTTON_SIZE_SELECTED);
			b.adjustHitbox();
			b.y += oldCenterY - b.centerY;
		}
		
		//any button when cursor leaves
		private function buttonMouseStray(b:TextButton):void 
		{
			var oldCenterY:int = b.centerY;
			b.setTextSize(BUTTON_SIZE);
			b.adjustHitbox();
			b.y += oldCenterY - b.centerY;
		}
		//}
	}
}