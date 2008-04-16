package src
{
	import flash.net.ObjectEncoding;
	import flash.utils.ByteArray;
	
	public dynamic class Vector extends Array
	{
		// I would extend Array, but Flash has bizare problems with extending it since it has overloaded functions... At least with AS2 it did.
		//public var vec:Array;
		public function Vector(...args:*)
		{
			//super();
			var n:uint = args.length
			if (n == 1 && (args[0] is Number))
			{
				var dlen:Number = args[0];
				var ulen:uint = dlen;
				if (ulen != dlen)
				{
					throw new RangeError("Array index is not a 32-bit unsigned integer ("+dlen+")");
				}
		        length = ulen;
			}
			else
			{
				length = n;
				for (var i:int=0; i < n; i++)
				{
					this[i] = args[i] 
				}
			}
		}
		public function dot(other:Vector):Number
		{
			var product:Number = 0;
			var tempS:int = other.length;
			for (var i:int = 0; i < tempS; i++)
			{
				product += this[i]*other[i];
			}
			return product;
		}
		public function outer(other:Vector):Matrix
		{
			var newMatrix:Matrix = new Matrix();
			var tempS:int = length;
			var tempS2:int = other.length;
			for (var i:int = 0; i < tempS2; i++)
			{
				var newVector:Vector = new Vector();
				var e1:Number = other[i];
				for (var g:int = 0; g < tempS; g++)
				{
					var e2:Number = this[g]; // private access is okay here since we're in Vector class
					newVector.push(e1*e2);
				}
				newMatrix.addVector(newVector);
			}
			newMatrix.lock();
			return newMatrix;
		}
		
		public function clone():Vector
		{
			var newVec:Vector = new Vector();
			var tempS:int = length;
			
			for (var i:int = 0; i < tempS;i++)
			{
				newVec.push(this[i]);
			}
			return newVec;
		}
		public function addVector(other:Vector):Vector
		{
			var newVec:Vector = new Vector();
			var tempS:int = length;
			for (var i:int = 0; i < tempS;i++)
			{
				newVec.push(this[i]+other[i]);
			}
			return newVec;
		}
		
		
		public function subtractVector(other:Vector):Vector
		{
			if (length != other.length)
			{
				return null;
			}
			var newVec:Vector = new Vector();
			var tempS:int = length;
			for (var i:int = 0; i < tempS;i++)
			{
				newVec.push(this[i]-other[i]);
			}
			return newVec;
		}
		public function multiply(scalar:Number):Vector
		{
			var newVec:Vector = new Vector();
			var tempS:int = length;
			for (var i:int = 0; i < tempS;i++)
			{
				newVec.push(this[i]*scalar);
			}
			return newVec;
		}
		public function add(scalar:Number):Vector
		{
			var newVec:Vector = new Vector();
			var tempS:int = this.length;
			for (var i:int = 0; i < tempS;i++)
			{
				newVec.push(this[i]+scalar);
			}
			return newVec;
		}
		
		public function equals(v:Vector):Boolean{
			for(var i:Object in this){
				if(this[i] != v[i]){
					return false;
				}
			}
			return true;
		}
		public function normalize():Vector
		{
			var temp:Vector = clone();
			var sum:Number = 0;
			var tempS:int = length;
			for (var i:int = 0; i < tempS; i++)
			{
				sum+=this[i]*this[i];
			}
			return temp.multiply(1/Math.sqrt(sum));
		}
		
	}
}