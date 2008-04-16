package Tests
{
	import src.Decompositions.SVD;
	import src.Matrix;
	import src.Vector;
	
	public class SingularValue
	{
		public static function Test():void
		{
			var t:Matrix = new Matrix();
 			t.addVector(new Vector(2,2,0));
            t.addVector(new Vector(0,1,0));
            t.addVector(new Vector(3,1,1));      
            t.lock();
            trace("Orig: \n"+t);
            trace("Sing vales\n"+t.singularValueDecomposition(1));

		}

	}
}