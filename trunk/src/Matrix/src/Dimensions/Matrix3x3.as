package src.Dimensions
{
	import src.Matrix;
	
	public class Matrix3x3 extends MatrixMxM
	{
		public function Matrix3x3(ref:Matrix)
		{
			super(ref);
		}
		public override function determinant():Number
		{
			var a:Number = MatrixReference.getColumn(0).getIndex(0);
			var b:Number = MatrixReference.getColumn(1).getIndex(0);
			var c:Number = MatrixReference.getColumn(2).getIndex(0);
			var d:Number = MatrixReference.getColumn(0).getIndex(1);
			var e:Number = MatrixReference.getColumn(1).getIndex(1);
			var f:Number = MatrixReference.getColumn(2).getIndex(1);
			var g:Number = MatrixReference.getColumn(0).getIndex(2);
			var h:Number = MatrixReference.getColumn(1).getIndex(2);
			var i:Number = MatrixReference.getColumn(2).getIndex(2);
			return a*e*i-a*f*h-b*d*i+b*f*g+c*d*h-c*e*g;
		}
	}
}