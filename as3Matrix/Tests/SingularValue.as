package Tests
{
	import flash.utils.getTimer;
	
	import src.Matrix;
	import src.Vector;
	
	public class SingularValue
	{
		public static function Test():void
		{
			var t:Matrix = new Matrix();
 			t.addVector(new Vector(2,2,0,1));
            t.addVector(new Vector(0,1,0,2));
            t.addVector(new Vector(3,1,1,3));
            t.addVector(new Vector(7,0,1,4));
            t.lock();
            trace("Orig: \n"+t);
            //trace(t.eigenvalues());
            //var s:SVD = t.singularValueDecomposition(0);
            //trace(s.U);
            
            
           	//trace(s.V);
           	//trace(s.S);

		}

	}
}