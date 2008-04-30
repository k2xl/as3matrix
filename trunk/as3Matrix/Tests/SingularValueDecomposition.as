package {
    
    
    import flash.display.Sprite;
    
    import src.math.as3Matrix.Matrix;
    import src.math.as3Matrix.Vector;
    public class Test extends Sprite
    {
        public function Test()
        {
			var t:Matrix = new Matrix();
			t.addVector(new Vector(4,8,2,9,5));
            t.addVector(new Vector(8,3,5,4,2));
            t.addVector(new Vector(1,2,3,4,5));	
            t.addVector(new Vector(1,2,3,4,5));	
            t.lock();
            t.singularValueDecomposition();
               
        }
    }

}