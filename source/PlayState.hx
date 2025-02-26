package;

class PlayState extends FlxState
{
	final musVolume:Float = .35;
	final musAmount:Int = 3;

	override public function create()
	{
		bgColor = 0xFFA2A2A2;

		openSubState(new DialogueSubstate('intro', function():Void
		{
			FlxG.sound.playMusic(Paths.music('ran_' + FlxG.random.int(1, musAmount)), 0);
			FlxG.sound.music.fadeIn(1.5, 0, musVolume);

			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				openSubState(new DialogueSubstate('introPostMusic', function():Void
				{
					FlxG.sound.music.volume = 0;

					var brb:FlxSprite = new FlxSprite().loadGraphic(Paths.image('brb'));
					brb.setGraphicSize(FlxG.width, FlxG.height);
					brb.updateHitbox();
					brb.antialiasing = true;
					add(brb);

					FlxG.sound.play(Paths.sound('brb'), 1.3);

					new FlxTimer().start(7.93, function(tmr:FlxTimer)
					{
						brb.destroy();
						FlxG.sound.music.volume = musVolume;

						openSubState(new DialogueSubstate('true1', function():Void
						{
							FlxG.sound.music.volume = 0;

							var fade:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
							add(fade);

							fade.alpha = 0;
							FlxTween.tween(fade, {alpha: .6}, .5);

							FlxG.sound.play(Paths.sound('drumroll'), 1.3);

							new FlxTimer().start(5.5, function(tmr:FlxTimer)
							{
								camera.flash();
								fade.destroy();

								new FlxTimer().start(1.5, function(tmr:FlxTimer)
								{
									FlxG.sound.music.volume = musVolume;

									openSubState(new DialogueSubstate('luigi', function():Void
									{
										openSubState(new DialogueSubstate('postLuigi', function():Void
										{
											openSubState(new DialogueSubstate('true2', function():Void
											{
												FlxG.sound.music.volume = 0;

												var fade:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
												add(fade);

												fade.alpha = 0;
												FlxTween.tween(fade, {alpha: .6}, .5);

												FlxG.sound.play(Paths.sound('drumroll'), 1.3);

												new FlxTimer().start(5.5, function(tmr:FlxTimer)
												{
													camera.flash();
													fade.destroy();

													new FlxTimer().start(1.5, function(tmr:FlxTimer)
													{
														FlxG.sound.playMusic(Paths.music('outersmassacre'), musVolume);

														openSubState(new DialogueSubstate('outer', function():Void
														{
															FlxG.sound.playMusic(Paths.music('ran_' + FlxG.random.int(1, musAmount)), 0);
															FlxG.sound.music.fadeIn(1.5, 0, musVolume);

															openSubState(new DialogueSubstate('postOuter', function():Void
															{
																openSubState(new DialogueSubstate('true3', function():Void{
																	FlxG.sound.music.volume = 0;

																	var fade:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
																	add(fade);

																	fade.alpha = 0;
																	FlxTween.tween(fade, {alpha: .6}, .5);

																	FlxG.sound.play(Paths.sound('drumroll'), 1.3);

																	new FlxTimer().start(5.5, function(tmr:FlxTimer)
																	{
																		camera.flash();
																		fade.destroy();

																		new FlxTimer().start(1.5, function(tmr:FlxTimer)
																		{
																			FlxG.sound.music.volume = musVolume;

																			openSubState(new DialogueSubstate('chip', function():Void
																			{
																				openSubState(new DialogueSubstate('postChip', function():Void
																				{
																					openSubState(new DialogueSubstate('finale', function():Void
																					{
																						openSubState(new DialogueSubstate('budgetCut', function():Void
																						{
																							FlxG.switchState(new CreditsState());
																						}));
																					}));
																				}));
																			}));
																		});
																	});
																}));
															}));
														}));
													});
												});
											}));
										}));
									}));
								});
							});
						}));
					});
				}));
			});
		}));

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
