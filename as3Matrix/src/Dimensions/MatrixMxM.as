package src.Dimensions
{
	import src.Decompositions.QR;
	import src.Matrix;
	import src.Vector;

	public class MatrixMxM extends MatrixMxN
	{
		public function MatrixMxM(ref:Matrix)
		{
			super(ref);
		}
		public override function inverse():Matrix
		{ 
			return MatrixReference.solve(Matrix.identity(MatrixReference.numColumns()));
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
		 * Diagonalize the Matrix using QR algortihm.
		 * @return the diagnoal matrix
		 */
		public override function diagonalized():Matrix
		{
			// Commenting out since we'll be using QR instead of jacobi
			/*if (!MatrixReference.equals(MatrixReference.transpose()))
			{
				throw new MatrixError("Cannot diagonalize a non symmetric matrix with jacobi");
			}*/
			var A:Matrix = MatrixReference.clone();
			for (var i:int = 0; i < 1000; i++)
			{
				var Decomp:QR = A.QRDecomposition();
				A = Decomp.R.multiply(Decomp.Q);
				//trace(A)
				//trace(D.R);
				trace(Decomp.Q.off());
				if (Decomp.Q.off() < 1e-10)
				{
					break;
				}
			}
			trace(i);
			return A;
		}
		public override function eigenValues():Vector
		{
			var e:Vector = new Vector();
			var d:Matrix = MatrixReference.diagonalize();
			var tempS:int = d.numColumns();
			for (var i:int = 0; i < tempS; i++)
			{
				e.push(d.getElement(i,i));
			}
			return e;
		}
		
		public override function off():Number
		{
			var sum:Number = 0;
			var r:int =  MatrixReference.numRows(); 
			for (var i:int = 1; i < r; i++)
			{
				for (var j:int = 0; j<r;j++)
				{
					if (i == j) break;
					sum+=(MatrixReference.getElement(i,j)*MatrixReference.getElement(i,j));
				} 
			}
			return sum;
		}
		// Runs one iteration of the jacobi
		public override function jacobi():Matrix
		{
			// Check if already diagonal
			var largestI:int = 0;
			var largestJ:int = 1;
			var size:int = MatrixReference.numColumns();
			var currMax:Number = MatrixReference.getElement(largestI,largestJ);
			for (var i:int = 0; i < size; i++)
			{			
				for (var j:int = 0; j < size; j++)
				{
					if (i != j)
					{
						if (Math.abs(MatrixReference.getElement(i,j)) > currMax)
						{
							largestI = i;
							largestJ = j;
							currMax = Math.abs(MatrixReference.getElement(i,j));
						}
					}
				}
			}
			/**
			 * 	B(1,2) = randMatrix(maxRow, maxCol);
		    	B(2,1) = randMatrix(maxRow, maxCol);
		    	B(1,1) = randMatrix(maxRow, maxRow);
		    	B(2,2) = randMatrix(maxCol, maxCol);
		    */
			var a:Number = MatrixReference.getElement(largestI,largestI); // 1,1
			var b:Number = MatrixReference.getElement(largestI,largestJ); // 1,2
			var c:Number = MatrixReference.getElement(largestJ,largestI); // 2,1
			var d:Number = MatrixReference.getElement(largestJ,largestJ); // 2,2
			var topLeft:Matrix = new Matrix();
			topLeft.addVector(new Vector(a,c));
			topLeft.addVector(new Vector(b,d));
			topLeft.lock();
			var U:Matrix = topLeft.eigenvectors();
			var g:Matrix = Matrix.identity(size);
			
			g.setElement(largestI,largestI, U.getElement(0,0)); // a
			g.setElement(largestI, largestJ, U.getElement(0,1)); // b
			g.setElement(largestJ, largestI, U.getElement(1,0)); // c
			g.setElement(largestJ, largestJ, U.getElement(1,1)); //d
			var D:Matrix = g.transpose().multiply(this.MatrixReference);
			D = D.multiply(g);
			return D;
		}
		// Runs one iteration of the jacobi without sorting
		public override function jacobiNoSort():Matrix
		{
			// Check if already diagonal
			var largestI:int = 0;
			var largestJ:int = 1;
			var size:int = MatrixReference.numColumns();
			var currMax:Number = 0;
			do
			{
				largestI = Math.floor(Math.random()*size);
				largestJ = Math.floor(Math.random()*size);
			}while (largestI == largestJ);
			var a:Number = MatrixReference.getElement(largestI,largestI); // 1,1
			var b:Number = MatrixReference.getElement(largestI,largestJ); // 1,2
			var c:Number = MatrixReference.getElement(largestJ,largestI); // 2,1
			var d:Number = MatrixReference.getElement(largestJ,largestJ); // 2,2
			var topLeft:Matrix = new Matrix();
			topLeft.addVector(new Vector(a,c));
			topLeft.addVector(new Vector(b,d));
			topLeft.lock();
			var U:Matrix = topLeft.eigenvectors();
			var g:Matrix = Matrix.identity(size);
			
			g.setElement(largestI,largestI, U.getElement(0,0)); // a
			g.setElement(largestI, largestJ, U.getElement(0,1)); // b
			g.setElement(largestJ, largestI, U.getElement(1,0)); // c
			g.setElement(largestJ, largestJ, U.getElement(1,1)); //d
			
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
		
	}
}