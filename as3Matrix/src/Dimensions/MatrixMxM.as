package src.Dimensions
{
	import src.Matrix;
	import src.Vector;
	import src.errors.MatrixError;

	public class MatrixMxM extends MatrixMxN
	{
		public function MatrixMxM(ref:Matrix)
		{
			super(ref);
		}
		public override function determinant():Number
		{
			var m:Matrix = MatrixReference.rowReduced();
			var product:Number = m.getElement(0,0);
			var tempS:int = m.numColumns(); // Should be a square matrix...
			for (var i:int = 1, j:int = 1; i < tempS; i++, j++)
			{
				product*=m.getElement(i,j);
			}
			return product;
		}
		/**
		 * Diagonalize the Matrix using Jacobi's algortihm.
		 * @return the diagnoal matrix
		 */
		public override function diagonalize():Matrix
		{
			if (!MatrixReference.equals(MatrixReference.transpose()))
			{
				throw new MatrixError("Cannot diagonalize a non symmetric matrix with jacobi");
			}
			for (var i:int = 0; i < 100; i++)
			{
				MatrixReference = MatrixReference.jacobi();
				if (MatrixReference.off() < 1e-9)
				{
					break;
				}
			}
			return MatrixReference;
		}
		public override function off():Number
		{
			var sum:Number = 0;
			var r:int =  MatrixReference.numRows();
			var c:int = MatrixReference.numColumns(); 
			for (var i:int = 0; i < r; i++)
			{
				for (var j:int = 0; j<c;j++)
				{
					if (i == j) break;
					sum+=MatrixReference.getElement(i,j)*MatrixReference.getElement(i,j);
				} 
			}
			return sum;
		}
		// Runs one iteration of the jacobi
		public override function jacobi():Matrix
		{
			// Check if already diagonal
			var topLeft:Matrix = new Matrix();
			var largestI:int = 0;
			var largestJ:int = 0;
			var size:int = MatrixReference.numColumns();
			var currMax:Number = 0;
			for (var j:int = 0; j < size; j++)
			{
				for (var i:int = 0; i < size; i++)
				{
					if (i != j)
					{
						if (Math.abs(MatrixReference.getElement(i,j)) > currMax)
						{
							largestI = i;
							largestJ = j;
							currMax = MatrixReference.getColumn(i).getIndex(0);
						}
					}
				}
			}
			var a:Number = MatrixReference.getElement(largestI,largestI);
			var b:Number = MatrixReference.getElement(largestJ,largestI);
			var c:Number = MatrixReference.getElement(largestI,largestJ);
			var d:Number = MatrixReference.getElement(largestJ,largestJ);
			
			topLeft.addVector(new Vector(a,c));
			topLeft.addVector(new Vector(b,d));
			topLeft.lock();
			var U:Matrix = topLeft.eigenvectors();
			var g:Matrix = Matrix.identity(size);
			// embed D into m
			g.setElement(largestI,largestI, U.getElement(0,0));
			g.setElement(largestJ, largestI, U.getElement(0,1));
			g.setElement(largestI, largestJ, U.getElement(1,0));
			g.setElement(largestJ, largestJ, U.getElement(1,1));
			
			var D:Matrix = g.transpose().multiply(this.MatrixReference);
			D = D.multiply(g);
			
			return D;
		}
		private function isDiagonal():Boolean
		{
			var size:int = MatrixReference.numColumns();
			for (var i:int = 0; i <  size; i++)
			{
				for (var j:int = 0; j < size; j++)
				{
					if (i != j)
					{
						if (MatrixReference.getElement(i,j) != 0)
						{
							return false;
						}
					}
				}
			}
			return true;
		}
		public override function solve(B:Matrix):Matrix
		{
			var m:Matrix = MatrixReference.inverse();
			return (m.multiply(B));
		}
	}
}