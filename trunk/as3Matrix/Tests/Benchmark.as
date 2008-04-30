package Tests
{
    import flash.utils.getTimer;
    
    import src.math.as3Matrix.Matrix;
    import src.math.as3Matrix.Vector;
    
    public class Benchmark
    {
        public static function Test():void
        {

            

            var st:int = getTimer();
            var a:Matrix = new Matrix();
            var b:Matrix = new Matrix();
            for (var g:int = 0; g < 1000; g++)
            {
                var v:Vector = new Vector();
                for (var i:int = 0; i < 1000; i++)
                {
                    v.push(Math.random());
                }
                a.addVector(v);
            }
            // AS3 scope is a bit different
            for (g = 0; g < 1000; g++)
            {
                var v2:Vector = new Vector();
                for (i = 0; i < 1000; i++)
                {
                    v2.push(Math.random());
                }
                b.addVector(v2);
            }
            a.lock();
            b.lock();
            st = getTimer()-st;
            trace("done in "+st/1000+" seconds");
        }

    }
}}