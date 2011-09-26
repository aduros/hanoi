//
// Hanoi Hanger - A weekend HTML5 hack
// https://github.com/aduros/hanoi/blob/master/LICENSE.txt

package ninja;

import flambe.Component;
import flambe.display.TextSprite;
import flambe.display.Transform;
import flambe.math.FMath;
import flambe.System;

class Timer extends Component
{
    public function new ()
    {
        _countdown = 1000*10;
    }

    override public function onUpdate (dt :Int)
    {
        var oldSeconds = FMath.toInt(_countdown/1000);
        _countdown -= dt;

        var seconds = FMath.toInt(_countdown/1000);
        if (seconds == oldSeconds) {
            return;
        }

        if (seconds <= 0) {
            Scenes.enterGameOverScene(
                FMath.toInt(ClientCtx.player.get(Transform).x._ / 20),
                "running out of time");
        }

        var minutes = FMath.toInt(seconds/60);
        seconds = seconds%60;

        var sprite = owner.get(TextSprite);
        sprite.text = minutes + (seconds > 9 ? ":" : ":0") + seconds;

        owner.get(Transform).x._ = System.stageWidth/2 - sprite.getNaturalWidth()/2;
    }

    private var _countdown :Int;
}
