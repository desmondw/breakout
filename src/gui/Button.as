package gui
{
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.graphics.*;

	/**
	 * Entity that is interactable with the mouse. Useful for menus.
	 */
	public class Button extends Entity
	{
		//events
		private var _downEvent:Function;		//pressed down
		private var _upEvent:Function;			//released
		private var _hoverEvent:Function;		//moves over button
		private var _strayEvent:Function;		//leaves from button
		
		//graphics
		protected var _normalGraphic:Graphic;		//no interaction
		protected var _hoverGraphic:Graphic;		//mouse over button
		protected var _downGraphic:Graphic;			//mouse held over button
		
		//flags
		private var _mouseHovering:Boolean = false;		//used to track stray event
		public var interactable:Boolean = true;			//determines if events are triggered
		
		/**
		 * Constructor.
		 * @param	graphic		Graphic the Button will normally display.
		 * @param	x			X position to place the Button.
		 * @param	y			Y position to place the Button.
		 * @param	width		Width of the Button.
		 * @param	height		Height of the Button.
		 */
		public function Button(graphic:Graphic, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0) 
		{
			setGraphic(graphic, width, height);
			this.x = x;
			this.y = y;
			
			type = "button";
		}
		
		override public function update():void 
		{
			if (interactable)
				listen();
		}
		
		//check for events being triggered
		private function listen():void 
		{
			if (collidePoint(x, y, Input.mouseX, Input.mouseY)) //mouse is over button
			{
				if (Input.mousePressed && _downEvent != null) //clicking
					_downEvent(this);
				if (Input.mouseReleased && _upEvent != null) //releasing
					_upEvent(this);
				if (!_mouseHovering && _hoverEvent != null) //hovering (first frame only)
				{
					_hoverEvent(this);
					_mouseHovering = true;
				}
			}
			else if (_mouseHovering && _strayEvent != null) //mouse just left button
			{
				_strayEvent(this);
				_mouseHovering = false;
			}
		}
		
		//{ GRAPHICS
		
		/**
		 * Set which graphic the Button will normally display.
		 * @param	graphic		Graphic the Button will normally display.
		 * @param	width		Width of the Button.
		 * @param	height		Height of the Button.
		 */
		public function setGraphic(graphic:Graphic, width:Number = 0, height:Number = 0):void
		{
			setHitbox(width, height); //used for mouse interaction detection
			
			this.graphic = graphic;
			_normalGraphic = graphic;
		}
		
		/**
		 * Set which graphic the Button will display when moused over.
		 * @param	graphic		Graphic the Button will display when moused over.
		 */
		public function setGraphicHover(graphic:Graphic):void
		{
			_hoverGraphic = graphic;
		}
		
		/**
		 * Set which graphic the Button will display when clicked.
		 * @param	graphic		Graphic the Button will display when clicked.
		 */
		public function setGraphicDown(graphic:Graphic):void
		{
			_downGraphic = graphic;
		}
		
		//}
		
		//{ EVENTS
		
		/**
		 * Set behavior for when the Button is clicked.
		 * @param	callback	Function called when Button is clicked.
		 */
		public function onClick(callback:Function):void 
		{
			_downEvent = callback;
		}
		
		/**
		 * Set behavior for when the clicked Button is released.
		 * @param	callback	Function called when Button is released.
		 */
		public function onRelease(callback:Function):void 
		{
			_upEvent = callback;
		}
		
		/**
		 * Set behavior for when the mouse moves over the Button.
		 * @param	callback	Function called when mouse moves over the Button.
		 */
		public function onMouseOver(callback:Function):void 
		{
			_hoverEvent = callback;
		}
		
		/**
		 * Set behavior for when the mouse moves off of the Button.
		 * @param	callback	Function called when the mouse moves off of the Button.
		 */
		public function onMouseStray(callback:Function):void 
		{
			_strayEvent = callback;
		}
		
		//}
		
		/**
		 * Forces the mouse stray event to fire.
		 */
		public function forceStray():void 
		{
			if (_strayEvent != null)
				_strayEvent(this);
		}
	}
}