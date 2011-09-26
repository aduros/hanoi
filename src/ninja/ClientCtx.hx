//
// Hanoi Hanger - A weekend HTML5 hack
// https://github.com/aduros/hanoi/blob/master/LICENSE.txt

package ninja;

import flambe.asset.AssetPack;
import flambe.display.Font;
import flambe.Entity;

class ClientCtx
{
    public static var pack :AssetPack;
    public static var fontTiny :Font;

    public static var model :GameModel;
    public static var player :Entity; // HACK
}
