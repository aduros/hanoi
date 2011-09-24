//
// Hanoi Hanger - A weekend HTML5 hack
// https://github.com/aduros/hanoi/blob/master/LICENSE.txt

package ninja;

import flambe.Component;
import flambe.display.Transform;
import flambe.math.Point;
import flambe.System;

class Player extends Component
{
    public function new (rope :Rope)
    {
        _vel = new Point();
        _rope = rope;
    }

    override public function onUpdate (dt :Int)
    {
        _vel.y += dt * GRAVITY;
        if (_vel.y < TERMINAL_VELOCITY) {
            _vel.y = TERMINAL_VELOCITY;
        }

        var transform = owner.get(Transform);
        var ground = System.stageHeight - 100;
        if (transform.y._ >= ground) {
            transform.y._ = ground;
        } else {
            transform.y._ += _vel.y;
        }
    }

    private static inline var TERMINAL_VELOCITY = 0.5;
    private static inline var GRAVITY = 0.02;

    private var _vel :Point;
    private var _rope :Rope;
}
