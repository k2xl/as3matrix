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
		public var L:Matrix;
		public var U:Matrix;
		public var covarientCache:Matrix;
		public function MatrixCache()
		{
			covarientCache = null;
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