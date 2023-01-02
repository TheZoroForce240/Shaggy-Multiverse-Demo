local beatsScaleX = {18,21.5,23,26,29.5}
local beatsScaleY = {16,19.5,20.5,22.5,24,27.5,28.5}
function onCreatePost()
    --luaDebugMode = true
    addHaxeLibrary('playfieldRenderer', 'modcharting')
    addHaxeLibrary('Vector3D', 'openfl.geom')
    addHaxeLibrary('Math')
    runHaxeCode([[
        game.playfieldRenderer = new PlayfieldRenderer(game.strumLineNotes, game.notes, game);
        game.playfieldRenderer.cameras = [game.camHUD];
        game.add(game.playfieldRenderer);
        game.remove(game.grpNoteSplashes);
        game.add(game.grpNoteSplashes);
    ]])

    addPlayfield(0,0,0)
    addPlayfield(0,0,0)
    
    startMod('PF1Alpha', 'StealthModifier', '', 1)
    startMod('PF2Alpha', 'StealthModifier', '', 2)

    startMod('PF1IA', 'IncomingAngleModifier', '', 1)
    startMod('PF2IA', 'IncomingAngleModifier', '', 2)
    setSubMod('PF1IA', 'y', 120)
    setSubMod('PF2IA', 'y', 240)

    setMod('PF1Alpha', 1)
    setMod('PF2Alpha', 1)

    startMod('xP2', 'XModifier', 'opponent', -1)
    startMod('xP1', 'XModifier', 'player', -1)
    
    startMod('boost', 'BoostModifier', '', -1)
    startMod('brake', 'BrakeModifier', '', -1)
    setMod('brake', 0.4)

    startMod('speed', 'SpeedModifier', '', -1)
    setMod('speed', 0.7)

    startMod('tipsy', 'TipsyYModifier', '', -1)
    startMod('drunkP1', 'DrunkXModifier', 'player', -1)
    startMod('drunkP2', 'DrunkXModifier', 'opponent', -1)

    startMod('beatYP1', 'BeatYModifier', 'player', -1)
    startMod('beatYP2', 'BeatYModifier', 'opponent', -1)

    startMod('beat', 'BeatXModifier', 'player', -1)

    startMod('reverseP2', 'ReverseModifier', 'opponent', -1)
    startMod('reverseP1', 'ReverseModifier', 'player', -1)

    startMod('incomingAngle', 'IncomingAngleModifier', '', -1)
    setSubMod('incomingAngle', 'x', 90)
    startMod('InvertIncomingAngle', 'Modifier', '', -1)

    startMod('flip', 'FlipModifier', '', -1)
    startMod('invert', 'InvertModifier', '', -1)

    startMod('alpha', 'StealthModifier', '', -1)

    startMod('opponentAlpha', 'StealthModifier', 'opponent', -1)

    startMod('scaleX', 'ScaleXModifier', '', -1)
    startMod('scaleY', 'ScaleYModifier', '', -1)
    startMod('drunk', 'DrunkXModifier', '', -1)
    setSubMod('drunk', 'speed', 10)


    runHaxeCode([[
        game.playfieldRenderer.modifiers.get("InvertIncomingAngle").incomingAngleMath = function(lane, curPos, pf)
        {
            if (lane % 2 == 0)
            {
                return [0, game.playfieldRenderer.modifiers.get("InvertIncomingAngle").currentValue+(curPos*0.015)];
            }
            return [0, -game.playfieldRenderer.modifiers.get("InvertIncomingAngle").currentValue-(curPos*0.015)];
        }
    ]])

    startMod('IncomingAngleSmooth', 'Modifier', '', -1)

    runHaxeCode([[
        game.playfieldRenderer.modifiers.get("IncomingAngleSmooth").incomingAngleMath = function(lane, curPos, pf)
        {
            return [0, game.playfieldRenderer.modifiers.get("IncomingAngleSmooth").currentValue+(curPos*0.015)];
        }
    ]])

    startMod('IncomingAngleCurve', 'Modifier', '', -1)

    runHaxeCode([[
        game.playfieldRenderer.modifiers.get("IncomingAngleCurve").incomingAngleMath = function(lane, curPos, pf)
        {
            return [0, game.playfieldRenderer.modifiers.get("IncomingAngleCurve").currentValue*(curPos*0.015)];
        }
    ]])


    startMod('AtomRotation', 'Modifier', '', -1)
    setMod('AtomRotation', 0)
    runHaxeCode([[

        game.playfieldRenderer.modifiers.get("AtomRotation").subValues.set('rotation', 0.0);
        
        game.playfieldRenderer.modifiers.get("AtomRotation").incomingAngleMath = function(lane, curPos, pf)
        {
            var angX = 0.0;
            var angY = 90.0;


            var rot = game.playfieldRenderer.modifiers.get("AtomRotation").subValues.get('rotation');

            if (lane%4 == 0)
            {
                angX = 90.0+(rot);
            }
            if (lane%4 == 1)
            {
                angY = 90.0+(rot);
            }
            if (lane%4 == 2)
            {
                angY = -90.0+(rot);
            }
            if (lane%4 == 3)
            {
                angX = -90.0+(rot);
            }

            return [angX, angY];
        }
        

        game.playfieldRenderer.modifiers.get("AtomRotation").noteMath = function(noteData, lane, curPos, pf)
        {
            var val = game.playfieldRenderer.modifiers.get("AtomRotation").currentValue;
            
            var angX = 90.0;
            var angY = 90.0;

            var rot = game.playfieldRenderer.modifiers.get("AtomRotation").subValues.get('rotation');

            if (lane%4 == 0)
            {
                angX = 180.0+(rot);
                noteData.x += 112*1.5*val;
            }
            if (lane%4 == 1)
            {
                angY = 90.0+(rot);
                noteData.x += 112*0.5*val;
            }
            if (lane%4 == 2)
            {
                angY = -90.0+(rot);
                noteData.x -= 112*0.5*val;
            }
            if (lane%4 == 3)
            {
                angX = 0.0+(rot);
                noteData.x -= 112*1.5*val;
            }


            noteData.z -= 250*val;

            if (ClientPrefs.downScroll)
                noteData.y -= 260*val;
            else
                noteData.y += 260*val;

                

            var pos = ModchartUtil.getCartesianCoords3D(angX,angY,200);

            noteData.x += pos.x*val;
            noteData.y += pos.y*val;
            noteData.z += pos.z*val;

            if (Math.abs(curPos) > 450)
                noteData.alpha = (500-Math.abs(curPos))/(500-450);
        }
        game.playfieldRenderer.modifiers.get("AtomRotation").strumMath = function(noteData, lane, pf)
        {
            var val = game.playfieldRenderer.modifiers.get("AtomRotation").currentValue;
            
            var angX = 90.0;
            var angY = 90.0;

            var rot = game.playfieldRenderer.modifiers.get("AtomRotation").subValues.get('rotation');

            if (lane%4 == 0)
            {
                angX = 180.0+(rot);
                noteData.x += 112*1.5*val;
            }
            if (lane%4 == 1)
            {
                angY = 90.0+(rot);
                noteData.x += 112*0.5*val;
            }
            if (lane%4 == 2)
            {
                angY = -90.0+(rot);
                noteData.x -= 112*0.5*val;
            }
            if (lane%4 == 3)
            {
                angX = 0.0+(rot);
                noteData.x -= 112*1.5*val;
            }


            noteData.z -= 250*val;

            if (ClientPrefs.downScroll)
                noteData.y -= 260*val;
            else
                noteData.y += 260*val;

            var pos = ModchartUtil.getCartesianCoords3D(angX,angY,200);

            noteData.x += pos.x*val;
            noteData.y += pos.y*val;
            noteData.z += pos.z*val;
        }
    ]])


    startMod('MoveYWaveShit', 'Modifier', '', -1)

    runHaxeCode([[
        game.playfieldRenderer.modifiers.get("MoveYWaveShit").noteMath = function(noteData, lane, curPos, pf)
            {
                var val = game.playfieldRenderer.modifiers.get("MoveYWaveShit").currentValue;

                noteData.y += 260*Math.sin(((Conductor.songPosition+curPos)*0.0008)+(lane/4))*val;
            }
            game.playfieldRenderer.modifiers.get("MoveYWaveShit").strumMath = function(noteData, lane, pf)
            {
                var val = game.playfieldRenderer.modifiers.get("MoveYWaveShit").currentValue;
                noteData.y += 260*Math.sin((Conductor.songPosition*0.0008)+(lane/4))*val;
            }
    ]])


    ease(31, 1, 'cubeInOut', [[
        0, brake,
        0.75, speed,
        1.5, beatYP1,
        -1.5, beatYP2,
        -300, z,
    ]])

    ease(64, 1, 'cubeInOut', [[
        -320, xP1,
        320, xP2,
        1, reverseP2,
        0.7, opponentAlpha
    ]])


    for i = 8,23 do 
        ease(i*4, 2, 'circIn', [[
            20, InvertIncomingAngle
        ]])
        ease((i*4)+2, 2, 'circOut', [[
            -20, InvertIncomingAngle
        ]])
        if i >= 16 then 
            if i % 2 == 1 then 
                ease(i*4, 4, 'circInOut', [[
                    30, incomingAngle:x,
                    100, z0,
                    50, z1,
                    -50, z2,
                    -100, z3,
                    100, z4,
                    50, z5,
                    -50, z6,
                    -100, z7,
                ]])
            else 
                ease(i*4, 4, 'circInOut', [[
                    -30, incomingAngle:x,
                    -100, z0,
                    -50, z1,
                    50, z2,
                    100, z3,
                    -100, z4,
                    -50, z5,
                    50, z6,
                    100, z7,
                ]])
            end
        end
        if i % 2 == 1 then 
            ease((i*4)+3, 1, 'circIn', [[
                0, confusion
            ]])
        else 
            ease(i*4, 1, 'circOut', [[
                360, confusion
            ]])
        end
    end

    ease(24*4, 1, 'cubeInOut', [[
        0, InvertIncomingAngle,
        30, IncomingAngleSmooth,
    ]])

    for i = 24,31 do 
        if i % 2 == 1 then 
            ease(i*4, 4, 'circInOut', [[
                15, incomingAngle:x,
                50, z0,
                25, z1,
                -25, z2,
                -50, z3,
                50, z4,
                25, z5,
                -25, z6,
                -50, z7,
            ]])

            ease(i*4, 2, 'cubeInOut', [[
                0, reverseP1,
                1, reverseP2
            ]])
        else 
            ease(i*4, 4, 'circInOut', [[
                -15, incomingAngle:x,
                -50, z0,
                -25, z1,
                25, z2,
                50, z3,
                -50, z4,
                -25, z5,
                25, z6,
                50, z7,
            ]])

            ease((i*4), 2, 'cubeInOut', [[
                1, reverseP1,
                0, reverseP2
            ]])
        end

        if i % 4 == 2 then
            ease(i*4, 2, 'cubeInOut', [[
                30, IncomingAngleSmooth,
            ]])
        elseif i % 4 == 0 then 
            ease(i*4, 2, 'cubeInOut', [[
                -30, IncomingAngleSmooth,
            ]])
        
        end

        if (i % 4 ~= 3) then
            ease((i*4)+1.5, 1, 'circInOut', [[
                -360, confusion
            ]])
        else 
            ease(i*4, 1, 'circOut', [[
                360, confusion
            ]])
            ease((i*4)+3, 1, 'circIn', [[
                0, confusion
            ]])
        end

        if i % 2 == 1 then 

        else 

        end

    end

    ease(128, 1, 'cubeInOut', [[
        0, z0,
        0, z1,
        0, z2,
        0, z3,
        -600, z4,
        -600, z5,
        -600, z6,
        -600, z7,
        0, reverseP1,
        0, reverseP2,
        0, InvertIncomingAngle,
        90, incomingAngle:x,
        0, IncomingAngleSmooth,
        0, beatYP1,
        0, beatYP2,
        -200, z,
        1, boost,
        -100, x0,
        -50, x1,
        50, x2,
        100, x3,
        -100, x4,
        -50, x5,
        50, x6,
        100, x7,
        360, confusion,
        1.2, tipsy,
        2, tipsy:speed,
        1.2, drunkP1,
        -1.2, drunkP2,
        1.5, drunkP1:speed,
        1.5, drunkP2:speed,
    ]])

    ease(158, 1, 'cubeInOut', [[
        -600, z0,
        -600, z1,
        -600, z2,
        -600, z3,
        0, z4,
        0, z5,
        0, z6,
        0, z7,
        -360, confusion
    ]])

    ease(191, 1, 'cubeInOut', [[
        0, z0,
        0, z1,
        0, z2,
        0, z3,
        -600, z4,
        -600, z5,
        -600, z6,
        -600, z7,
        360, confusion,
        0.5, tipsy,
        1, tipsy:speed,
        0.6, drunkP1,
        -0.6, drunkP2,
        0.6, drunkP1:speed,
        0.6, drunkP2:speed,
    ]])

    ease(218, 1, 'cubeInOut', [[
        -600, z0,
        -600, z1,
        -600, z2,
        -600, z3,
        0, z4,
        0, z5,
        0, z6,
        0, z7,
        -360, confusion
    ]])


    for i = 0,7 do
        local beat = 196+(7*i)
        ease(beat, 0.5, 'backInOut', [[
            1.5, invert,
        ]])
        ease(beat+(1.5), 0.5, 'backInOut', [[
            0, invert,
            2, flip,
        ]])
        if i ~= 7 then 
            ease(beat+(3), 0.5, 'backInOut', [[
                0, flip,
            ]])
        end

    end

    set(248.5,[[
        1, alpha
    ]])

    set(250, [[
        0, z0,
        0, z1,
        0, z2,
        0, z3,
        0, z4,
        0, z5,
        0, z6,
        0, z7,
        0, tipsy,
        0, drunkP1,
        0, drunkP2,
        0, flip,
        0, boost
    ]])
    
    --[[
        0, x0,
        0, x1,
        0, x2,
        0, x3,
        0, x4,
        0, x5,
        0, x6,
        0, x7,
    ]]
    ease(254, 2, 'cubeInOut', [[
        0, alpha,
        360, confusion
    ]])

    if downscroll then 

        ease(256, 1, 'cubeInOut', [[
            0.7, speed,
            0, PF1Alpha,
            0, PF2Alpha,
            -260, y,
            2.5, beatYP1,
            2.5, beatYP2,
        ]])
    else 
        
    ease(256, 1, 'cubeInOut', [[
        0.7, speed,
        0, PF1Alpha,
        0, PF2Alpha,
        260, y,
        2.5, beatYP1,
        2.5, beatYP2,
    ]])
    end



    for i = 0,7 do
        local beat = 256+(8*i)
        ease(beat+2, 2, 'backInOut', [[
            225, incomingAngle:y,
            -360, confusion,
        ]])
        set(beat+2, [[
            0, PF1Alpha,
            0, PF2Alpha,
        ]])
        ease(beat+6, 2, 'backInOut', [[
            0, incomingAngle:y,
            360, confusion,
        ]])
    end

    
    ease(334, 14, 'linear', [[
        -720, incomingAngle:y,
        -720, confusion,
    ]])


    ease(352, 1, 'cubeInOut', [[
        0.7, speed,
        1, PF1Alpha,
        1, PF2Alpha,
        0, z,
        90, incomingAngle:y,
        1, MoveYWaveShit,
        0, beatYP1,
        0, beatYP2,
        1, opponentAlpha,
        1.6, speed,
        1.5, beat,
    ]])

    ease(416, 4, 'cubeInOut', [[
        0, MoveYWaveShit,
        0, y,
        0.7, speed,
        0, incomingAngle:y,
        0.5, tipsy,
        0.6, drunkP1,
        -0.6, drunkP2,
        1, boost,
        -300, z,
        1, IncomingAngleSmooth,
        0, beat,
    ]])


    for i = 0,7 do
        local beat = 420+(7*i)
        ease(beat, 0.5, 'backInOut', [[
            1.5, invert,
        ]])
        ease(beat+(1.5), 0.5, 'backInOut', [[
            0, invert,
            2, flip,
        ]])
        if i ~= 7 then 
            ease(beat+(3), 0.5, 'backInOut', [[
                0, flip,
            ]])
        end

    end

    set(472.5,[[
        1, alpha
    ]])

    ease(478, 2, 'cubeInOut', [[
        0, alpha,
        360, confusion,
        0, flip,
        2, beat,
    ]])

    ease(567, 1, 'cubeInOut', [[
        0, beat,
    ]])


    for i = 0,7 do
        local beat = 480+(8*i)
        ease(beat+2, 2, 'backInOut', [[
            225, incomingAngle:y,
            -360, confusion,
        ]])
        set(beat+2, [[
            0, PF1Alpha,
            0, PF2Alpha,
        ]])
        ease(beat+6, 2, 'backInOut', [[
            0, incomingAngle:y,
            360, confusion,
        ]])
    end

    ease(560, 16, 'linear', [[
        0, tipsy,
        0, drunkP1,
        0, drunkP2,
        0, x0,
        0, x1,
        0, x2,
        0, x3,
        0, x4,
        0, x5,
        0, x6,
        0, x7,
    ]])

    ease(568, 8, 'cubeInOut', [[
        0, z,
    ]])


    ease(576, 4, 'linear', [[
        360, incomingAngle:y,
        7, IncomingAngleCurve
    ]])
    ease(585, 3, 'expoOut', [[
        1, alpha
    ]])




    for i = 1,#beatsScaleX do 
        set(beatsScaleX[i]-0.001, [[
            1.5, scaleX
        ]])
        ease(beatsScaleX[i], 1, 'expoOut', [[
            1, scaleX
        ]])
    end
    for i = 1,#beatsScaleY do 
        set(beatsScaleY[i]-0.001, [[
            1.5, scaleY
        ]])
        ease(beatsScaleY[i], 1, 'expoOut', [[
            1, scaleY
        ]])
    end
    for i = 8, 31 do 
        setupBeatShit(i)
    end
    for i = 32, 47 do 
        local beat = (i*4)
        set(beat-0.001+2, [[
            1.5, scaleX,
            2, drunk
        ]])
        ease(beat+2, 0.5, 'cubeOut', [[
            1, scaleX,
            0, drunk
        ]])
    end
    for i = 48, 61 do 
        setupBeatShit(i)
    end
    for i = 64, 79 do 
        setupBeatShit(i)
    end
    for i = 88, 117 do 
        setupBeatShit(i)
    end
    for i = 120, 135 do 
        setupBeatShit(i)
    end
