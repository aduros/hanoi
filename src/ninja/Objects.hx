//
// Hanoi Hanger - A weekend HTML5 hack
// https://github.com/aduros/hanoi/blob/master/LICENSE.txt

package ninja;

import flambe.Entity;
import flambe.System;
import flambe.display.FillSprite;

class Objects
{
    public static function newPlayer ()
    {
        var rope = new Rope();
        var player = new Entity()
            .add(new FillSprite(0xff0000, 32, 40))
            .add(new Player(rope));

        player.addChild(new Entity()
            .add(rope));

        player.get(flambe.display.Transform).x._ = 100;

        return player;
    }
}
