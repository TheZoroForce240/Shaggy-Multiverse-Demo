package modcharting;

import openfl.geom.Matrix3D;
import flixel.math.FlxMath;
import flixel.math.FlxAngle;
import openfl.geom.Vector3D;
import flixel.FlxG;

#if LEATHER
import states.PlayState;
import game.Note;
#else 
import PlayState;
import Note;
#end

class ModchartUtil
{
    public static function getDownscroll(instance:PlayState)
    {
        //need to test each engine
        //not expecting all to work
        #if PSYCH 
        return ClientPrefs.downScroll;
        #elseif LEATHER
        return utilities.Options.getData("downscroll");
        #elseif ANDROMEDA //dunno why youd use this on andromeda but whatever, already got its own cool modchart system
        return instance.currentOptions.downScroll;
        #elseif KADE 
        return PlayStateChangeables.useDownscroll;
        #elseif FOREVER_LEGACY //forever might not work just yet because of the multiple strumgroups
        return Init.trueSettings.get('Downscroll');
        #elseif FPSPLUS 
        return Config.downscroll;
        #elseif MIC_D_UP //basically no one uses this anymore
        return MainVariables._variables.scroll == "down"
        #else 
        return false;
        #end
    }
    public static function getScrollSpeed(instance:PlayState)
    {
        #if (PSYCH || ANDROMEDA) 
        return instance.songSpeed;
        #elseif LEATHER
        @:privateAccess
        return instance.speed;
        #elseif KADE 
        return PlayStateChangeables.scrollSpeed == 1 ? PlayState.SONG.speed : PlayStateChangeables.scrollSpeed;
        #else 
        return PlayState.SONG.speed; //most engines just use this
        #end
    }


    public static function getIsPixelStage(instance:PlayState)
    {
        #if LEATHER
        return PlayState.SONG.ui_Skin == 'pixel';
        #else 
        return PlayState.isPixelStage;
        #end
    }

    public static function getNoteOffsetX(daNote:Note)
    {
        #if PSYCH
        return daNote.offsetX;
        #elseif LEATHER 
        //fuck
        var offset:Float = 0;
        if (daNote.mustPress)
        {
            var instance = PlayState.instance;
            var arrayVal = Std.string([daNote.noteData, daNote.arrow_Type, daNote.isSustainNote]);
            var coolStrum = PlayState.playerStrums.members[Math.floor(Math.abs(daNote.noteData))];
            if (!instance.prevPlayerXVals.exists(arrayVal))
            {
                var tempShit:Float = 0.0;

                
                var targetX = coolStrum.x;

                while (Std.int(targetX + (daNote.width / 2)) != Std.int(coolStrum.x + (coolStrum.width / 2)))
                {
                    targetX += (targetX + daNote.width > coolStrum.x + coolStrum.width ? -0.1 : 0.1);
                    tempShit += (targetX + daNote.width > coolStrum.x + coolStrum.width ? -0.1 : 0.1);
                }

                instance.prevPlayerXVals.set(arrayVal, tempShit);
            }
            offset = instance.prevPlayerXVals.get(arrayVal);
        }
        else 
        {
            var instance = PlayState.instance;
            var arrayVal = Std.string([daNote.noteData, daNote.arrow_Type, daNote.isSustainNote]);
            var coolStrum = PlayState.enemyStrums.members[Math.floor(Math.abs(daNote.noteData))];
            if (!instance.prevEnemyXVals.exists(arrayVal))
            {
                var tempShit:Float = 0.0;

                
                var targetX = coolStrum.x;

                while (Std.int(targetX + (daNote.width / 2)) != Std.int(coolStrum.x + (coolStrum.width / 2)))
                {
                    targetX += (targetX + daNote.width > coolStrum.x + coolStrum.width ? -0.1 : 0.1);
                    tempShit += (targetX + daNote.width > coolStrum.x + coolStrum.width ? -0.1 : 0.1);
                }

                instance.prevEnemyXVals.set(arrayVal, tempShit);
            }
            offset = instance.prevEnemyXVals.get(arrayVal);
        }
        return offset;
        #else 
        return 37;
        #end
    }
    

    static var currentFakeCrochet:Float = -1;
    static var lastBpm:Float = -1;

    public static function getFakeCrochet()
    {
        if (PlayState.SONG.bpm != lastBpm)
        {
            currentFakeCrochet = (60 / PlayState.SONG.bpm) * 1000; //only need to calculate once
            lastBpm = PlayState.SONG.bpm;
        }
        return currentFakeCrochet;
            
    }

    public static var zNear:Float = 0;
    public static var zFar:Float = 100;
    public static var defaultFOV:Float = 90;

