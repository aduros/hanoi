//
// Hanoi Hanger - A weekend HTML5 hack
// https://github.com/aduros/hanoi/blob/master/LICENSE.txt

package ninja;

import flambe.Component;
import flambe.display.PatternSprite;
import flambe.display.Transform;
import flambe.Entity;
import flambe.System;

class BackgroundScroller extends Component
{
    public function new (background :Entity)
    {
        _background = background;
    }

    override public function onUpdate (dt :Int)
    {
        var texture = _background.get(PatternSprite).texture;

        var x = -((0.1*owner.get(Transform).x._) % texture.width);

        _background.get(Transform).x._ = x;
        // _background.get(PatternSprite).width._ = w - x;
    }

    private var _background :Entity;
}
