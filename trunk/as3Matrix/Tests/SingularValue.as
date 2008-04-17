package Tests
{
	import src.Matrix;
	import src.Vector;
	
	public class SingularValue
	{
		public static function Test():void
		{
			var t:Matrix = new Matrix();
 			/*t.addVector(new Vector(2,2,0,1));
            t.addVector(new Vector(0,1,0,2));
            t.addVector(new Vector(3,1,1,3));
            t.addVector(new Vector(7,0,1,4));*/
            t.addVector(new Vector(2,1,0));
            t.addVector(new Vector(1,3,-1));
            t.addVector(new Vector(0,-1,6));
            t.lock();
            trace("Orig: \n"+t);
            trace(t.eigenvalues());
           //trace("Sing vales\n"+t.singularValueDecomposition(1));

		}

	}
}