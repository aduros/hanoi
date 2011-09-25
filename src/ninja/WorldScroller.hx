//
// Hanoi Hanger - A weekend HTML5 hack
// https://github.com/aduros/hanoi/blob/master/LICENSE.txt

package ninja;

import flambe.Component;
import flambe.display.Sprite;
import flambe.display.Transform;
import flambe.Entity;
import flambe.System;

class WorldScroller extends Component
{
    public var visiblePagodas (default, null) :Array<Entity>;

    public function new (world :Entity)
    {
        visiblePagodas = [];
        _world = world;
        _minPagodaId = 0;
        _maxPagodaId = 0;
    }

    override public function onUpdate (dt :Int)
    {
        var x = owner.get(Transform).x._;
        var minDistance = x - 50;
        var maxDistance = minDistance + System.stageWidth;

        owner.parent.get(Transform).x._ = -minDistance;

        var pagoda = ClientCtx.model.getPagoda(_maxPagodaId);
        while (pagoda.startsAt < maxDistance) {
            var ent = Objects.newPagoda(pagoda);
            visiblePagodas.push(ent);
            _world.addChild(ent);
            _maxPagodaId += 1;

            pagoda = ClientCtx.model.getPagoda(_maxPagodaId);
        }

        var pagoda = ClientCtx.model.getPagoda(_minPagodaId);
        while (pagoda.startsAt + pagoda.maxWidth + pagoda.gap < minDistance) {
            visiblePagodas.shift().dispose();
            _minPagodaId += 1;
            pagoda = ClientCtx.model.getPagoda(_minPagodaId);
        }
    }

    private var _world :Entity;

    private var _minPagodaId :Int;
    private var _maxPagodaId :Int;
}
