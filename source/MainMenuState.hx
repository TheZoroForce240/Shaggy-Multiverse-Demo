package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.2h'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;


	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		FlxG.save.data.multiverse && FlxG.save.data.multiverse != null ? 'multiverse' : 'multiversebroken',
		'freeplay',
		//#if MODS_ALLOWED 'mods', #end
		//#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		//#if !switch 'donate', #end
		'options'
	];

	var starsUnlocked:Array<Bool> = [
		false,
		false,
		false
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	private static var demo:Bool = true;

	override function create()
	{

		if (demo)
		{
			optionShit[0] = 'multiversebroken';
			optionShit[1] = 'multiverse';
		}

		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		//add(magenta);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 2) {
			scale = 2 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			//var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * -13;
			var menuItem:FlxSprite = new FlxSprite(120, (i * 120)+75);

			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.setGraphicSize(400);
			menuItem.updateHitbox();

			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItems.add(menuItem);
			//var scr:Float = (optionShit.length - 4) * 0.135;
			//if(optionShit.length < 6) scr = 0;
			//menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			
			menuItem.scale.x = .5;
			menuItem.scale.y = .5;
		}

		//FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		if (FlxG.save.data.multiverse == null)
			FlxG.save.data.multiverse = false;
		if (FlxG.save.data.multiverseWeeks == null)
			FlxG.save.data.multiverseWeeks = false;
		if (FlxG.save.data.plusWeek == null)
			FlxG.save.data.plusWeek = false;

		checkStarUnlock();

		starsUnlocked = [
			FlxG.save.data.multiverse,
			FlxG.save.data.multiverseWeeks,
			FlxG.save.data.plusWeek
		];
		for (i in 0...starsUnlocked.length)
		{
			var star:FlxSprite = new FlxSprite(0,0);
			if (demo)
				star.loadGraphic(Paths.image('lockedstar'));
			else
				star.loadGraphic(Paths.image((starsUnlocked[i] ? 'star2' : 'star1')));
			star.x = FlxG.width-star.width;
			star.y = (star.height*i);
			add(star);
		}

		super.create();
	}

	public static function checkStarUnlock()
	{
		if (StoryMenuState.weekCompleted.exists('finale2'))
		{
			FlxG.save.data.multiverse = StoryMenuState.weekCompleted.get('finale2');
		}
		if (StoryMenuState.weekCompleted.exists('plus'))
		{
			FlxG.save.data.plusWeek = StoryMenuState.weekCompleted.get('plus');
			
		}

		var weeksToCheck = ['aftermath', 'battleScarred', 'dbz', 'desperate', 'extras', 'manga', 'mutated', 'ninja', 'nano', 'saiyanWarrior', 'scared', 'tired'];
		var allExist = true;
		for (i in weeksToCheck)
		{
			if (!StoryMenuState.weekCompleted.exists(i))
				allExist = false;
		}
		if (allExist)
		{
			//i hate this
			FlxG.save.data.multiverseWeeks = StoryMenuState.weekCompleted.get('aftermath') 
			&& StoryMenuState.weekCompleted.get('battleScarred')
			&& StoryMenuState.weekCompleted.get('dbz')
			&& StoryMenuState.weekCompleted.get('desperate')
			&& StoryMenuState.weekCompleted.get('extras')
			&& StoryMenuState.weekCompleted.get('manga')
			&& StoryMenuState.weekCompleted.get('mutated')
			&& StoryMenuState.weekCompleted.get('ninja')
			&& StoryMenuState.weekCompleted.get('nano')
			&& StoryMenuState.weekCompleted.get('saiyanWarrior')
			&& StoryMenuState.weekCompleted.get('scared')
			&& StoryMenuState.weekCompleted.get('tired');
		}

		FlxG.save.flush();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (FlxG.keys.justPressed.ONE)
			{
				if (FlxG.save.data.multiverse == null)
					FlxG.save.data.multiverse = true;
				else 
					FlxG.save.data.multiverse = !FlxG.save.data.multiverse;
				selectedSomethin = true;
				MusicBeatState.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else if (optionShit[curSelected] == 'multiversebroken')
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'multiverse':
										MusicBeatState.switchState(new MultiverseMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
									default: 
										selectedSomethin = false; //stop softlocking when theres no option
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
			spr.x = 120;
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			//spr.updateHitbox();
			spr.scale.x = .5;	
			spr.scale.y = .5;
			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				//var add:Float = 0;
				//if(menuItems.length > 4) {
				//	add = menuItems.length * 8;
				//}

				//camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				//spr.centerOffsets();
				spr.scale.x = .45;
				spr.scale.y = .45;
			}
			spr.x = 120;
			//spr.updateHitbox();
		});
	}
}
