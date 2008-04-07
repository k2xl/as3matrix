package src
{
	import flash.net.ObjectEncoding;
	import flash.utils.ByteArray;
	
	public class Vector
	{
		// I would extend Array, but Flash has bizare problems with extending it since it has overloaded functions... At least with AS2 it did.
		private var vec:Array;
		public function Vector(...values:*)
		{
			vec = values;
		}
		public function setValue(index:int,value:Number):void
		{
			vec[index] = value;
		}
		public function dot(other:Vector):Number
		{
			var product:Number = 0;
			var tempS:int = other.size();
			for (var i:int = 0; i < tempS; i++)
			{
				product += getIndex(i)*other.getIndex(i);
			}
			return product;
		}
		public function outer(other:Vector):Matrix
		{
			var newMatrix:Matrix = new Matrix();
			var tempS:int = size();
			var tempS2:int = other.size();
			for (var i:int = 0; i < tempS2; i++)
			{
				var newVector:Vector = new Vector();
				var e1:Number = other.vec[i];
				for (var g:int = 0; g < tempS; g++)
				{
					var e2:Number = this.vec[g]; // private access is okay here since we're in Vector class
					newVector.push(e1*e2);
				}
				newMatrix.addVector(newVector);
			}
			return newMatrix;
		}
		public function push(val:Number):void
		{
			vec.push(val);
		}
		public function getIndex(i:int):Number
		{
			return vec[i];
		}
		public function clone():Vector
		{
			var newVec:Vector = new Vector();
			var tempS:int = vec.length;
			for (var i:int = 0; i < tempS;i++)
			{
				newVec.push(vec[i]);
			}
			return newVec;
		}
		public function addVector(other:Vector):Vector
		{
			var newVec:Vector = new Vector();
			var tempS:int = vec.length;
			for (var i:int = 0; i < tempS;i++)
			{
				newVec.push(vec[i]+other[i]);
			}
			return newVec;
		}
		
		
		public function subtractVector(other:Vector):Vector
		{
			if (size() != other.size())
			{
				return null;
			}
			var newVec:Vector = new Vector();
			var tempS:int = size();
			for (var i:int = 0; i < tempS;i++)
			{
				newVec.push(vec[i]-other.getIndex(i));
			}
			return newVec;
		}
		public function multiply(scalar:Number):Vector
		{
			var newVec:Vector = new Vector();
			var tempS:int = vec.length;
			for (var i:int = 0; i < tempS;i++)
			{
				newVec.push(vec[i]*scalar);
			}
			return newVec;
		}
		public function add(scalar:Number):Vector
		{
			var newVec:Vector = new Vector();
			var tempS:int = vec.length;
			for (var i:int = 0; i < tempS;i++)
			{
				newVec.push(vec[i]+scalar);
			}
			return newVec;
		}
		
		public function equals(v:Vector):Boolean{
			for(var i:Object in this.vec){
				if(this.vec[i] != v.vec[i]){
					return false;
				}
			}
			return true;
		}
		
		public function size():int
		{
			return vec.length;
		}
		public function toString():String
		{
			return ""+vec.toString();
		}
	}
}