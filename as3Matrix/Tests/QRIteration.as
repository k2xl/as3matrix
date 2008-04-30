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
			A.addVector(new Vector(1,2,3,4));
			A.addVector(new Vector(2,5,3,7));
			A.addVector(new Vector(3,3,7,3));
			A.addVector(new Vector(4,7,3,9));
			A.lock();
			trace(A);
			var U:Matrix = Matrix.identity(A.numColumns());
			for (var i:int = 0; i < 100; i++)
			{
				var Decomp:QR = A.QRDecomposition();
				A = Decomp.R.multiply(Decomp.Q);
				U = U.multiply(Decomp.Q);
				//trace(A)
				//trace(D.R);
				//trace(Decomp.Q.off());
				var u:Matrix = new Matrix();
				var uV:Vector = U.columnVectors[0] as Vector;
				u.addVector(uV);
				u.lock();
				var Au:Vector = (A.multiply(u)).columnVectors[0] as Vector;
				
				var check:Vector = (A.multiply(u).subtract(u.multiplyScalar(uV.dot(Au)))).columnVectors[0];
				trace(check.mag());
				if (check.mag() < 10e-8)
				{
					break;
				}
				// if not...
				var c:Number = uV.dot(Au);
				var cI:Matrix = Matrix.identity(A.numColumns()).multiplyScalar(c);
				A = A.subtract(cI).inverse();
				
				var sum:Number = 0;
				var FirstCol:Vector = A.columnVectors[0] as Vector;
				var tempS:int = FirstCol.length;
				for (var j:int = 1; j < tempS; j++)
				{
					sum+=FirstCol[j];
				}
				if (sum < 10e-5)
				{
					break;
				}
				// if not...
				var B:Matrix = new Matrix();
				B.addVector(new Vector(A.columnVectors[0][0],A.columnVectors[0][1]));
				B.addVector(new Vector(A.columnVectors[1][0],A.columnVectors[1][1]));
				B.lock();
				c = B.eigenvalues()[0];
				cI = Matrix.identity(A.numColumns()).multiplyScalar(c);
				A = A.subtract(cI).inverse();
			}
			trace(U);
			trace(A+"\nAfter "+i+" iterations");
		}

	}
}