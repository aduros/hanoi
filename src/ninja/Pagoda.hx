//
// Hanoi Hanger - A weekend HTML5 hack
// https://github.com/aduros/hanoi/blob/master/LICENSE.txt

package ninja;

import flambe.display.DrawingContext;
import flambe.display.Sprite;
import flambe.display.Texture;
import flambe.display.Transform;
import flambe.math.FMath;
import flambe.System;
import flambe.util.Random;

class Pagoda extends Sprite
{
    public var id :Int;
    public var startsAt :Float;

    public var maxWidth (default, null) :Float;
    public var gap (default, null) :Float;

    public function new (rand :Random)
    {
        super();
        _slabs = [];
        maxWidth = 0;

        // Generate the structure
        var w = 200.0;
        for (ii in 0...10) {
            w = between(rand, w-30, w);
            maxWidth = FMath.max(maxWidth, w);
            if (w < 50) {
                break;
            }
            _slabs.push(w);
        }
        this.gap = between(rand, 100, 200);

        _textureSlab = ClientCtx.pack.loadTexture("layer.png");
        _textureLeft = ClientCtx.pack.loadTexture("left.png");
        _textureRight = ClientCtx.pack.loadTexture("right.png");
    }

    override public function draw (ctx :DrawingContext)
    {
        var y = 0;
        for (width in _slabs) {
            y -= SLAB_HEIGHT;
            var x = -0.5*width;
            ctx.drawPattern(_textureSlab, x, y, width, SLAB_HEIGHT);
            ctx.drawImage(_textureLeft, x - 32, y - 18);
            ctx.drawImage(_textureRight, x + width, y - 18);
        }
    }

    public function collides (oldX :Float, oldY :Float, velX :Float, velY :Float) :Float
    {
        // Convert to an easier coordinate system
        oldY = System.stageHeight - oldY;
        velY = -velY;

        var slabIdx = FMath.toInt(oldY / SLAB_HEIGHT);

        // Dubious collision detection
        if (slabIdx >= 0 && slabIdx < _slabs.length
                && slabIdx != FMath.toInt((oldY + velY) / SLAB_HEIGHT)) {
            var w = _slabs[slabIdx];
            var localX = owner.get(Transform).x._;
            if (oldX + 0.5*velX > localX - 0.5*w && oldX + 0.5*velX < localX + 0.5*w) {
                return slabIdx * SLAB_HEIGHT;
            }
        }
        return -1;
    }

    private static function between (rand :Random, from :Float, to :Float) :Float
    {
        return rand.nextFloat()*(to - from) + from;
    }

    private static inline var SLAB_HEIGHT = 32;

    private var _slabs :Array<Float>;
    private var _textureSlab :Texture;
    private var _textureLeft :Texture;
    private var _textureRight :Texture;
}
