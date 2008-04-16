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
			throw new MatrixDimensionError("Non square matrices have no eigenvalues or eigenvectors. Dimension: "+MatrixReference.numRows()+"x"+MatrixReference.numColumns());
		}
		public function eigenVectors():Matrix
		{
			throw new MatrixDimensionError("Non square matrices have no eigenvalues or eigenvectors. Dimension: "+MatrixReference.numRows()+"x"+MatrixReference.numColumns());
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
		public function singularValueDecomposition(rApprox:int = 0):SVD
		{
			var sV:Vector = MatrixReference.singularValues();
			//trace("Singular Values: \n"+sV);
			var AtA:Matrix = MatrixReference.covarient(); // Will be cached
			var tempR:int = sV.length;
			if (rApprox > 0)
			{
				tempR = rApprox;
			}
			var D:Matrix = new Matrix();
			for(var i:int = 0; i<tempR;i++){
				var newVec:Vector = new Vector();
				for (var j:int = 0; j < i; j++)
				{
					newVec.push(0);
				}
				newVec.push(sV[i]);
				for (j = i+1; j < tempR; j++)
				{
					newVec.push(0);
				}
				D.addVector(newVec);
			}
			D.lock();
			
			trace("D: \n"+D);
			/*Takes Singular Values and subtracts them from AtA for each value
			Creates a u1,u2,uX... matrix and adds an eigen vector from each
			to the matrix U.*/

			//Matrix containing eigen vectors of AtA minus singular values
			var U:Matrix = new Matrix();
			//Take AtA and minus singular values
			for(var sig:int =0; sig<tempR;sig++){
				var uXA:Matrix = AtA.clone();
					for(var k:int=0;k<tempR; k++){
						uXA.setElement(k,k,uXA.getElement(k,k)-(sV[sig]*sV[sig]));
					}
					
								
				//trace("current eigen value: "+sV[sig]*sV[sig]);
				//trace("current u"+sig+": \n"+uXA);
				//Add normalized eigen vector to U
				//trace("unnormalized vector for u"+sig+" : \n"+ uXA.eigenvectors().getColumn(0)+"\n");
				//trace("normalized vector for u"+sig+" : \n"+ uXA.eigenvectors().getColumn(0).normalize()+"\n");
				//trace("eigenVectors: \n"+uXA.eigenvectors());
				//trace("---------------------------------------");
				
				U.addVector(uXA.eigenvectors().getColumn(sig));

			}
			U.lock();

			var V:Matrix = new Matrix();
			//trace("M = \n"+MatrixReference+"\n*\nU=\n"+U);
			V = (MatrixReference.multiply(U)).multiply(D.inverse());
			trace("V(U on online calc): \n"+V);
			trace("U Transpose (V^T on online calc): \n"+U.transpose());
			
			var svd:SVD = new SVD();
			svd.Ut = U.transpose();
			svd.V = V;
			// A = VDU^T
			svd.A = (V.multiply(D)).multiply(svd.Ut);
			//Should return original matrix
			trace("Multiplied out decomposed matrices to check (should return orig matrix): \n"+svd.A);
			return svd;
			
			/* I'm pretty sure A(k) is calculated depending on the value of r.
			   	That is for A(k), r(k). Both k's are subscripts, not functions.
			   	r is the singular value, and k for r(k) is the kth singular value
			*/

		
		}
		
		public function singularValues():Vector
		{
			var newMatrix:Matrix = new Matrix();
			var AtA:Matrix = MatrixReference.covarient();
			var eigenvals:Vector = AtA.eigenvalues();
			//trace("eigen values: \n" +eigenvals);
			var singularvals:Vector = new Vector();
			
			var tempS:int = eigenvals.length;
			for (var i:int = 0; i < tempS; i++)
			{
				singularvals.push(Math.sqrt(eigenvals[i]));
			}
			//trace("Sing Values: \n"+ singularvals);
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
		public function covarient():Matrix
		{
			return MatrixReference.transpose().multiply(MatrixReference);
		}
		public function transpose():Matrix
		{
			var temp:Matrix = new Matrix();		
			var checkCol:int = MatrixReference.numColumns();
			var checkRow:int = MatrixReference.numRows();
			var tempS:int;
			
			if(checkCol>=checkRow){
				tempS = checkCol;
			}
			else{
				tempS = checkRow;
			}
			
			for (var i:int = 0; i < tempS; i++)
			{
				if(i<checkRow&&(i<checkRow||i<checkCol)){
					temp.addVector(MatrixReference.getRow(i).clone());
				}
				
			}	
			temp.lock();
			return temp;
		}
		public function diagonalize():Matrix
		{
			var newMatrix:Matrix = new Matrix();
			var eigenvals:Vector = MatrixReference.eigenvalues();
			var tempS:int = eigenvals.length;
			for (var i:int = 0; i < tempS; i++)
			{
				var newVec:Vector = new Vector();
				for (var k:int = 0; k < i; k++)
				{
					newVec.push(0);
				}
				newVec.push(eigenvals[i]);
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
		public function multiplySingle(m:Matrix):Matrix
		{
			if (MatrixReference.columnVectors.length != m.rowVectors.length)
			{
				throw new MatrixDimensionError("Can't multiply axb by a cxd.");
			}
			/*var COUNT:int = 0;
			var TS:int = 0;
			var TE:int = 0;8*/
			// m.rows,columns
			var newMatrix:Matrix = new Matrix();
			var tempR:int = MatrixReference.numRows(), tempC:int = m.numColumns();
			for (var col:int = 0; col < tempC; col++)
			{
				var vec:Vector = new Vector(tempR); // preallocates the memory?...
				var tempColV:Array = m.columnVectors[col] as Vector;
				for (var row:int = 0; row < tempR; row++)
				{
					var tempRowV:Vector = MatrixReference.rowVectors[row] as Vector;
					var product:Number = 0;
					for (var i:int = 0; i < tempC; i++)
					{
						product+=tempRowV[i]*tempColV[i];
					}
					vec[row] = product;
				}
				newMatrix.columnVectors.push(vec);
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
					newColumn.push((MatrixReference.getColumn(col)[row]+m.getColumn(col)[row]));
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
					var e1:Number = MatrixReference.getColumn(col)[row];
					var e2:Number = m.getColumn(col)[row];
					newColumn.push(e1-e2);
				}
				newMatrix.columnVectors.push(newColumn);
			}
			newMatrix.lock();
			return newMatrix;
		}
		public function off():Number
		{
			throw new MatrixDimensionError("Can't compute off of non-square matrix. Current dimensions: "+MatrixReference.numRows()+"x"+MatrixReference.numColumns());
		}
	}
}