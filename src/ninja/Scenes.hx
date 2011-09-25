//
// Hanoi Hanger - A weekend HTML5 hack
// https://github.com/aduros/hanoi/blob/master/LICENSE.txt

package ninja;

import flambe.Entity;
import flambe.System;
import flambe.display.FillSprite;
import flambe.display.Sprite;

class Scenes
{
    public static function newPlayingScene ()
    {
        ClientCtx.model = new GameModel(666);

        var scene = new Entity()
            .add(new FillSprite(0x202020, System.stageWidth, System.stageHeight));

        var world = new Entity().add(new Sprite());
        scene.addChild(world);

        var pagodaLayer = new Entity().add(new Sprite());
        world.addChild(pagodaLayer);

        var player = Objects.newPlayer().add(new WorldScroller(pagodaLayer));
        world.addChild(player);

        return scene;
    }
}
