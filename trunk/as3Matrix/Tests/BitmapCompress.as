package Tests{
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.URLRequest;

    public class BitmapCompress extends Sprite {
        private var url:String = "http://www.uni-regensburg.de/Fakultaeten/phil_Fak_II/Psychologie/Psy_II/beautycheck/english/virtuelle/w(57-64).jpg";
        private var size:uint = 80;

        public function BitmapCompress() {
            configureAssets();
        }

        private function configureAssets():void {
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

            var request:URLRequest = new URLRequest(url);
            loader.x = size * numChildren;
            loader.load(request);
            addChild(loader);
        }

        private function duplicateImage(original:Bitmap):Bitmap {
            var image:Bitmap = new Bitmap(original.bitmapData.clone());
            image.x = size * numChildren;
            addChild(image);
            return image;
        }

        private function completeHandler(event:Event):void {
            var loader:Loader = Loader(event.target.loader);
            var image:Bitmap = Bitmap(loader.content);
            var tempW:int = image.width;
            var tempH:int = image.height;
            for (var i:int = 0; i < tempW; i++)
            {
            	for (var j:int = 0; j < tempH; j++)
            	{
            		//trace(image.bitmapData.getPixel(i,j));
            	}
            }
/*
            var duplicate:Bitmap = duplicateImage(image);
            var bitmapData:BitmapData = duplicate.bitmapData;
            var sourceRect:Rectangle = new Rectangle(0, 0, bitmapData.width, bitmapData.height);
            var destPoint:Point = new Point();
            var operation:String = ">=";
            var threshold:uint = 0xCCCCCCCC;
            var color:uint = 0xFFFFFF00;
            var mask:uint = 0x000000FF;
            var copySource:Boolean = true;

            bitmapData.threshold(bitmapData,
                                 sourceRect,
                                 destPoint,
                                 operation,
                                 threshold,
                                 color,
                                 mask,
                                 copySource);*/
        }
        
        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("Unable to load image: " + url);
        }
    }
}
