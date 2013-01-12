package  
{
	import flash.events.Event;
	import gui.*;
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.graphics.*;
	
	public class Menu extends World
	{
		public function Menu() 
		{
			//title
			var title:Button = new Button(5, 0);
			title.createText("breakout", 70, Resources.FONT);
			add(title);
			
			//continue
			var con:Button = new Button(40, 100);
			con.createText("continue", 35, Resources.FONT);
			//con.onMouseOver(makeTextBig);
			con.onClick(newGame);
			add(con);
			
			//options
			var options:Button = new Button(40, 150);
			options.createText("options", 35, Resources.FONT);
			options.onClick(newGame);
			add(options);
			
			//credits
			var credits:Button = new Button(40, 200);
			credits.createText("credits", 35, Resources.FONT);
			credits.onClick(newGame);
			add(credits);
			
			//buttons
			var startButton:Button = new Button(100, 100);
			startButton.createGraphic("Start");
			startButton.onClick(newGame);
			add(startButton);
			
			//fire some balls around
			//var balls:Array = new Array();
			//for (var i:int = 0; i < 10; i++)
			//{
				//var ball:Ball = new Ball(FP.halfWidth, FP.halfHeight);
				//ball.fireRandomDirection();
				//ball.bounceOffBottom = true;
				//add(ball);
				//balls.push(ball);
			//}
		}
		
		
		override public function update():void
		{
			super.update();
			
			if (Input.pressed(Key.SPACE))
				newGame();
		}
		
		//{ event handlers
		public function newGame():void 
		{
			FP.world = new Game();
		}
		
		//private function makeTextBig(b:Button):void 
		//{
			//b.setTextSize(50);
		//}
		//}
	}
}