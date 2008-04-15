package {
    
    
    import flash.display.Sprite;
    
    import src.Matrix;
    import src.Vector;
    public class Test extends Sprite
    {
        public function Test()
        {
        	

			var t:Matrix = new Matrix();
			t.addVector(new Vector(3,4,-6,4));
            t.addVector(new Vector(1,-1,8,4));	
            t.lock();
            trace("Orig: \n"+t);
            t.singularValueDecomposition();         
        }
    }

}