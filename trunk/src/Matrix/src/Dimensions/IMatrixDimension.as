package src.Dimensions
{
	import src.Decompositions.SVD;
	import src.Matrix;
	import src.Vector;
	
	public interface IMatrixDimension
	{
		function determinant():Number;
		function singularValues():Vector;
		function eigenValues():Vector;
		function eigenVectors():Matrix;
		function transpose():Matrix;
		function inverse():Matrix;
		function diagonalize():Matrix;
		function add(Matrices:Array):Matrix;
		function subtract(Matrices:Array):Matrix;
		function multiply(Matrices:Array):Matrix;
		function rowReduced():Matrix;
		function singularValueDecomposition():SVD
	}
}