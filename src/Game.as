package  
{
	import gui.Fader;
	import layers.*;
	import layers.menus.*;
	
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.graphics.*;

	public class Game extends World
	{
		public static var paused:Boolean;			//tracks when the gameplay is paused
		
		//layers
		public var gameplayLayer:GameplayLayer;
		public var interfaceLayer:InterfaceLayer;
		
		//menus
		private var _pauseMenu:PauseMenu = new PauseMenu();
		
		//fading effect
		private var _fade:Fader = new Fader();
		
		public function Game() 
		{
			
		}
		
		/**
		 * Initialization after world set.
		 */
		override public function begin():void 
		{
			paused = false;
			
			gameplayLayer = new GameplayLayer(this);
			interfaceLayer = new InterfaceLayer(this);
			
			//fading effect
			_fade.fadeIn(2);
			add(_fade);
			
			//define input
			Input.define("pause", Key.ESCAPE, Key.P);
		}
		
		override public function update():void
		{
			//if paused, handle pause specific-behavior ONLY
			if (paused)
			{
				_pauseMenu.update();
				return;
			}
			
			//update world and entities
			super.update();
			
			input();
			
			//update layers
			interfaceLayer.update();
			gameplayLayer.update();
		}
		
		/**
		 * Handles user input.
		 */
		private function input():void 
		{
			//pause
			if (Input.pressed("pause"))
				pause();
		}
		
		/**
		 * Pauses the game, bringing up the pause menu and disabling updates for the world.
		 */
		public function pause():void 
		{
			add(_pauseMenu);
			Game.paused = true;
		}
		
		/**
		 * Displays lose menu.
		 */
		public function lose():void 
		{
			Registry.menu = new Menu();
			FP.world = Registry.menu
		}
		
		/**
		 * Displays win menu.
		 */
		public function win():void 
		{
			Registry.menu = new Menu();
			FP.world = Registry.menu
		}
	}
}