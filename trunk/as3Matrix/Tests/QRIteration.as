package Tests
{
	import src.Decompositions.QR;
	import src.Matrix;
	import src.Vector;
	
	public class QRIteration
	{
		public static function Test():void
		{
			var A:Matrix = new Matrix();
			A.addVector(new Vector(9,2,3,4));
			A.addVector(new Vector(2,5,3,7));
			A.addVector(new Vector(3,3,7,3));
			A.addVector(new Vector(4,7,3,9));
			A.lock();
			for (var i:int = 0; i < 10; i++)
			{
				var Decomp:QR = A.QRDecomposition();
				A = Decomp.R.multiply(Decomp.Q);
				//trace(A)
				//trace(D.R);
				//trace(Decomp.Q.off());
				if (Decomp.Q.off() < 1e-10)
				{
					break;
				}
			}
			trace(A);
		}

	}
}