    /**
        Converts a Vector3D to its in world coordinates using perspective math
    **/
    public static function calculatePerspective(pos:Vector3D, FOV:Float, offsetX:Float = 0, offsetY:Float = 0)
    {

        /* math from opengl lol
            found from this website https://ogldev.org/www/tutorial12/tutorial12.html
        */

        //TODO: maybe try using actual matrix???



        //shit dont work
        //pos = Camera3D.multiplyByViewMatrix(pos); //view matrix

        
        
        
        var newz = pos.z - 1;
        var zRange = zNear - zFar;
        var tanHalfFOV = FlxMath.fastSin(FOV*0.5)/FlxMath.fastCos(FOV*0.5); //faster tan
        if (pos.z > 1) //if above 1000 z basically
            newz = 0; //should stop weird mirroring with high z values

        //var m00 = 1/(tanHalfFOV);
        //var m11 = 1/tanHalfFOV;
        //var m22 = (-zNear - zFar) / zRange; //isnt this just 1 lol
        //var m23 = 2 * zFar * zNear / zRange;
        //var m32 = 1;

        var xOffsetToCenter = pos.x - (FlxG.width*0.5); //so the perspective focuses on the center of the screen
        var yOffsetToCenter = pos.y - (FlxG.height*0.5);

        var zPerspectiveOffset = (newz+(2 * zFar * zNear / zRange));


        //xOffsetToCenter += (offsetX / (1/-zPerspectiveOffset));
        //yOffsetToCenter += (offsetY / (1/-zPerspectiveOffset));
        xOffsetToCenter += (offsetX * -zPerspectiveOffset);
        yOffsetToCenter += (offsetY * -zPerspectiveOffset);

        var xPerspective = xOffsetToCenter*(1/tanHalfFOV);
        var yPerspective = yOffsetToCenter*tanHalfFOV;
        xPerspective /= -zPerspectiveOffset;
        yPerspective /= -zPerspectiveOffset;

        pos.x = xPerspective+(FlxG.width*0.5); //offset it back to normal
        pos.y = yPerspective+(FlxG.height*0.5);
        pos.z = zPerspectiveOffset;

        

        //pos.z -= 1;
        //pos = perspectiveMatrix.transformVector(pos);

        return pos;
    }
    /**
        Returns in-world 3D coordinates using polar angle, azimuthal angle and a radius.
        (Spherical to Cartesian)

        @param	theta Angle used along the polar axis.
        @param	phi Angle used along the azimuthal axis.
        @param	radius Distance to center.
    **/
    public static function getCartesianCoords3D(theta:Float, phi:Float, radius:Float):Vector3D
    {
        var pos:Vector3D = new Vector3D();
        var rad = FlxAngle.TO_RAD;
        pos.x = FlxMath.fastCos(theta*rad)*FlxMath.fastSin(phi*rad);
        pos.y = FlxMath.fastCos(phi*rad);
        pos.z = FlxMath.fastSin(theta*rad)*FlxMath.fastSin(phi*rad);
        pos.x *= radius;
        pos.y *= radius;
        pos.z *= radius;

        return pos;
    }
}


class Camera3D
{
    public static var eye:Vector3D = new Vector3D(0,0,-1000,0);
    public static var at:Vector3D = new Vector3D(0,0,0,0);
    public static var up:Vector3D = new Vector3D(0,1,0,0);

    public static var yaw(default, set):Float = 90;
    public static var pitch(default, set):Float = 0;

    public static var view:Matrix3D = new Matrix3D();

    private static function set_yaw(value:Float):Float {
        updateAt();
		return value;
	}
    private static function set_pitch(value:Float):Float {
        if(pitch > 89)
            pitch = 89;
        if(pitch < -89)
            pitch = -89;
        updateAt();
		return value;
	}
    public static function updateAt()
    {
        //https://learnopengl.com/Getting-started/Camera
        at.x = Math.cos(yaw * FlxAngle.TO_RAD) * Math.cos(pitch * FlxAngle.TO_RAD);
        at.y = Math.sin(pitch * FlxAngle.TO_RAD);
        at.z = Math.sin(yaw * FlxAngle.TO_RAD) * Math.cos(pitch * FlxAngle.TO_RAD);

        at.add(eye);
        lookAt();
    }
    public static function lookAt()
    {
        view.identity();


        //zaxis = normal(At - Eye)
        //xaxis = normal(cross(Up, zaxis))
        //yaxis = cross(zaxis, xaxis)

        //xaxis.x           yaxis.x           zaxis.x          0
        //xaxis.y           yaxis.y           zaxis.y          0
        //xaxis.z           yaxis.z           zaxis.z          0
        //-dot(xaxis, eye)  -dot(yaxis, eye)  -dot(zaxis, eye)  1

        var z:Vector3D = at.subtract(eye);
        z.normalize();
        var x:Vector3D = up.crossProduct(z);
        x.normalize();
        var y:Vector3D = z.crossProduct(x);


        x.w = -x.dotProduct(eye);
        y.w = -y.dotProduct(eye);
        z.w = -z.dotProduct(eye);

        view.copyColumnFrom(0, x);
        view.copyColumnFrom(1, y);
        view.copyColumnFrom(2, z);
        view.copyColumnFrom(3, new Vector3D(0,0,0,1));
    }


    public static function multiplyByViewMatrix(pos:Vector3D):Vector3D
    {
        var mat:Matrix3D = new Matrix3D();
        mat.appendTranslation(pos.x,pos.y,pos.z);
        mat.append(view);

        pos.x = mat.rawData[12];
        pos.y = mat.rawData[13];
        pos.z = mat.rawData[14];

        return pos;
    }

}