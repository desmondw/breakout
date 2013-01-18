package  
{
	import gui.*;
	
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.graphics.*;
	
	/**
	 * Full screen title menu. Seperate Flashpunk world from the game.
	 */
	public class Menu extends World
	{
		//button size and positioning
		private const BUTTON_SIZE:int = 30;						//size of button text normally
		private const BUTTON_SIZE_SELECTED:int = 45;			//size of button text when selected
		private const BUTTON_SPACING:int = 7 + BUTTON_SIZE;		//space between buttons
		
		//location of menu lists
		private const LIST_X:int = 40;
		private const LIST_Y:int = 100;
		
		//menu lists that hold displayed buttons
		private var _mainList:Array = new Array();
		private var _levelsList:Array = new Array();
		private var _optionsList:Array = new Array();
		
		private var _fade:Fader = new Fader();		//whole screen _fade effect
		
		private var _levels:Array = new Array("old school", "level 2", "level 3");	//names of _levels
		
		public function Menu() 
		{
			
		}
		
		override public function begin():void 
		{
			//{ CONSTANT GRAPHICS
			
			//background
			var bg:Entity = new Entity(0, 0, new Image(Resources.MENU_BG));
			add(bg);
			
			//seperator
			var seperator:Entity = new Entity(0, 80, new Image(Resources.MAIN_MENU_SEPERATOR));
			add(seperator);
			
			//}
			
			//{ MENU LISTS
			
			//{{ MAIN
			
			var button:TextButton;
			
			//title
			button = new TextButton(10, 7, "breakout", 70, Resources.FONT);
			button.adjustHitbox();
			add(button);
			_mainList.push(button);
			
			//continue
			button = new TextButton(LIST_X, LIST_Y, "play", 30, Resources.FONT);
			button.onClick(continueBtn_onClick);
			_mainList.push(button);
			
			//_levels
			//button = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING, "_levels", 30, Resources.FONT);
			//button.onClick(levelsBtn_onClick);
			//_mainList.push(button);
			
			//options
			button = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 1, "options", 30, Resources.FONT);
			button.onClick(optionsBtn_onClick);
			_mainList.push(button);
			
			//credits
			button = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 2, "credits", 30, Resources.FONT);
			button.onClick(creditsBtn_onClick);
			_mainList.push(button);
			
			//add graphics for mousing over and add to world
			for (var i:int = 1; i < _mainList.length; i++)
			{
				_mainList[i].onMouseOver(buttonMouseOver);
				_mainList[i].onMouseStray(buttonMouseStray);
				_mainList[i].adjustHitbox();
				add(_mainList[i]);
			}
			
			//}}
			
			//{{ LEVELS
			//title
			_levelsList[0] = new TextButton(10, 7, "_levels", 70, Resources.FONT);
			_levelsList[0].adjustHitbox();
			add(_levelsList[0]);
			
			//1
			_levelsList[1] = new TextButton(LIST_X, LIST_Y, _levels[0], 30, Resources.FONT);
			_levelsList[1].onClick(levelList_onClick);
			
			//2
			_levelsList[2] = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING, _levels[1], 30, Resources.FONT);
			_levelsList[2].onClick(levelList_onClick);
			
			//3
			_levelsList[3] = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 2, _levels[2], 30, Resources.FONT);
			_levelsList[3].onClick(levelList_onClick);
			
			//back
			_levelsList[4] = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 3, "back", 30, Resources.FONT);
			_levelsList[4].onClick(levelList_onClick);
			
			//add graphics for mousing over and add to world
			for (var i:int = 1; i < _levelsList.length; i++)
			{
				_levelsList[i].onMouseOver(buttonMouseOver);
				_levelsList[i].onMouseStray(buttonMouseStray);
				_levelsList[i].adjustHitbox();
				add(_levelsList[i]);
			}
			//}}
			
			//{{ OPTIONS
			
			//title
			button = new TextButton(10, 7, "options", 70, Resources.FONT);
			button.adjustHitbox();
			add(button);
			_optionsList.push(button);
			
			//sound
			if (Main.soundOn)
				button = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 0, "sound: on", 30, Resources.FONT);
			else
				button = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 0, "sound: off", 30, Resources.FONT);
			button.onClick(soundBtn_onClick);
			_optionsList.push(button);
			
			//music
			if (Main.musicOn)
				button = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 1, "music: on", 30, Resources.FONT);
			else
				button = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 1, "music: off", 30, Resources.FONT);
			button.onClick(musicBtn_onClick);
			_optionsList.push(button);
			
			//back
			button = new TextButton(LIST_X, LIST_Y + BUTTON_SPACING * 2, "back", 30, Resources.FONT);
			button.onClick(backBtn_onClick);
			_optionsList.push(button);
			
			//add graphics for mousing over and add to world
			for (var i:int = 1; i < _optionsList.length; i++)
			{
				_optionsList[i].onMouseOver(buttonMouseOver);
				_optionsList[i].onMouseStray(buttonMouseStray);
				_optionsList[i].adjustHitbox();
				add(_optionsList[i]);
			}
			//}}
			
			//}
			
			showList("main"); //display main list and hide others
			
			//_fade into screen at start
			_fade.fadeIn(2);
			add(_fade);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		/**
		 * Starts a new game.
		 */
		private function newGame():void 
		{
			Registry.game = new Game();
			FP.world = Registry.game;
		}
		
		/**
		 * Changes the active menu as specified.
		 * @param	list		Name of menu to make active.
		 */
		private function showList(list:String):void 
		{
			//enable/disable main menu buttons
			for each (var button:Button in _mainList)
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
			
			//enable/disable level menu buttons
			for each (var button:Button in _levelsList)
			{
				if (list == "_levels")
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
			
			//enable/disable credit menu buttons
			for each (var button:Button in _optionsList)
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
		
		//{ EVENT HANDLERS
		
		/**
		 * Loads last level played.
		 * @param	button		Button that triggered the event.
		 */
		private function continueBtn_onClick(button:TextButton):void 
		{
			_fade.fadeOut(.5, newGame);
		}
		
		/**
		 * Displays the _levels menu.
		 * @param	button		Button that triggered the event.
		 */
		private function levelsBtn_onClick(button:TextButton):void 
		{
			showList("_levels");
		}
		
		/**
		 * Displays the options menu.
		 * @param	button		Button that triggered the event.
		 */
		private function optionsBtn_onClick(button:TextButton):void 
		{
			showList("options");
		}
		
		/**
		 * Displays the credits screen.
		 * @param	button		Button that triggered the event.
		 */
		private function creditsBtn_onClick(button:TextButton):void 
		{
			
		}
		
		/**
		 * Starts a new game of the selected level.
		 * @param	button		Button that triggered the event.
		 */
		private function levelList_onClick(button:TextButton):void 
		{
			switch (button.text)
			{
				case _levels[0]:
					//newGame();
				break;
				
				case _levels[1]:
					//newGame();
				break;
				
				case _levels[2]:
					//newGame();
				break;
				
				case "back":
					showList("main");
				break;
			}
		}
		
		/**
		 * Returns to a higher level in the menu.
		 * @param	button		Button that triggered the event.
		 */
		private function backBtn_onClick(button:TextButton):void 
		{
			showList("main");
		}
		
		/**
		 * Toggles game sound.
		 * @param	button		Button that triggered the event.
		 */
		private function soundBtn_onClick(button:TextButton):void 
		{
			if (Main.soundOn)
				button.text = "sound: off";
			else
				button.text = "sound: on";
			
			Main.soundOn = !Main.soundOn;
		}
		
		/**
		 * Toggles game music.
		 * @param	button		Button that triggered the event.
		 */
		private function musicBtn_onClick(button:TextButton):void 
		{
			if (Main.musicOn)
				button.text = "music: off";
			else
				button.text = "music: on";
			
			Main.musicOn = !Main.musicOn;
		}
		
		/**
		 * Increases text size of button.
		 * Fires when any button is moused over.
		 * @param	button		Button that triggered the event.
		 */
		private function buttonMouseOver(button:TextButton):void 
		{
			var oldCenterY:int = button.centerY;
			button.size = BUTTON_SIZE_SELECTED;
			button.adjustHitbox();
			button.y += oldCenterY - button.centerY;
		}
		
		/**
		 * Decreases text size of button.
		 * Fires when the mouse leaves the hitbox of any button.
		 * @param	button		Button that triggered the event.
		 */
		private function buttonMouseStray(button:TextButton):void 
		{
			var oldCenterY:int = button.centerY;
			button.size = BUTTON_SIZE;
			button.adjustHitbox();
			button.y += oldCenterY - button.centerY;
		}
		
		//}
	}
}