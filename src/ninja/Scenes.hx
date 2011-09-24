//
// Hanoi Hanger - A weekend HTML5 hack
// https://github.com/aduros/hanoi/blob/master/LICENSE.txt

package ninja;

import flambe.Entity;
import flambe.System;
import flambe.display.FillSprite;

class Scenes
{
    public static function newPlayingScene ()
    {
        var scene = new Entity()
            .add(new FillSprite(0x202020, System.stageWidth, System.stageHeight));

        var player = Objects.newPlayer();
        scene.addChild(player);

        return scene;
    }
}
