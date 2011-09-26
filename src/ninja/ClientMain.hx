//
// Hanoi Hanger - A weekend HTML5 hack
// https://github.com/aduros/hanoi/blob/master/LICENSE.txt

package ninja;

import flambe.display.Font;
import flambe.Entity;
import flambe.scene.Director;
import flambe.System;

class ClientMain
{
    private static function main ()
    {
        System.init();
        System.lockOrientation(Landscape);

        System.root.add(new Director());

        var loader = System.loadAssetPack("bootstrap");
        loader.success.connect(function () {
            ClientCtx.pack = loader.pack;

            // Initialize some common assets
            ClientCtx.fontTiny = new Font(ClientCtx.pack, "ninjafont");

            System.root.addChild(new Entity().add(new flambe.util.FpsLog(ClientCtx.fontTiny)));

            // Main screen turn on
            Scenes.enterPlayingScene();
        });
        loader.error.connect(function (msg) {
            trace("Loading error: " + msg);
        });
        loader.progress.connect(function () {
            trace("Loading progress... " + loader.bytesLoaded + " of " + loader.bytesTotal);
        });
        loader.start();
    }
}
