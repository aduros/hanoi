//
// Hanoi Hanger - A weekend HTML5 hack
// https://github.com/aduros/hanoi/blob/master/LICENSE.txt

package ninja;

import flambe.Component;
import flambe.display.Transform;
import flambe.math.FMath;
import flambe.math.Point;
import flambe.System;

import ninja.Rope;

class Player extends Component
{
    public function new (rope :Rope)
    {
        _vel = new Point();
        _rope = rope;
    }

    override public function onUpdate (dt :Int)
    {
        _vel.y += dt*GRAVITY;
        if (_vel.y > TERMINAL_VELOCITY) {
            _vel.y = TERMINAL_VELOCITY;
        }

        var transform = owner.get(Transform);
        var startX = transform.x._;
        var startY = transform.y._;

        var ground = System.stageHeight - 100;
        if (_rope.state != Grappling) {
            if (transform.y._ >= ground) {
                _vel.x = 0;
                _vel.y = 0;
                transform.y._ = ground;
            } else {
                transform.x._ += _vel.x;
                transform.y._ += _vel.y;
            }
        } else {
            if (_rope.state == Grappling) {
                // Vector from player to anchored hook
                var v1 = _rope.hookPos;

                var v2 = v1.clone();
                v2.x -= _vel.x;
                v2.y -= _vel.y;
                v2.normalize();
                v2.multiply(_rope.length._);

                var v3 = new Point(v1.x - v2.x, v1.y - v2.y);
                _vel.x = v3.x;
                _vel.y = v3.y;
                // trace(v1);
                // trace(v2);

                transform.x._ += v3.x;
                transform.y._ += v3.y;

                _rope.hookPos.x = v2.x;
                _rope.hookPos.y = v2.y;

                // var angle = Math.acos(v2.dot(v1.x, v1.y) / (v1.magnitude()*v2.magnitude()));
                trace(v1.dot(v2.x, v2.y)); // (v1.magnitude()*v2.magnitude()));
                var angle = Math.acos(v1.dot(v2.x, v2.y) / (v1.magnitude()*v2.magnitude()));
                // trace(angle);
                if (!Math.isNaN(angle)) {
                    trace(angle);
                    transform.rotation._ += FMath.toDegrees(angle);
                }

                // _vel.x = 

                // trace(p);
                // p.x += transform.x._ + _vel.x;
                // p.y += transform.y._ + _vel.y;

                // var cross = (_rope.hookPos.x*_acc.y) - (_rope.hookPos.y*_acc.x);
                // trace(cross);

                // var p = new Point(_rope.hookPos.x, _rope.hookPos.y);
                // p.x += transform.x._;
                // p.y += transform.y._;
                // trace(p);

                // var deltaX = p.x - startX;
                // var deltaY = p.y - startY;
                // trace("Delta: " + deltaX + "," + deltaY);

                // _vel.x += 0.1*deltaX;
                // _vel.y += 0.1*deltaY;

                // // transform.x._ = p.x;
                // // transform.y._ = p.y;

                // _rope.hookPos.x += deltaX;
                // _rope.hookPos.y += deltaY;
            }
        }

        if (_rope.state == Extending) {
            for (pagoda in ClientCtx.pagodas) {
                if (pagoda.collides(transform.x._ + _rope.hookPos.x,
                        transform.y._ + _rope.hookPos.y,
                        _vel.x + Rope.SPEED*dt*_rope.hookVel.x,
                        _vel.y + Rope.SPEED*dt*_rope.hookVel.y)) {
                    _rope.grapple();
                    trace("THUNK");
                    break;
                }
            }
        }
    }

    private static inline var TERMINAL_VELOCITY = 5;
    private static inline var GRAVITY = 0.02;

    private var _vel :Point;
    private var _rope :Rope;
}
