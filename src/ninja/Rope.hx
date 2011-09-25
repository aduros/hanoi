//
// Hanoi Hanger - A weekend HTML5 hack
// https://github.com/aduros/hanoi/blob/master/LICENSE.txt

package ninja;

import flambe.animation.Property;
import flambe.display.DrawingContext;
import flambe.display.MouseEvent;
import flambe.display.Sprite;
import flambe.display.Texture;
import flambe.display.Transform;
import flambe.Disposer;
import flambe.Input;
import flambe.math.FMath;
import flambe.math.Point;

enum RopeState {
    Unused;
    Extending;
    Grappling;
}

class Rope extends Sprite
{
    public static inline var SPEED = 0.5;

    public var hookPos (default, null) :Point;
    public var hookVel (default, null) :Point;
    public var length (default, null) :PFloat;

    public var state (default, null) :RopeState;

    public function new ()
    {
        super();
        length = new PFloat(0);
        hookPos = new Point();
        state = Unused;

        hookVel = new Point();

        _ropeTexture = ClientCtx.pack.loadTexture("rope.png");
        // _hookTexture = ClientCtx.pack.loadTexture("hookPos");
    }

    override public function onAdded ()
    {
        super.onAdded();

        var d = new Disposer();
        d.connect1(Input.mouseDown, onMouseDown);
        d.connect1(Input.mouseUp, onMouseUp);
        owner.add(d);
    }

    public function onMouseDown (event :MouseEvent)
    {
        // HACK
        var transform = owner.get(Transform);
        transform.rotation._ = 0;
        owner.parent.get(Transform).rotation._ = 0;

        hookPos.x = 0;
        hookPos.y = -Player.HEIGHT/2;

        var local = getViewMatrix().inverseTransformPoint(event.viewX, event.viewY);
        trace(local);
        var angle = Math.atan(local.y/local.x);
        if (local.x < 0) {
            angle += FMath.PI;
        }
        transform.rotation._ = FMath.toDegrees(angle);

        hookVel.x = local.x;
        hookVel.y = local.y;
        hookVel.normalize();

        length.setBehavior(new IncreasingBehavior(0, SPEED));
        state = Extending;
    }

    public function onMouseUp (event :MouseEvent)
    {
        length.animateTo(0, 150);
        hookPos.x = hookPos.y = 0;
        state = Unused;
    }

    override public function onUpdate (dt :Int)
    {
        super.onUpdate(dt);
        length.update(dt);

        if (state == Extending) {
            var transform = owner.get(Transform);
            hookPos.x += SPEED*dt*hookVel.x;
            hookPos.y += SPEED*dt*hookVel.y;
        }
    }

    override public function draw (ctx :DrawingContext)
    {
        ctx.drawPattern(_ropeTexture, 0, -Player.HEIGHT/2, length._, _ropeTexture.height);
    }

    public function grapple ()
    {
        state = Grappling;
        length.setBehavior(null);

        // var t = owner.parent.get(Transform);
        // t.x._ -= hookPos.x;
        // t.y._ -= hookPos.y;
    }

    public function ungrapple ()
    {
        state = Unused;
        length._ = 0;
    }

    private var _ropeTexture :Texture;
    private var _hookTexture :Texture;
}

import flambe.animation.Behavior;

// TODO(bruno): Move into flambe?
class IncreasingBehavior
    implements Behavior<Float>
{
    public function new (start :Float, speed :Float)
    {
        _value = start;
        _speed = speed;
    }

    public function update (dt :Int) :Float
    {
        return _value += dt*_speed;
    }

    public function isComplete () :Bool
    {
        return false;
    }

    private var _value :Float;
    private var _speed :Float;
}
