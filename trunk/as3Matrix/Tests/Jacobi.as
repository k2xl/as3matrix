package Tests
{
    import src.Matrix;
    import src.Vector;
    public class Jacobi
    {
        public static function Test():void
        {
            var OffArr:Array = new Array();
            var LN:Array = new Array();
            var OffArrX:Array = new Array();
            var LNX:Array = new Array();
            var sum:Number = 0;
            var count:int = 100;
            var rand:Array = new Array();
            for (var p:int = 0; p < count; p++)
            {
                rand.push(getRandom());
            }
            var m:Matrix;
            for (var j:int = 0; j <count; j++)
            {
                m = Matrix(rand[j]).clone();
                var lnOffA:Number = Math.log(m.off())/0.301029996;
                var lnOffB:Number = 0;
                for (var i:int = 0; i < 1000; i++)
                {
                    m = m.jacobi();
                    var o:Number = m.off();
                    //lnOffB= Math.log(o)/0.301029996;
                    //OffArr.push(lnOffB);
                    
                    if (o < 1e-10)
                    {
                        break;
                    }
                }
                sum+=i;
            }
            trace("Average Sorting = "+sum/count);            
            
            sum = 0;
            
            for (j = 0; j <count; j++)
            {
                m = Matrix(rand[j]).clone();
                lnOffB = 0;
                //var t:Matrix = m.clone();
                for (i = 0; i < 1000; i++)
                {
                    m = m.jacobiNoSort();
                    o= m.off();
                    //lnOffB = Math.log(o)/0.301029996;
                    //OffArrX.push(lnOffB);
                    if (o < 1e-10)
                    {
                        break;
                    }
                }
                sum+=i;
            }
            var tempS:int = OffArrX.length
            /*
            for (var k:int = 0; k < tempS; k++)
            {
                var TB:Number = k*-0.10536051565782630122750098083931+lnOffA;
                if (OffArr[k] == undefined)
                {
                    OffArr[k] = "";
                }
                trace(k+"\t"+OffArr[k]+"\t"+OffArrX[k]+"\t"+TB);
            }
            */

            trace("Average no Sorting = "+sum/count);
            trace("K\tbK\tbK (no sort)\tTheory Bound");
        }
        
        private static function getRandom():Matrix
        {
            var m:Matrix = new Matrix();
            // generate a 5x5 matrix
            var size:int = 5;
            for (var i:int = 0; i < size; i++)
            {
                var vec:Vector= new Vector();
                for (var j:int = 0; j < size; j++)
                {
                    vec.push(0);
                }
                m.addVector(vec);
            }
            m.lock();
            for (var n:int = 0; n < size; n++)
            {
                for (var p:int = n; p < size; p++)
                {
                    var num:Number = Math.floor(Math.random()*10);
                    m.setElement(n,p,num);
                    m.setElement(p,n,num);
                }
            }
            return m;
        }
    

    }
    
}