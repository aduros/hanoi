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
    public var hook :Point;
    public var length :PFloat;

    public var state (default, null) :RopeState;

    public function new ()
    {
        super();
        length = new PFloat(0);
        hook = new Point();
        state = Unused;

        _vel = new Point();

        _ropeTexture = ClientCtx.pack.loadTexture("rope.png");
        // _hookTexture = ClientCtx.pack.loadTexture("hook");
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
        _vel.x = event.viewX;
        _vel.y = event.viewY;
        _vel.normalize();

        var transform = owner.get(Transform);
        transform.rotation._ = 0;

        var delta = getViewMatrix().inverseTransformPoint(event.viewX, event.viewY);
        trace(delta);

        var angle = Math.atan(delta.y/delta.x);
        if (delta.x < 0) {
            angle += FMath.PI;
        }
        transform.rotation._ = FMath.toDegrees(angle);
        trace(owner.get(Transform).rotation._);

        trace("increasing");
        length.setBehavior(new IncreasingBehavior(0, 0.5));
        state = Extending;
    }

    public function onMouseUp (event :MouseEvent)
    {
        length.animateTo(0, 150);
        state = Unused;
    }

    override public function onUpdate (dt :Int)
    {
        super.onUpdate(dt);
        length.update(dt);

        // if (state == Extending) {
        //     length._ += dt * 0.5;
        // } else {
        //     length.update(dt);
        // }
    }

    override public function draw (ctx :DrawingContext)
    {
        ctx.drawPattern(_ropeTexture, 0, 0, length._, _ropeTexture.height);
    }

    public function grapple ()
    {
        state = Grappling;
    }

    private var _vel :Point;
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
