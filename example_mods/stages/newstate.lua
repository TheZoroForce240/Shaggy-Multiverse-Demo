function onCreate()
	-- background shit
	makeLuaSprite('', '', -1400, -730);
	setScrollFactor('', 0.9, 0.9);
	
	makeLuaSprite('newstatebg', 'newstatebg', -1400, -730);
	setScrollFactor('newstatebg', 0.9, 0.9);
	scaleObject('newstatebg', 1, 1);

	makeAnimatedLuaSprite('','',-450,-260)addAnimationByPrefix('','dance','',24,true)
    objectPlayAnimation('','dance',false)
    setScrollFactor('', 0.8, 0.8);
	scaleObject('', 1, 1);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
		makeLuaSprite('', '', 400, -30);
		setScrollFactor('', 0.9, 0.9);
		scaleObject('', 1.1, 1.1);
		
		makeLuaSprite('', '', 1225, -100);
		setScrollFactor('', 0.9, 0.9);
		scaleObject('', 1.1, 1.1);
		setProperty('.flipX', true); --mirror sprite horizontally

		makeLuaSprite('', '', -500, -300);
		setScrollFactor('', 1.3, 1.3);
		scaleObject('', 0.9, 0.9);
	end

	addLuaSprite('', false);
	addLuaSprite('newstatebg', false);
	addLuaSprite('', false);
	addLuaSprite('', false);
	addLuaSprite('', false);
	addLuaSprite('', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end