package src.Dimensions
{
	import src.Decompositions.LU;
	import src.Decompositions.QR;
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
		function singularValueDecomposition():SVD;
		function LUDecomposition():LU;
		function QRDecomposition():QR;
		function kernal():Matrix;
		function solve(B:Matrix):Matrix;
		function equals(other:Matrix):Boolean;
		function isSymmetric():Boolean;
	}
}