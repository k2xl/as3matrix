package src.Dimensions
{
	import src.Decompositions.LU;
	import src.Decompositions.QR;
	import src.Decompositions.SVD;
	import src.Matrix;
	import src.Vector;
	import src.errors.MatrixDimensionError;
	
	public class MatrixMxN implements IMatrixDimension
	{
		protected var MatrixReference:Matrix;
		public function MatrixMxN(ref:Matrix)
		{
			MatrixReference = ref;
		}
		public function determinant():Number
		{
			throw new MatrixDimensionError("Can't compute determinant of a non-square matrix");
		}
		public function eigenValues():Vector
		{
			throw new MatrixDimensionError("Non square matrices have no eigenvalues or eigenvectors.");
		}
		public function eigenVectors():Matrix
		{
			throw new MatrixDimensionError("Non square matrices have no eigenvalues or eigenvectors.");
		}
		public function isSymmetric():Boolean
		{
			return MatrixReference.equals(MatrixReference.transpose());
		}
		public function jacobi():Matrix
		{
			throw new MatrixDimensionError("Can't run jacobi on non square matrix");
		}
		public function jacobiNoSort():Matrix
		{
			throw new MatrixDimensionError("Can't run jacobi on non square matrix");
		}
		public function equals(other:Matrix):Boolean
		{			
			var orig:Array = MatrixReference.getColumnVectors()
			var temp:Array = other.getColumnVectors();
			
			for(var i:Object in orig){
				if(!Vector(orig[i]).equals(Vector(temp[i]))){
					return false;
				}
			}
			return true;
		}
		public function QRDecomposition():QR
		{
			return null;
		}
		public function LUDecomposition():LU
		{
			return null;
		}
		public function singularValueDecomposition():SVD
		{
			var Decomp:SVD = new SVD();
			var m:Matrix = MatrixReference.rowReduced();
			
			var r:int = m.numRows();
			var b:Matrix = new Matrix();
			var v:Vector = new Vector();
			for (var i:int = 0; i < r; i++)
			{
				v.push(0);
			}
			b.addVector(v);

			return Decomp;	
		}
		

		
		public function singularValues():Vector
		{
			var newMatrix:Matrix = new Matrix();
			var AtA:Matrix = MatrixReference.transpose().multiply(MatrixReference);
			AtA.lock();
			var eigenvals:Vector = AtA.eigenvalues();
			var singularvals:Vector = new Vector();
			
			var tempS:int = eigenvals.size();
			for (var i:int = 0; i < tempS; i++)
			{
				singularvals.push(Math.sqrt(eigenvals.getIndex(i)));
			}
			return singularvals;
		}
		/**
		 * This function reduces the matrix to row echelon form.
		 * Most of this code was ported from the http://www.phpmath.com/home?op=perm&nid=82
		 * I had to modifiy it though since swapping the rows with the largest abs value thing didn't really work...
		 * Consequently, this algorithm is I BELIEVE O(n^3), but because I don't swap the pivot rows I can't guarranty it.
		 * O(n^3)
		 * @return Row reduced Matrix
		 */
		public function rowReduced():Matrix
		{
			var A:Matrix = MatrixReference.clone();
			var N:int  = A.numRows();			
			var M:int = A.numColumns();
			for (var p:int=0; p<N; p++) 
			{
				var max:int = p;
				for (var i:int = p+1; i < N; i++)
				{
					if (Math.abs(A.getElement(i,p)) > Math.abs(A.getElement(max,p)))
					{
			      		max = i;
			  		}
			  	}
			  	/*if (Math.abs(A.getElement(p,p)) <= 1e-10) 
			  	{
			  		trace("Singular!");
			  		return null; // Matrix is singular	
			  	}*/
			  	// pivot within A and b
			  	for (i = p+1; i < N; i++) 
			  	{
			    	var alpha:Number = A.getElement(i,p) / A.getElement(p,p);
			    	//trace("Subtracting "+alpha+" * row "+p+" from row "+i) // Uncomment to log actions
			    	for (var j:int = p; j < M; j++)
			    	{
			    		var newVal:Number = A.getElement(i,j)-alpha*A.getElement(p,j);
			    		A.setElement(i,j, newVal);
			    	}
			  	}
		  	}
			return A;
		}
		
		public function kernal():Matrix
		{
			var tempR:int = MatrixReference.numRows();
			var vec:Vector = new Vector();
			for (var i:int = 0; i < tempR ; i++)
			{
				vec.push(0);
			}
			var M:Matrix = new Matrix();
			M.addVector(vec);
			M.lock();
			return solve(M);
		}
		public function solve(B:Matrix):Matrix
		{
			return new Matrix(); 
		}
		public function inverse():Matrix
		{
			throw new MatrixDimensionError("Cannot compute inverse of a non-square matrix");
		}
		public function transpose():Matrix
		{
			var temp:Matrix = new Matrix();
			var tempS:int = MatrixReference.numColumns();
			for (var i:int = 0; i < tempS; i++)
			{
				temp.addVector(MatrixReference.getRow(i).clone());
			}	
			temp.lock();
			return temp;
		}
		public function diagonalize():Matrix
		{
			var newMatrix:Matrix = new Matrix();
			var eigenvals:Vector = MatrixReference.eigenvalues();
			var tempS:int = eigenvals.size();
			for (var i:int = 0; i < tempS; i++)
			{
				var newVec:Vector = new Vector();
				for (var k:int = 0; k < i; k++)
				{
					newVec.push(0);
				}
				newVec.push(eigenvals.getIndex(i));
				for (var r:int = k; r < tempS-1; r++)
				{
					newVec.push(0);
				}
				newMatrix.addVector(newVec);
			}
			newMatrix.lock();
			return newMatrix;
		}
		/**
		 * @param Matrices An array of Matrices to multiply this matrix by
		 * @return The product
		 */
		public function multiply(Matrices:Array):Matrix
		{
			return operate(Matrices,multiplySingle);
		}
		public function operate(Matrices:Array, func:Function):Matrix
		{
			var tempS:int = Matrices.length;
			var newMatrix:Matrix = MatrixReference;
			for (var i:int = 0 ; i < tempS;i++)
			{
				newMatrix = func.call(newMatrix,Matrices[i]) as Matrix; // I can call private method since I'm in this class.
			}
			return newMatrix;
		}
		protected function multiplySingle(m:Matrix):Matrix
		{
			if (MatrixReference.numColumns() != m.numRows())
			{
				return null;
			}
			// m.rows,columns
			var newMatrix:Matrix = new Matrix();
			var rows:int = MatrixReference.numRows();
			var tempC:int = m.numColumns();
			for (var col:int = 0; col < tempC; col++)
			{
				var newColumn:Vector = new Vector();
				var currentColumn:Vector = m.getColumn(col);
				for (var row:int = 0; row < rows; row++)
				{
					var val:Number = MatrixReference.getRow(row).dot(currentColumn);
					newColumn.push(val);
				}
				newMatrix.addVector(newColumn);
			}
			newMatrix.lock();
			return newMatrix;
		}
		/**
		 * @param Matrices The Matrices to add.
		 */
		public function add(Matrices:Array):Matrix
		{ 
			return operate(Matrices, addSingle);
		}
		/**
		 * @param Matrices The Matrices to subtract.
		 */
		public function subtract(Matrices:Array):Matrix
		{ 
			return operate(Matrices, subtractSingle);
		}
		private function addSingle(m:Matrix):Matrix
		{
			var rows:int = MatrixReference.numRows(); 
			if (MatrixReference.numColumns() != m.numColumns() || rows != m.numRows())
			{
				return null;
			}
			// m.rows,columns
			var newMatrix:Matrix = new Matrix();
			for (var col:int = 0; col < m.numColumns(); col++)
			{
				var newColumn:Vector = new Vector();
				for (var row:int = 0; row < rows; row++)
				{
					var e1:Number = MatrixReference.getColumn(col).getIndex(row);
					var e2:Number = m.getColumn(col).getIndex(row);
					newColumn.push(e1+e2);
				}
				newMatrix.addVector(newColumn);
			}
			newMatrix.lock();
			return newMatrix;
		}
		private function subtractSingle(m:Matrix):Matrix
		{
			var rows:int = MatrixReference.numRows();
			if (MatrixReference.numColumns() != m.numColumns() || MatrixReference.numRows() != m.numRows())
			{
				return null;
			}
			var newMatrix:Matrix = new Matrix();
			var tempC:int = m.numColumns();
			for (var col:int = 0; col < tempC; col++)
			{
				var newColumn:Vector = new Vector();
				for (var row:int = 0; row < rows; row++)
				{
					var e1:Number = MatrixReference.getColumn(col).getIndex(row);
					var e2:Number = m.getColumn(col).getIndex(row);
					newColumn.push(e1-e2);
				}
				newMatrix.addVector(newColumn);
			}
			newMatrix.lock();
			return newMatrix;
		}
		public function off():Number
		{
			throw new MatrixDimensionError("Can't compute off of non-square matrix");
		}
	}
}