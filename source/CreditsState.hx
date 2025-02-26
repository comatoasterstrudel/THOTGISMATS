package;

class CreditsState extends FlxState
{
	var crediotarray:Array<String> = [
		'Music:\n\nChill (Instrumental) - FNF: ComaVerse\nSittin Outside - Five Nights at Loooogis Collection\nNothing to worry about - Five Nights at Loooogis Collection\nBeachlands - Super Luigi World\nAt Dooms Gate - Doom\nFuniculi Holiday - Pizza Tower',
		'Art:\n\nEverything but the special guests, and budget cut art was made by me :}',
		'Programming:\n\nEverything was coded by me :}',
		'Writing:\n\nEverything but the special guests was written by me :}',
		'Bye Bye\n\nYou can leave now\nty for playing :}'
	];

	override public function create()
	{
		FlxG.sound.playMusic(Paths.music('credit'), .4);

		bgColor = 0xFF000000;

		var fun:FlxSprite = new FlxSprite();
		fun.frames = Paths.getSparrowAtlas('credawesome');
		fun.animation.addByPrefix('idle', 'credawesome idle', 2);
		fun.animation.play('idle');
		fun.setGraphicSize(Std.int(fun.width * 0.75));
		fun.antialiasing = true;
		fun.updateHitbox();
		fun.x = 0;
		add(fun);

		var nameText = new FlxText(0, 0, 0, crediotarray[0], 40);
		nameText.setFormat(Paths.font("Andy.ttf"), 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		nameText.borderSize = 2;
		nameText.antialiasing = true;
		nameText.screenCenter();
		nameText.scrollFactor.set();
		add(nameText);

		for (i in 0...crediotarray.length)
		{
			new FlxTimer().start(5 * i, function(tmr:FlxTimer)
			{
				nameText.text = crediotarray[i];
				nameText.screenCenter();
			});
		}
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
