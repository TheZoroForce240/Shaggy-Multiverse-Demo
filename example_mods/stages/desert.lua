function onCreate()

		makeLuaSprite('1','desertbg/1', -1700, -400);
		setLuaSpriteScrollFactor('1', 0.5, 0.5);
		scaleObject('1', 1.5, 1.5);

		makeLuaSprite('2','desertbg/2', -600, 0);
		setLuaSpriteScrollFactor('2', 0.7, 0.7);
		scaleObject('2', 1, 1);

		makeLuaSprite('3','desertbg/3', -900, 270);
		setLuaSpriteScrollFactor('3', 0.6, 0.6);
		scaleObject('3', 1, 1);

		makeLuaSprite('4','desertbg/4', -600, -400);
		setLuaSpriteScrollFactor('4', 1, 1);
		scaleObject('4', 1.3, 1.3);

	addLuaSprite('1', false);
	addLuaSprite('2', false);
	addLuaSprite('3', false);
	addLuaSprite('4', false);
end