package src.errors
{
	public class MatrixError extends Error
	{
		public function MatrixError(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}