/**
 * A Matrix class to make matrix operations easier.
 * Caches results to a MatrixCache object.
 * @author Danny Miller
 * @date 2008
 */
package src
{	
	import src.Dimensions.IMatrixDimension;
	import src.Dimensions.Matrix2x2;
	import src.Dimensions.Matrix3x3;
	import src.Dimensions.MatrixMxM;
	import src.Dimensions.MatrixMxN;
	import src.errors.MatrixLockError;
	
	public class Matrix
	{
		private var columnVectors:Array;
		private var rowVectors:Array;
		private var columns:int;
		private var rows:int;
		public var MatrixDimension:IMatrixDimension;
		//
		public var Cache:MatrixCache;

		private var locked:Boolean;
		public function Matrix()
		{
			columnVectors = new Array();
			Cache = new MatrixCache();
			columns = 0;
			rows = 0;
			unlock();
		}
		/**
		 * @param v A column vector.
		 */
		public function addVector(v:Vector):void
		{
			if (lock == true)
			{
				throw new MatrixLockError("Matrix must be unlocked before addition of new vectors.");
				return;
			}
			columnVectors.push(v);	
			var vsize:int = getColumn(columnVectors.length-1).size();
			
			if (vsize > rows)
			{
				rows = vsize;
			}
			columns++;
		}
		public function jacobi():Matrix
		{
			return MatrixDimension.jacobi();
		}
		public function jacobiNoSort():Matrix
		{
			return MatrixDimension.jacobiNoSort();
		}
		/**
		 * Clears the cache. Garbage collection should take care of clearing it from memory after a few frames.
		 */
		public function clearCache():void
		{
			Cache = new MatrixCache();
		}
		/**
		 * This function generates the rowVector array. Should be called after all the vectors have been added.
		 * Be sure to unlock the matrix before adding new vectors.
		 */
		public function lock():void
		{
			if (locked)
			{
				trace("Warning... Already locked. Locking function terminated.");
				return;
			}
			updateRowVectors();
			/**
			 * If this matrix is 2x2, then there are formulas that solve certain functions faster
			 */
			if (rows == 2 && columns == 2)
			{
				MatrixDimension = new Matrix2x2(this);
			}
			else if (rows == 3 && columns == 3)
			{
				MatrixDimension = new Matrix3x3(this);
			}
			else if (rows == columns)
			{
				MatrixDimension = new MatrixMxM(this);
			}
			locked = true;
		}
		
		private function updateRowVectors():void
		{
			rowVectors = new Array();
			for (var g:int = 0; g < rows; g++)
			{
				rowVectors.push(getRowFromColumns(g));
			}
		}
		private function updateColumnVectors():void
		{
			columnVectors = new Array();
			for (var i:int = 0; i < columns; i++)
			{
				columnVectors.push(getColumnFromRows(i));
			}
		}
		public function swapRows(index1:int,index2:int):void
		{			
			var t:Vector = getRow(index1).clone();
			this.rowVectors[index1] = getRow(index2).clone();
			this.rowVectors[index2] = t;
			updateColumnVectors();
		}
		public function clone():Matrix
		{
			var newMatrix:Matrix = new Matrix();
			var tempS:int = numColumns();
			for (var i:int = 0; i < tempS;i++)
			{
				newMatrix.addVector(getColumn(i).clone());
			}
			newMatrix.lock();
			return newMatrix;
		}
		public function unlock():void
		{
			MatrixDimension = new MatrixMxN(this);
			Cache = new MatrixCache();
			
			locked = false;
		}
		public function kernal():Matrix
		{
			if (Cache.kernalCache != null)
			{
				return Cache.kernalCache;
			}
			Cache.kernalCache = MatrixDimension.kernal();
			return Cache.kernalCache;
		}
		public function determinant():Number
		{
			if (Cache.determinantCache != Number.NEGATIVE_INFINITY)
			{
				return Cache.determinantCache;
			}
			Cache.determinantCache = MatrixDimension.determinant();
			return Cache.determinantCache;	
		}
		public function eigenvalues():Vector
		{
			if (Cache.eigenvaluesCache != null)
			{
				return Cache.eigenvaluesCache;
			}
			Cache.eigenvaluesCache = MatrixDimension.eigenValues();
			return Cache.eigenvaluesCache;
		}
		public function eigenvectors():Matrix
		{
			if (Cache.eigenvectorsCache != null)
			{
				return Cache.eigenvectorsCache;
			}
			Cache.eigenvectorsCache = MatrixDimension.eigenVectors();
			return Cache.eigenvectorsCache;
		}
		public function diagonalize():Matrix
		{
			return MatrixDimension.diagonalize();
		}
		public function singularValues():Vector
		{
			if (Cache.singularvaluesCache != null)
			{
				return Cache.singularvaluesCache;
			}
			Cache.singularvaluesCache = MatrixDimension.singularValues(); 
			return Cache.singularvaluesCache;
		}
		public function equals(other:Matrix):Boolean
		{
			if (numColumns() != other.numColumns() && numRows() != other.numRows())
			{
				return false;
			}
			return MatrixDimension.equals(other);
		}
		public function getElement(r:int,c:int):Number
		{
			 return getRow(r).getIndex(c);
		}
		public function setElement(r:int,c:int,value:Number):void
		{
			getRow(r).setValue(c,value);
			getColumn(c).setValue(r,value);
		}
		public function transpose():Matrix
		{
			if (Cache.transposeCache != null)
			{
				return Cache.transposeCache;
			}
			Cache.transposeCache = MatrixDimension.transpose(); 
			return Cache.transposeCache;
		}
		public function rowReduced():Matrix
		{
			if (Cache.rowReducedCache != null)
			{
				return Cache.rowReducedCache;
			}
			Cache.rowReducedCache = MatrixDimension.rowReduced();
			return Cache.rowReducedCache;
		}
		public function inverse():Matrix
		{
			if (Cache.inverseCache != null)
			{
				return Cache.inverseCache;
			}
			Cache.inverseCache = MatrixDimension.inverse(); 
			return Cache.inverseCache;
		}
		public function add(...Matrices):Matrix
		{
			return MatrixDimension.add(Matrices);
		}
		public function subtract(...Matrices):Matrix
		{
			return MatrixDimension.subtract(Matrices);
		}
		public function multiplyScalar(n:Number):Matrix
		{
			var newMatrix:Matrix = new Matrix();
			var c:int = numColumns();
			for (var i:int = 0; i < c; i++)
			{
				newMatrix.addVector(this.getColumn(i).multiply(n));
			} 
			newMatrix.lock();
			return newMatrix;
		}
		public function multiply(...Matrices):Matrix
		{
			return MatrixDimension.multiply(Matrices);
		}
		public function solve(B:Matrix):Matrix
		{
			return MatrixDimension.solve(B);
		}
		public function getRow(rowIndex:int):Vector
		{
			return rowVectors[rowIndex];
		}
		private function getRowFromColumns(rowIndex:int):Vector
		{
			var vec:Vector = new Vector();
			for (var i:int = 0; i < columns; i++)
			{
				var temp:Number = getColumn(i).getIndex(rowIndex);
				vec.push(temp);
			}
			return vec;
		}
		
		public function getColumnVectors():Array{
			return columnVectors;
		}
		
		private function getColumnFromRows(columnIndex:int):Vector
		{
			var vec:Vector = new Vector();
			for (var i:int = 0; i < rows; i++)
			{
				var temp:Number = getRow(i).getIndex(columnIndex);
				vec.push(temp);
			}
			return vec;
		}
		public function setRow(index:int,row:Vector):void
		{
			rowVectors[index] = row;
			updateColumnVectors();
		}
		public function getColumn(index:int):Vector
		{
			return columnVectors[index];
		}
		public function numColumns():int
		{
			return columns;
		}
		public function numRows():int
		{
			return rows;
		}
		public function toString():String
		{
			if (this.locked == false)
			{
				throw new MatrixLockError("Matrix must be locked before toString can be called");
			}
			var s:String = "";
			for (var i:int = 0; i <rows; i++)
			{
				s+=(rowVectors[i].toString())+"\n";
			}
			return s;
		}
		public function off():Number
		{
			return MatrixDimension.off();
		}
		public static function identity(size:int = 2):Matrix
		{
			var m:Matrix = new Matrix();
			for (var i:int = 0; i < size; i++)
			{
				var v:Vector = new Vector();
				for (var g:int = 0; g < i; g++)
				{
					v.push(0);
				}
				v.push(1);
				for (g; g < size-1; g++)
				{
					v.push(0);
				}
				m.addVector(v);
			}
			m.lock();
			return m;
		}
	}
}