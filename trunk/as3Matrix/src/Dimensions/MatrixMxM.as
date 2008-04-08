package src.Dimensions
{
	import src.Matrix;
	import src.Vector;

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
			for (var i:int = 0; i < 10; i++)
			{
				MatrixReference = MatrixReference.jacobi();
				if (Math.abs(MatrixReference.off()) < 1e-9)
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
					sum+=MatrixReference.getElement(i,j);
				} 
			}
			return sum;
		}
		// Runs one iteration of the jacobi
		public override function jacobi():Matrix
		{
			// Check if already diagonal
			var topLeft:Matrix = new Matrix();
			var aindex:int = 0;
			var bindex:int = 0;
			var cindex:int = 0;
			var dindex:int = 0;
			var size:int = MatrixReference.numColumns();
			for (var i:int = 1; i < size; i++)
			{
				if (bindex*cindex == 0 && MatrixReference.getColumn(i).getIndex(0) != 0 || MatrixReference.getRow(i).getIndex(0) != 0)
				{
					bindex = i;
					cindex = i;
					dindex = i;
					break;
				}
			}
			var a:Number = MatrixReference.getElement(0,0);
			var b:Number = MatrixReference.getElement(bindex,0);
			var c:Number = MatrixReference.getElement(0,cindex);
			var d:Number = MatrixReference.getElement(dindex,dindex);
			
			topLeft.addVector(new Vector(a,c));
			topLeft.addVector(new Vector(b,d));
			topLeft.lock();
			var D:Matrix = topLeft.eigenvectors();
			var g:Matrix = Matrix.identity(size);
			// embed D into m
			g.setElement(0,0, D.getElement(0,0));
			g.setElement(bindex, 0, D.getElement(1,0));
			g.setElement(0, cindex, D.getElement(0,1));
			g.setElement(dindex, dindex, D.getElement(1,1));
			var gtAg:Matrix = g.transpose().multiply(this.MatrixReference);
			gtAg = gtAg.multiply(g);
			return gtAg;
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