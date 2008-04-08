package src.Decompositions
{
	import src.Matrix;
	
	public class LU
	{
		public var L:Matrix;
		public var U:Matrix;
		
		private var mLU:Matrix;
		private var piv:Array;
		private var pivsign:Number;
		private var n:Number;
		private var m:Number;
		
		public function LU(A:Matrix)
		{
	// Use a "left-looking", dot-product, Crout/Doolittle algorithm.
		mLU = A.clone();
		m = A.numRows();
		n = A.numColumns();
		}
/*
	//to change
		for(var i:Object in m){
			vec[i] = i;
		}

		pivsign=1;



      // Outer loop.

      for (var j:Number = 0; j < n; j++) {
         // Apply previous transformations.

         for (var i:Number = 0; i < m; i++) {
            // Most of the time is spent in the following dot product.

            int kmax = Math.min(i,j);
            double s = 0.0;
            for (int k = 0; k < kmax; k++) {
               s += LUrowi[k]*LUcolj[k];
            }

            LUrowi[j] = LUcolj[i] -= s;
         }
   
         // Find pivot and exchange if necessary.

         int p = j;
         for (int i = j+1; i < m; i++) {
            if (Math.abs(LUcolj[i]) > Math.abs(LUcolj[p])) {
               p = i;
            }
         }
         if (p != j) {
            for (int k = 0; k < n; k++) {
               double t = LU[p][k]; LU[p][k] = LU[j][k]; LU[j][k] = t;
            }
            int k = piv[p]; piv[p] = piv[j]; piv[j] = k;
            pivsign = -pivsign;
         }

         // Compute multipliers.
         
         if (j < m & LU[j][j] != 0.0) {
            for (int i = j+1; i < m; i++) {
               LU[i][j] /= LU[j][j];
            }
         }
      }
   }
			
		}
		*/
	}
}