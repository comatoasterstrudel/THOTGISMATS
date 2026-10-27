package;

class Utilities
{
	// this shit took me 4 hours :(
	//LOLL NOOB
	public static function dataFromTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];
		if (OpenFlAssets.exists(path))
			daList = OpenFlAssets.getText(path).split('\n');

		return daList;
	}

	#if windows
	public static var font:String = "assets/fonts/andy.ttf";
	#end
	#if html5
	public static var font:String = "Andy Bold"; // wtf
	#end
}
