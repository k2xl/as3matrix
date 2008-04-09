//test commit
package {
	
	// Here's a test
	import flash.display.Sprite;
	
	import src.Matrix;
	import src.Vector;
	public class Test extends Sprite
	{
		public function Test()
		{
			var sum:Number = 0;
			for (var j:int = 0; j <10; j++)
			{
				var m:Matrix = getRandom();
				for (var i:int = 0; i < 200; i++)
				{
					m = m.jacobi();
					//trace("M: \n"+m);
					var o:Number = Math.abs(m.off());
					if (o < 1e-9)
					{
						break;
					}
				}
				if (i >= 250)
				{
					break;
				}
				sum+=i;
			}
			trace("Average = "+sum/10);
			//trace("After "+(i+1)+" iterations... \n"+m);

			//trace("Diagnolize:\n"+m.diagonalize());
			
			
			
			/*var st:int = getTimer();
			var a:Matrix = new Matrix();
			var b:Matrix = new Matrix();
			for (var g:int = 0; g < 1000; g++)
			{
				var v:Vector = new Vector();
				for (var i:int = 0; i < 1000; i++)
				{
					v.push(Math.random());
				}
				a.addVector(v);
			}
			// AS3 scope is a bit different
			for (g = 0; g < 1000; g++)
			{
				var v2:Vector = new Vector();
				for (i = 0; i < 1000; i++)
				{
					v2.push(Math.random());
				}
				b.addVector(v2);
			}
			a.lock();
			b.lock();
			st = getTimer()-st;
			trace("done in "+st/1000+" seconds");*/
/**
 * 1	2			1*5		1*6		2*5		2*6
 * 3	4			1*7		1*8		2*7		2*8
 * 					3*5		3*6		4*5		4*6
 * 					3*7		3*7		4*7		4*8
 *
 * 					5		6		10		12
 * 					7		8		14		16
 * 					15		18		20		24
 * 					21		21		28		32
 * 5	6
 * 7	8
 */
			
			
		}
		private function getRandom():Matrix
		{
			var m:Matrix = new Matrix();
			// generate a 5x5 matrix
			var size:int = 5;
			for (var i:int = 0; i < size; i++)
			{
				var vec:Vector= new Vector();
				for (var j:int = 0; j < size; j++)
				{
					vec.push(0);
				}
				m.addVector(vec);
			}
			m.lock();
			for (var n:int = 0; n < size; n++)
			{
				for (var p:int = n; p < size; p++)
				{
					var num:Number = Math.floor(Math.random()*100);
					m.setElement(n,p,num);
					m.setElement(p,n,num);
				}
			}
			return m;
		}
	}
}
