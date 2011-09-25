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

class Pagoda extends Sprite
{
    public function new ()
    {
        super();
        _layers = [];

        var w = 200.0;
        for (ii in 0...10) {
            w = random(w-50, w);
            if (w < 50) {
                break;
            }
            _layers.push(w);
        }
        trace(_layers);

        _textureLayer = ClientCtx.pack.loadTexture("layer.png");
        _textureLeft = ClientCtx.pack.loadTexture("left.png");
        _textureRight = ClientCtx.pack.loadTexture("right.png");
    }

    override public function draw (ctx :DrawingContext)
    {
        var y = 0;
        for (width in _layers) {
            y -= LAYER_HEIGHT;
            var x = -0.5*width;
            ctx.drawPattern(_textureLayer, x, y, width, LAYER_HEIGHT);
            ctx.drawImage(_textureLeft, x - 32, y - 18);
            ctx.drawImage(_textureRight, x + width, y - 18);
        }
    }

    public function collides (oldX :Float, oldY :Float, velX :Float, velY :Float) :Bool
    {
        oldY = System.stageHeight - oldY;
        velY = -velY;
        var layerIdx = FMath.toInt(oldY / LAYER_HEIGHT);

        trace(velY);
        if (layerIdx >= 0 && layerIdx < _layers.length
                && layerIdx != FMath.toInt((oldY + velY) / LAYER_HEIGHT)) {
            var w = _layers[layerIdx];
            var localX = owner.get(Transform).x._;
            trace("Maybe layer " + layerIdx);
            return oldX + 0.5*velX > localX - 0.5*w && oldX + 0.5*velX < localX + 0.5*w;
        }
        return false;
    }

    private static function random (from :Float, to :Float) :Float
    {
        return Math.random()*(to - from) + from;
    }

    private static inline var LAYER_HEIGHT = 32;

    private var _layers :Array<Float>;
    private var _textureLayer :Texture;
    private var _textureLeft :Texture;
    private var _textureRight :Texture;
}
