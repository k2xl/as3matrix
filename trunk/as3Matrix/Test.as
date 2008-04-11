package {
    
    
    import flash.display.Sprite;
    
    import src.Matrix;
    import src.Vector;
    public class Test extends Sprite
    {
        public function Test()
        {
			var t:Matrix = new Matrix();
			t.addVector(new Vector(2,2,0));
            t.addVector(new Vector(0,1,0));	
            t.lock();
            trace("Orig: \n"+t);
            t.singularValueDecomposition();
               
        }
    }

}