end

function setupBeatShit(i)
    local beat = (i*4)
    set(beat-0.001, [[
        1.5, scaleY
    ]])
    ease(beat, 0.5, 'cubeOut', [[
        1, scaleY
    ]])
    set(beat-0.001+0.5, [[
        1.5, scaleY
    ]])
    ease(beat+0.5, 0.5, 'cubeOut', [[
        1, scaleY
    ]])
    set(beat-0.001+1, [[
        1.5, scaleX,
        2, drunk
    ]])
    ease(beat+1, 0.5, 'cubeOut', [[
        1, scaleX,
        0, drunk
    ]])

    set(beat-0.001+2, [[
        1.5, scaleY
    ]])
    ease(beat+2, 0.5, 'cubeOut', [[
        1, scaleY
    ]])
    set(beat-0.001+0.5+2, [[
        1.5, scaleY
    ]])
    ease(beat+0.5+2, 0.5, 'cubeOut', [[
        1, scaleY
    ]])
    set(beat-0.001+1+2, [[
        1.5, scaleX,
        2, drunk
    ]])
    ease(beat+1+2, 0.5, 'cubeOut', [[
        1, scaleX,
        0, drunk
    ]])

    if i == 27 or i == 27+4 then 
        set(beat-0.001+1+2-0.5, [[
            1.5, scaleX,
            -2, drunk
        ]])
        ease(beat+1+2-0.5, 0.5, 'cubeOut', [[
            1, scaleX,
            0, drunk
        ]])
        set(beat-0.001+1+2+0.5, [[
            1.5, scaleX,
            -2, drunk
        ]])
        ease(beat+1+2+0.5, 0.5, 'cubeOut', [[
            1, scaleX,
            0, drunk
        ]])
    end

    
end


function onStepHit()

    local section = math.floor(curStep/16)

    local beatShit1 = (section >= 8 and section < 32) or (section >= 64 and section < 80) or (section >= 64 and section < 80) or (section >= 88 and section < 104) or (section >= 120 and section < 136)

    if beatShit1 then 
        if curStep % 8 == 0 then 
            triggerEvent('Add Camera Zoom', '0.03', '0.03')
        elseif curStep % 8 == 4 then 
            triggerEvent('Add Camera Zoom', '0.06', '0.06')
        end
    end
end