package  
{
	import net.flashpunk.*
	
	public class Util 
	{
		public static function rand(min:int, max:int):int
		{
			return FP.rand(max - min) + min;
		}
	}
}