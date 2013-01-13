package gui
{
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.graphics.*;

	public class Button extends Entity
	{
		public static const DEFAULT_WIDTH:int = 80;
		public static const DEFAULT_HEIGHT:int = 45;
		public static const DEFAULT_BORDER:int = 5;
		
		private var downEvent:Function; //mouse pressed down
		private var upEvent:Function; //mouse released
		private var hoverEvent:Function; //mouse moves over button
		private var strayEvent:Function; //mouse leaves button
		
		private var normalGraphic:Graphic;
		private var hoverGraphic:Graphic;
		private var downGraphic:Graphic;
		
		private var text:Text;
		private var mouseHovering:Boolean = false;
		
		//properties
		public function get buttonText():Text{ return text; }
		
		
		public function Button(x:int=0, y:int=0) 
		{
			this.x = x;
			this.y = y;
			type = "button";
			createGraphic();
			text = new Text("");
		}
		
		override public function update():void 
		{
			if (collidePoint(x, y, Input.mouseX, Input.mouseY)) //if mouse over button
			{
				if (Input.mousePressed && downEvent != null)
					downEvent(this);
				if (Input.mouseReleased && upEvent != null)
					upEvent(this);
				if (!mouseHovering && hoverEvent != null) //if mouse isn't already hovering (dont run twice)
				{
					hoverEvent(this);
					mouseHovering = true;
				}
			}
			else if (mouseHovering && strayEvent != null) //mouse just left button
			{
				strayEvent(this);
				mouseHovering = false;
			}
		}
		
		//{ define graphics
		public function setGraphic(graphic:Graphic, width:int, height:int):void
		{
			setHitbox(width, height);
			
			this.graphic = graphic;
			normalGraphic = graphic;
			this.width = width;
			this.height = height;
		}
		
		public function setGraphicHover(graphic:Graphic):void
		{
			hoverGraphic = graphic;
		}
		
		public function setGraphicDown(graphic:Graphic):void
		{
			downGraphic = graphic;
		}
		//}
		
		//{ events
		public function onClick(callback:Function):void 
		{
			downEvent = callback;
		}
		
		public function onRelease(callback:Function):void 
		{
			upEvent = callback;
		}
		
		public function onMouseOver(callback:Function):void 
		{
			hoverEvent = callback;
		}
		
		public function onMouseStray(callback:Function):void 
		{
			strayEvent = callback;
		}
		//}
		
		//{ generate graphics
		//generate button
		public function createGraphic(text:String="", width:int=80, height:int=45, border:int=5):void 
		{
			setHitbox(width, height);
			
			//border
			var img:Image = Image.createRect(width, height);
			img.color = 0x333333;
			graphic = img;
			
			//inner
			var img2:Image = Image.createRect(width - border*2, height - border*2);
			img2.color = 0x555555;
			img2.x += border;
			img2.y += border;
			this.addGraphic(img2);
			
			//text
			if (text != "")
			{
				var t:Text = new Text(text, 0, 0);
				t.color = 0x000000;
				t.x = width/2 - t.scaledWidth/2;
				t.y = height/2 - t.scaledHeight/2;
				addGraphic(t);
			}
			normalGraphic = graphic;
		}
		
		//generate text only
		public function createText(text:String, size:int=12, font:String="default"):void 
		{
			this.text = new Text(text);
			this.text.size = size;
			this.text.font = font;
			
			setHitbox(this.text.width, this.text.height);
			graphic = this.text;
			normalGraphic = graphic;
		}
		
		public function setTextSize(size:int):void 
		{
			createText(text.text, size, text.font);
		}
		//}
	}
}