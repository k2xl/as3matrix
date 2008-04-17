package src.Decompositions
{
	import src.Matrix;
	import src.Vector;
	
	public class QR
	{
		public var Q:Matrix;
		public var R:Vector;
		public function toString():String
		{
			return ""+(R);
		}
		public function QR(A:Matrix)
		{
			 // Initialize.
		      Q = A.clone();
		      var m:int = A.numRows();
		      var n:int = A.numColumns();
		      R = new Vector();
		
		      // Main loop.
		      for (var k:int = 0; k < n; k++) {
		         // Compute 2-norm of k-th column without under/overflow.
		         var nrm:Number = 0;
		         for (var i:int = k; i < m; i++) {
		            nrm = hypot(nrm,Q.getElement(i,k));
		         }
		
		         if (nrm != 0.0) {
		            // Form k-th Householder vector.
		            if (Q.getElement(k,k) < 0) {
		               nrm = -nrm;
		            }
		            for (i = k; i < m; i++) {
		               Q.setElement(i,k,Q.getElement(i,k) / nrm);
		            }
		            Q.setElement(k,k,Q.getElement(k,k)+1);
		
		            // Apply transformation to remaining columns.
		            for (var j:int = k+1; j < n; j++) {
		               var s:Number = 0.0; 
		               for (i = k; i < m; i++) {
		                  s += Q.getElement(i,k)*Q.getElement(i,j);
		               }
		               s = -s/Q.getElement(k,k);
		               for (i = k; i < m; i++) {
		                  Q.setElement(i,j,Q.getElement(i,j) + s*Q.getElement(i,k));
		               }
		            }
		         }
		         R[k] = -nrm;
		      }
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

	}
	
}