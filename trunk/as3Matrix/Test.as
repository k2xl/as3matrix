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
			var m:Matrix = new Matrix();
			m.addVector(new Vector(1,2));
			m.addVector(new Vector(3,4));
			m.lock();
			m.inverse();
			var B:Matrix = new Matrix();
			B.addVector(new Vector(9,2,3));
			B.addVector(new Vector(2,5,4));
			B.addVector(new Vector(-1,5,33));
			B.lock();
			trace("Trace: "+m.eigenvalues());
			
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
	}
}
