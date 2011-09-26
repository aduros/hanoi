//
// Hanoi Hanger - A weekend HTML5 hack
// https://github.com/aduros/hanoi/blob/master/LICENSE.txt

package ninja;

import flambe.util.Random;

class GameModel
{
    public function new (seed :Int)
    {
        _random = new Random(seed);
        _pagodas = [];
    }

    public function getPagoda (pagodaId :Int) :Pagoda
    {
        while (pagodaId >= _pagodas.length) {
            var pagoda = new Pagoda(_random);
            if (_pagodas.length > 0) {
                var lastPagoda = _pagodas[_pagodas.length-1];
                pagoda.startsAt = lastPagoda.startsAt + lastPagoda.maxWidth + lastPagoda.gap;
            } else {
                pagoda.startsAt = 0;
            }
            pagoda.id = _pagodas.length;
            _pagodas.push(pagoda);
        }
        return _pagodas[pagodaId];
    }

    private var _pagodas :Array<Pagoda>;
    private var _random :Random;
}
