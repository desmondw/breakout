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
			//title
			mainList[0] = new Button(10, 7);
			mainList[0].createText("breakout", 70, Resources.FONT);
			adjustHitbox(mainList[0]);
			add(mainList[0]);
			
			//continue
			mainList[1] = new Button(LIST_X, LIST_Y);
			mainList[1].createText("continue", 30, Resources.FONT);
			mainList[1].onClick(continueBtn_onClick);
			
			//levels
			mainList[2] = new Button(LIST_X, LIST_Y + BUTTON_SPACING);
			mainList[2].createText("levels", 30, Resources.FONT);
			mainList[2].onClick(levelsBtn_onClick);
			
			//options
			mainList[3] = new Button(LIST_X, LIST_Y + BUTTON_SPACING * 2);
			mainList[3].createText("options", 30, Resources.FONT);
			mainList[3].onClick(optionsBtn_onClick);
			
			//credits
			mainList[4] = new Button(LIST_X, LIST_Y + BUTTON_SPACING * 3);
			mainList[4].createText("credits", 30, Resources.FONT);
			mainList[4].onClick(creditsBtn_onClick);
			
			//add graphics for mousing over and add to world
			for (var i:int = 1; i < mainList.length; i++)
			{
				mainList[i].onMouseOver(buttonMouseOver);
				mainList[i].onMouseStray(buttonMouseStray);
				adjustHitbox(mainList[i]);
				add(mainList[i]);
			}
			//}
			
			//{ LEVELS
			//title
			levelsList[0] = new Button(10, 7);
			levelsList[0].createText("levels", 70, Resources.FONT);
			adjustHitbox(levelsList[0]);
			add(levelsList[0]);
			
			//1
			levelsList[1] = new Button(LIST_X, LIST_Y);
			levelsList[1].createText(levels[0], 30, Resources.FONT);
			levelsList[1].onClick(levelList_onClick);
			
			//2
			levelsList[2] = new Button(LIST_X, LIST_Y + BUTTON_SPACING);
			levelsList[2].createText(levels[1], 30, Resources.FONT);
			levelsList[2].onClick(levelList_onClick);
			
			//3
			levelsList[3] = new Button(LIST_X, LIST_Y + BUTTON_SPACING * 2);
			levelsList[3].createText(levels[2], 30, Resources.FONT);
			levelsList[3].onClick(levelList_onClick);
			
			//back
			levelsList[4] = new Button(LIST_X, LIST_Y + BUTTON_SPACING * 3);
			levelsList[4].createText("back", 30, Resources.FONT);
			levelsList[4].onClick(levelList_onClick);
			
			//add graphics for mousing over and add to world
			for (var i:int = 1; i < levelsList.length; i++)
			{
				levelsList[i].onMouseOver(buttonMouseOver);
				levelsList[i].onMouseStray(buttonMouseStray);
				adjustHitbox(levelsList[i]);
				add(levelsList[i]);
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
		private function adjustHitbox(button:Button):void 
		{
			button.graphic.y -= button.height * (1 - .8) / 2;
			button.width *= .84;
			button.height *= .78;
		}
		
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
					button.mouseStray();
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
					button.mouseStray();
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
					button.mouseStray();
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
		private function continueBtn_onClick(b:Button):void 
		{
			fade.fadeOut(.5, newGame);
		}
		
		private function levelsBtn_onClick(b:Button):void 
		{
			showList("levels");
		}
		
		private function optionsBtn_onClick(b:Button):void 
		{
			
		}
		
		private function creditsBtn_onClick(b:Button):void 
		{
			
		}
		
		//any level is clicked
		private function levelList_onClick(b:Button):void 
		{
			switch (b.buttonText.text)
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
		
		//any button is moused over
		private function buttonMouseOver(b:Button):void 
		{
			var oldCenterY:int = b.centerY;
			b.setTextSize(BUTTON_SIZE_SELECTED);
			adjustHitbox(b);
			b.y += oldCenterY - b.centerY;
		}
		
		//any button when cursor leaves
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