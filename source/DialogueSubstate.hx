package;

class DialogueSubstate extends FlxSubState
{
	var fadeSprite:FlxSprite;
	var diaBox:FlxSprite;
	var diaText:FlxTypeText;

	var portaitGroup:FlxTypedGroup<FlxSprite>;
	var diaPortrait:FlxSprite;

	var dialogueData:Array<String>;
	var fileName:String;
	var curLine:Int = 0;
	var maxLines:Int;

	var controlAllowed:Bool = false;

	var twitcher:Bool;
	var globalcounter:Int;

	var fadetween:FlxTween;

	public static var dialogueActive:Bool = false;

	var finishCallback:Void->Void = null;

	public function new(dialogueFileName:String, ?finishthing:Void->Void)
	{
		dialogueActive = true;

		if (finishthing != null)
			finishCallback = finishthing;

		fileName = 'dialogue/dia_' + dialogueFileName;
		if (!FileSystem.exists(Paths.txt(fileName)))
			fileName = 'dialogue/dia_test';

		dialogueData = Utilities.dataFromTextFile(Paths.txt(fileName));

		maxLines = dialogueData.length - 1;

		super();
	}

	override function create()
	{
		fadeSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF393939);
		fadeSprite.alpha = 0;
		add(fadeSprite);

		portaitGroup = new FlxTypedGroup<FlxSprite>();
		add(portaitGroup);

		diaBox = new FlxSprite().loadGraphic(Paths.image('dialogueBox'));
		diaBox.setGraphicSize(Std.int(diaBox.width * 1.2));
		diaBox.updateHitbox();
		diaBox.setPosition(FlxG.width / 2 - diaBox.width / 2, FlxG.height - diaBox.height - 30);
		diaBox.antialiasing = true;
		add(diaBox);

		diaText = new FlxTypeText(0, diaBox.y + 35, Std.int(diaBox.width - 50), 'WOAHAAAHHAHAHAHAHA', 40);
		diaText.setFormat(Paths.font("Andy.ttf"), 40, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		diaText.borderSize = 2;
		diaText.antialiasing = true;
		diaText.screenCenter(X);
		add(diaText);

		var dialogueDataArray:Array<String> = dialogueData[curLine].split(":");

		if (dialogueDataArray[5] == 'bad')
		{
			diaText.font = Paths.font('uglysans.ttf');
			diaText.size = 70;
			diaBox.loadGraphic(Paths.image('b_dialogueBox'));
		}
		else
		{
			diaText.font = Paths.font('Andy.ttf');
			diaText.size = 40;
			diaBox.loadGraphic(Paths.image('dialogueBox'));
		}

		initialize();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (controlAllowed)
		{
			if (twitcher && diaPortrait != null)
			{
				globalcounter++;

				var dialogueDataArray:Array<String> = dialogueData[curLine].split(":");

				if (globalcounter % 14 == 0 && dialogueDataArray[5] == 'flip' || globalcounter % 7 == 0 && dialogueDataArray[5] == 'flipfast')
					diaPortrait.flipX = !diaPortrait.flipX;
			}

			if (FlxG.keys.justReleased.Z)
			{
				loadNextLine(1);
			}
		}

		super.update(elapsed);
	}

	function loadNextLine(amount:Int):Void
	{
		if (amount > 0)
			FlxG.sound.play(Paths.sound('close'), 1);

		if (curLine >= maxLines)
		{
			exit();
		}
		else
		{
			curLine += amount;

			var dialogueDataArray:Array<String> = dialogueData[curLine].split(":");
			var textSpeed:Float = Std.parseFloat(dialogueDataArray[1]);

			if (fadetween != null)
			{
				fadetween.cancel();
				fadetween.destroy();
			}

			if (diaPortrait != null)
				diaPortrait.destroy();

			if (dialogueDataArray[2] != '')
			{
				var prefix:String = 'portraits/';
				if (dialogueDataArray[5] == 'bad')
					prefix = 'portraits/b_';

				diaPortrait = new FlxSprite().loadGraphic(Paths.image(prefix + dialogueDataArray[2]));
				diaPortrait.setGraphicSize(Std.int(diaBox.width * .31));
				diaPortrait.updateHitbox();
				diaPortrait.setPosition(diaBox.x + diaBox.width - diaPortrait.width * 1.5, diaBox.y - diaPortrait.height);
				diaPortrait.antialiasing = true;
				portaitGroup.add(diaPortrait);
			}

			var textName:String = 'default';

			if (dialogueDataArray[3] != '' && dialogueDataArray[3] != null)
			{
				textName = dialogueDataArray[3];
			}

			if (dialogueDataArray[4] == 'left')
			{
				diaPortrait.setPosition(diaBox.x + diaPortrait.width * .5, diaBox.y - diaPortrait.height);
				diaPortrait.flipX = true;
			}
			else if (dialogueDataArray[4] == 'right')
			{
				diaPortrait.setPosition(diaBox.x + diaBox.width - diaPortrait.width * 1.5, diaBox.y - diaPortrait.height);
			}

			if (dialogueDataArray[5] == 'flip' || dialogueDataArray[5] == 'flipfast')
			{
				twitcher = true;
				globalcounter = 0;
			}
			else
			{
				twitcher = false;
			}

			if (dialogueDataArray[5] == 'fade')
			{
				fadetween = FlxTween.tween(diaPortrait, {alpha: 0}, 2);
			}

			if (dialogueDataArray[5] == 'mute')
			{
				FlxG.sound.music.volume = 0;
			}

			if (dialogueDataArray[6] == 'skip')
			{
				diaText.completeCallback = function():Void
				{
					exit();
				};
			}

			diaText.sounds = [FlxG.sound.load(Paths.sound('text_' + textName), 1)];
			diaText.resetText(dialogueDataArray[0]);
			diaText.start(textSpeed, false, false);
		}
	}

	inline function initialize():Void
	{
		var scale:Array<Float> = [diaBox.scale.x, diaBox.scale.y];

		diaBox.scale.set(.01, 1.7);

		FlxTween.tween(fadeSprite, {alpha: .3}, .5);

		FlxTween.tween(diaBox.scale, {x: scale[0], y: scale[1]}, .5, {
			ease: FlxEase.quartInOut,
			onComplete: function(FlxTwn)
			{
				controlAllowed = true;
				loadNextLine(0);
			}
		});
	}

	inline function exit():Void
	{
		diaPortrait.destroy();

		diaText.visible = false;
		diaText.skip();
		controlAllowed = false;
		dialogueActive = false;

		FlxTween.tween(fadeSprite, {alpha: 0}, .5);

		FlxTween.tween(diaBox, {alpha: 0}, .5);
		FlxTween.tween(diaBox.scale, {x: .01, y: 1.7}, .5, {
			ease: FlxEase.quartInOut,
			onComplete: function(FlxTwn)
			{
				if (finishCallback != null)
					finishCallback();

				close();
			}
		});
	}
}
