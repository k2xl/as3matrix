package src.Decompositions
{
	import src.Matrix;
	
	public class SVD
	{
		public var V:Matrix;
		public var Ut:Matrix;
		public var D:Matrix;
		public function SVD()
		{
			V = new Matrix();
			Ut = new Matrix();
			D = new Matrix();
		}
		public function toString():String
		{
			var Sum:Matrix = new Matrix();
			var tempS:int = D.numColumns();
			Sum = V.getColumn(0).multiply(D.getElement(0,0)).outer(Ut.getColumn(0));
			for (var i :int = 1; i < tempS;i++)
			{
				Sum.add(V.getColumn(i).multiply(D.getElement(i,i)).outer(Ut.getColumn(i)));
			}
			return ("V = \n"+V+"\nUt = \n"+Ut+"\nD = \n"+D+"\nUVtD = \n"+Sum); 
		}

	}
}