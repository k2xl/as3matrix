package src.Dimensions
{
	import src.Matrix;
	import src.Vector;
	import src.errors.MatrixInverseError;
	
	public class Matrix2x2 extends MatrixMxM
	{
		private var a:Number;
		private var b:Number;
		private var c:Number;
		private var d:Number;
		

		public function Matrix2x2(ref:Matrix)
		{
			super(ref);
			 a = MatrixReference.getColumn(0)[0];
			 b = MatrixReference.getColumn(1)[0];
			 c = MatrixReference.getColumn(0)[1];
			 d = MatrixReference.getColumn(1)[1];
		}
		public override function determinant():Number
		{
			return a*d-b*c;
		}
		public override function equals(other:Matrix):Boolean
		{
			var type:Matrix2x2 = other.MatrixDimension as Matrix2x2;
			return type.a==a&&type.b==b&&type.c==c&&type.d==d;
		}
		public override function inverse():Matrix
		{
			var temp:Matrix = new Matrix();
			var D:Number = determinant();
			if (D == 0)
			{
				throw new MatrixInverseError("Can't compute inverse when determinant is 0");
			}
			D = 1/D;
			temp.addVector(new Vector(D*d,D*-c));
			temp.addVector(new Vector(D*-b,D*a));
			temp.lock();
			return temp;
		}
		
		
		/**
		 * Calculates the eigenvalues of a 2x2 matrix
		 * @return The eigenvalues
		 */
		public override function eigenValues():Vector
		{
			//Found a more efficent algorithem using the trace of a 2x2
			var L1:Number = ( (a+d)/2 ) + Math.sqrt( 4*b*c + ((a-d)*(a-d)))/2;
			var L2:Number = ( (a+d)/2 ) - Math.sqrt( 4*b*c + ((a-d)*(a-d)))/2;
			return new Vector(L1,L2);
		}
		public override function eigenVectors():Matrix
		{
			var newMatrix:Matrix = new Matrix();
			var eigenvals:Vector = eigenValues(); // will retrieve from cache if already calculated.
			if (c != 0)
			{
				newMatrix.addVector((new Vector(eigenvals[0]-d,c)).normalize());
				newMatrix.addVector((new Vector(eigenvals[1]-d,c)).normalize());
			}
			else if (b != 0)
			{
				newMatrix.addVector((new Vector(b,eigenvals[0]-d)).normalize());
				newMatrix.addVector((new Vector(b,eigenvals[1]-d)).normalize());
			}
			else
			{
				newMatrix.addVector(new Vector(1,0));
				newMatrix.addVector(new Vector(0,1));
			}
			newMatrix.lock();
			return newMatrix;
			
		}
	}
}