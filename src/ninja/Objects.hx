//
// Hanoi Hanger - A weekend HTML5 hack
// https://github.com/aduros/hanoi/blob/master/LICENSE.txt

package ninja;

import flambe.Entity;
import flambe.System;
import flambe.display.AnimatedSprite;
import flambe.display.Transform;
import flambe.display.TextSprite;

class Objects
{
    public static function newPlayer () :Entity
    {
        var rope = new Rope();
        var player = new Entity()
            .add(new AnimatedSprite(ClientCtx.pack.loadTexture("player.png"), 3, 1))
            .add(new Player(rope));
        player.get(AnimatedSprite).anchorX._ = 24;
        player.get(AnimatedSprite).anchorY._ = 48;
        // player.get(AnimatedSprite).frame = 2;

        player.addChild(new Entity()
            .add(rope));

        player.get(Transform).x._ = 100;

        return player;
    }

    public static function newPagoda (pagoda :Pagoda) :Entity
    {
        var ent = new Entity()
            .add(pagoda);
        ent.get(Transform).x._ = pagoda.startsAt + pagoda.maxWidth/2;
        ent.get(Transform).y._ = System.stageHeight;
        return ent;
    }

    public static function newTimer () :Entity
    {
        return new Entity()
            .add(new TextSprite(ClientCtx.fontNinja))
            .add(new Timer());
    }
}
