package src
{
	public class MatrixCache
	{
		public var eigenvaluesCache:Vector;
		public var determinantCache:Number;
		public var eigenvectorsCache:Matrix;
		public var singularvaluesCache:Vector;
		public var transposeCache:Matrix;
		public var inverseCache:Matrix;
		public var rowReducedCache:Matrix;
		public var kernalCache:Matrix;
		public function MatrixCache()
		{
			eigenvaluesCache = null;
			determinantCache = Number.NEGATIVE_INFINITY;
			eigenvectorsCache = null;
			singularvaluesCache = null;
			transposeCache = null;
			inverseCache = null;
			rowReducedCache = null;
			kernalCache = null;
			
		}

	}
}