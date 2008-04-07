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
			 a = MatrixReference.getColumn(0).getIndex(0);
			 b = MatrixReference.getColumn(1).getIndex(0);
			 c = MatrixReference.getColumn(0).getIndex(1);
			 d = MatrixReference.getColumn(1).getIndex(1);
		}
		public override function determinant():Number
		{
			return a*d-b*c;
		}
		public override function equals(other:IMatrixDimension):Boolean
		{
			var type:Matrix2x2 = other as Matrix2x2;
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
			var a:Number = MatrixReference.getColumn(0).getIndex(0);
			var b:Number = MatrixReference.getColumn(1).getIndex(0);
			var c:Number = MatrixReference.getColumn(0).getIndex(1);
			var d:Number = MatrixReference.getColumn(1).getIndex(1);
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
			var a:Number = MatrixReference.getColumn(0).getIndex(0);
			var b:Number = MatrixReference.getColumn(1).getIndex(0);
			var c:Number = MatrixReference.getColumn(0).getIndex(1);
			var d:Number = MatrixReference.getColumn(1).getIndex(1);
			var L1:Number = ( (a+d)/2 ) + Math.sqrt( 4*b*c + ((a-d)*(a-d)))/2;
			var L2:Number = ( (a+d)/2 ) - Math.sqrt( 4*b*c + ((a-d)*(a-d)))/2;
			return new Vector(L1,L2);
		}
		public override function eigenVectors():Matrix
		{
			var newMatrix:Matrix = new Matrix();
			var b:Number = MatrixReference.getColumn(1).getIndex(0);
			var c:Number = MatrixReference.getColumn(0).getIndex(1);
			var d:Number = MatrixReference.getColumn(1).getIndex(1);
			var eigenvals:Vector = eigenValues(); // will retrieve from cache if already calculated.
			if (c != 0)
			{
				newMatrix.addVector(new Vector(eigenvals.getIndex(0)-d,c));
				newMatrix.addVector(new Vector(eigenvals.getIndex(1)-d,c));
				return newMatrix;
			}
			else if (b != 0)
			{
				newMatrix.addVector(new Vector(eigenvals.getIndex(0)-b,d));
				newMatrix.addVector(new Vector(eigenvals.getIndex(1)-b,d));
				return newMatrix;
			}
			newMatrix.addVector(new Vector(1,0));
			newMatrix.addVector(new Vector(0,1));
			return newMatrix;
		}
	}
}