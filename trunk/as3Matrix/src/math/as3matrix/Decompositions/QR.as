/**
 * Taken from Clver's JAMA port
 */
package src.Decompositions
{
	import src.math.as3Matrix.Matrix;
	import src.math.as3Matrix.Vector;
	
	public class QR
	{
		private var Decomp:Matrix;
		private var RDiag:Vector;// diagonals, internal storage
		public var Q:Matrix;
		public var R:Matrix; 
		private var m:int;
		private var n:int;
		public function toString():String
		{
			return "Q=\n"+(Q)+"\n*\nR=\n"+R+"\nQR=\n"+Q.multiply(R);
		}
		private function processR ():void {
			R = Matrix.zeros(m);
			var j:int
			for (var i:int = 0; i < n; i++) {
				for (j = 0; j < n; j++) {
					if (i < j) {
						R.setElement(i,j, Decomp.getElement(i,j));
					} else if (i == j) {
						R.setElement(i,j, RDiag[i]);
					} else {
						R.setElement(i,j, 0);
					}
				}
			}
		}

		/** Generate and return the (economy-sized) orthogonal factor
			@return     Q
		*/

		public function processQ ():void {
			Q = Matrix.zeros(m);
			
			var i:int;
			var k:int;
			var j:int;
			var s:Number;
			for (k = n-1; k >= 0; k--) {
				for (i = 0; i < m; i++) {
					Q.setElement(i,k,0);
				}
				Q.setElement(k,k,1.0);
				for (j = k; j < n; j++) {
					if (Decomp.getElement(k,k) != 0) {
						s = 0.0;
						for (i = k; i < m; i++) {
							s += Decomp.getElement(i,k)*Q.getElement(i,j);
						}
						s = -s/Decomp.getElement(k,k);
						for (i = k; i < m; i++) {
							Q.setElement(i,j, Q.getElement(i,j) + s*Decomp.getElement(i,k));
						}
					}
				}
			}
		}

		public function QR(A:Matrix)
		{
			 // Initialize.
		      Decomp = A.clone();
		      m = A.numRows();
		      n = A.numColumns();
		      RDiag = new Vector(n);
		      // Main loop.
		      var i:int;
		      var j:int;
		      var nrm:Number;
		      var s:Number;
		      for (var k:int = 0; k < n; k++) {
		         // Compute 2-norm of k-th column without under/overflow.
		         nrm = 0;
		         for (i = k; i < m; i++) {
		            nrm = hypot(nrm,Decomp.getElement(i,k));
		         }
		
		         if (nrm != 0.0) {
		            // Form k-th Householder vector.
		            if (Decomp.getElement(k,k) < 0) {
		               nrm = -nrm;
		            }
		            for (i = k; i < m; i++) {
		               Decomp.setElement(i,k,Decomp.getElement(i,k) / nrm);
		            }
		            Decomp.setElement(k,k,Decomp.getElement(k,k)+1);
		
		            // Apply transformation to remaining columns.
		            for (j= k+1; j < n; j++) {
		               s = 0.0; 
		               for (i = k; i < m; i++) {
		                  s += Decomp.getElement(i,k)*Decomp.getElement(i,j);
		               }
		               s = -s/Decomp.getElement(k,k);
		               for (i = k; i < m; i++) {
		                  Decomp.setElement(i,j,Decomp.getElement(i,j) + s*Decomp.getElement(i,k));
		               }
		            }
		         }
		         RDiag[k] = -nrm;
		      }
		      processQ();
		      processR();
		      // Garbage collect time
		      //RDiag = null;
		      //Decomp = null;
		}
			   public static function hypot(a:Number, b:Number):Number {
	      var r:Number;
	      if (Math.abs(a) > Math.abs(b)) {
	         r = b/a;
	         r = Math.abs(a)*Math.sqrt(1+r*r);
	      } else if (b != 0) {
	         r = a/b;
	         r = Math.abs(b)*Math.sqrt(1+r*r);
	      } else {
	         r = 0.0;
	      }
	      return r;
	   }
	   	/** Is the matrix full rank?
			@return     true if R, and hence A, has full rank.
		*/

		public function isFullRank ():Boolean {
			for (var j:int = 0; j < n; j++) {
				if (RDiag[j] == 0)
					return false;
			}
			return true;
		}

	   	public function solve (B:Matrix):Matrix{
			if (B.numRows() != m) {
				throw new Error("Matrix row dimensions must agree.");
			}
			if (!this.isFullRank()) {
				throw new Error("Matrix is rank deficient.");
			}

			// Copy right hand side
			var nx:int = B.numColumns();
			//var X:Matrix = B.clone();
			
			var k:int;
			var j:int;
			var i:int;
			var s:Number;
			
			var X:Matrix = B.clone();//Q.transpose().multiply(B);
			// Compute Y = transpose(Q)*B
			for (k = 0; k < n; k++) {
				for (j = 0; j < nx; j++) {
					s = 0; 
					for (i = k; i < m; i++) {
						s += Decomp.getElement(i,k)*X.getElement(i,j);
					}
					s = -s/Decomp.getElement(k,k);
					for (i = k; i < m; i++) {
						X.setElement(i,j,X.getElement(i,j) + s*Decomp.getElement(i,k));
					}
				}
			}
			// Solve R*X = Y;
			for (k = n-1; k >= 0; k--) {
				for (j = 0; j < nx; j++) {
					X.setElement(k,j,X.getElement(k,j) / RDiag[k]);
				}
				for (i = 0; i < k; i++) {
					for (j = 0; j < nx; j++) {
						X.setElement(i,j,X.getElement(i,j) - X.getElement(k,j)*Decomp.getElement(i,k));
					}
				}
			}
			return X;//(new Matrix(X,n,nx).getMatrix(0,n-1,0,nx-1));
		}


	}
	
}