//
// Hanoi Hanger - A weekend HTML5 hack
// https://github.com/aduros/hanoi/blob/master/LICENSE.txt

package ninja;

import flambe.Component;
import flambe.display.AnimatedSprite;
import flambe.display.MouseEvent;
import flambe.display.Transform;
import flambe.Disposer;
import flambe.math.FMath;
import flambe.math.Point;
import flambe.System;
import flambe.Input;

import ninja.Rope;

class Player extends Component
{
    public static inline var TERMINAL_VELOCITY = 5;
    public static inline var GRAVITY = 0.02;
    public static inline var TIME_STEP = 16;
    public static inline var HEIGHT = 40;
    public static inline var JUMP_STRENGTH = 2;

    public function new (rope :Rope)
    {
        _vel = new Point();
        _rope = rope;
        _accumulator = 0;
        _pagodaId = 0;
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

        var sprite = owner.get(AnimatedSprite);

        var pagoda = ClientCtx.model.getPagoda(_pagodaId);

        var ground = System.stageHeight;
        if (_rope.state != Grappling) {
            var y = transform.y._;
            if (y >= ground && _vel.y > 0) {
                _vel.x = 0;
                _vel.y = 0;
                transform.y._ = ground;
                transform.rotation._ = 90;
                sprite.frame = 2;
                Scenes.enterGameOverScene(FMath.toInt(owner.get(Transform).x._ / 20),
                    "falling to Earth");

            } else {
                var vx = _vel.x*dt*60/1000;
                var vy = _vel.y*dt*60/1000;
                var h = pagoda.collides(transform.x._, y, vx, vy);
                if (_vel.y > 0 && h >= 0) {
                    _vel.x *= 0.9; // Drag
                    _vel.y = 0;
                    transform.rotation._ = 0;
                    transform.y._ = ground - h;
                    sprite.frame = 2;
                } else {
                    transform.y._ += vy;
                }
                transform.x._ += vx;
            }
        } else {
            sprite.frame = 1;

            _accumulator += dt;
            while (_accumulator >= TIME_STEP) {

                _rope.length._ -= 1;
                if (_rope.length._ < 0) {
                    _rope.ungrapple();
                    break;
                }

                // Vector from player to anchored hook
                var v1 = _rope.hookPos.clone();

                var v2 = v1.clone();
                v2.x -= 1.01*_vel.x;
                v2.y -= 1.01*_vel.y;
                v2.normalize();
                v2.multiply(_rope.length._);

                var v3 = new Point(v1.x - v2.x, v1.y - v2.y);
                _vel.x = v3.x;
                _vel.y = v3.y;

                transform.x._ += v3.x;
                transform.y._ += v3.y;

                _rope.hookPos.x = v2.x;
                _rope.hookPos.y = v2.y;

                // var angle = Math.acos(v2.dot(v1.x, v1.y) / (v1.magnitude()*v2.magnitude()));
                // trace(v1.dot(v2.x, v2.y)); // (v1.magnitude()*v2.magnitude()));

                var angle = Math.acos(v1.dot(v2.x, v2.y) / (v1.magnitude()*v2.magnitude()));
                // var angle = Math.acos(v1.dot(v2.x, v2.y));
                if (!Math.isNaN(angle)) {
                    transform.rotation._ += ((_vel.x < 0) == (v2.y < 0) ? 1 : -1)
                        *Math.abs(FMath.toDegrees(angle));
                }

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
                _accumulator -= TIME_STEP;
            }
        }

        if (_rope.state == Extending) {
            sprite.frame = 0;
            for (entity in owner.get(WorldScroller).visiblePagodas) {
                var pagoda = entity.get(Pagoda);
                if (pagoda.collides(transform.x._ + _rope.hookPos.x,
                        transform.y._ + _rope.hookPos.y,
                        _vel.x + Rope.SPEED*dt*_rope.hookVel.x,
                        _vel.y + Rope.SPEED*dt*_rope.hookVel.y) >= 0) {
                    _rope.grapple();
                    trace("THUNK");
                    break;
                }
            }
        }

        if (transform.x._ > pagoda.startsAt + pagoda.maxWidth + pagoda.gap) {
            _pagodaId += 1;
        }
    }

    override public function onAdded ()
    {
        super.onAdded();

        var d = new Disposer();
        d.connect1(Input.mouseDown, onMouseDown);
        owner.add(d);
    }

    private function onMouseDown (event :MouseEvent)
    {
        var sprite = owner.get(AnimatedSprite);
        if (sprite.frame != 2) {
            return; // Only let them jump from "standing"
        }
        trace("BOING");

        var local = sprite.getViewMatrix().inverseTransformPoint(event.viewX, event.viewY);
        // var p = new Point(event.viewX - t.x._, event.viewY - t.y._);
        local.normalize();
        local.multiply(JUMP_STRENGTH);

        _vel.x += local.x;
        _vel.y += local.y;
    }

    private var _vel :Point;
    private var _rope :Rope;
    private var _accumulator :Int;
    private var _pagodaId :Int;
}
