package;

class Utilities
{
	// this shit took me 4 hours :(
	public static function dataFromTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];
		if (FileSystem.exists(path))
			daList = File.getContent(path).split('\n');

		return daList;
	}
}
