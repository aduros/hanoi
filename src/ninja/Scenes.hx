//
// Hanoi Hanger - A weekend HTML5 hack
// https://github.com/aduros/hanoi/blob/master/LICENSE.txt

package ninja;

import haxe.Unserializer;
import haxe.Serializer;

import flambe.animation.Easing;
import flambe.display.FillSprite;
import flambe.display.PatternSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.display.Transform;
import flambe.Entity;
import flambe.math.FMath;
import flambe.scene.Director;
import flambe.System;

class Scenes
{
    public static function enterGameOverScene (score :Int, cause :String)
    {
        System.root.get(Director).pushScene(newGameOverScene(score, cause));
    }

    public static function enterPlayingScene ()
    {
        System.root.get(Director).unwindToScene(newPlayingScene());
    }

    private static function newPlayingScene ()
    {
        var seed = 7 + FMath.toInt(Date.now().getTime() / (1000*60*60*24));
        trace("Playing seed " + seed);
        ClientCtx.model = new GameModel(seed);

        var scene = new Entity();

        var backgroundLayer = new Entity()
            .add(new PatternSprite(ClientCtx.pack.loadTexture("background.jpg")));
        var pattern = backgroundLayer.get(PatternSprite);
        pattern.width._ = System.stageWidth + pattern.texture.width;
        pattern.height._ = System.stageHeight;
        scene.addChild(backgroundLayer);

        var world = new Entity().add(new Sprite());
        scene.addChild(world);

        var pagodaLayer = new Entity().add(new Sprite());
        world.addChild(pagodaLayer);

        var player = Objects.newPlayer()
            .add(new WorldScroller(pagodaLayer))
            .add(new BackgroundScroller(backgroundLayer));
        world.addChild(player);
        ClientCtx.player = player;

        var timer = Objects.newTimer();
        scene.addChild(timer);

        return scene;
    }

    public static function newGameOverScene (score :Int, cause :String)
    {
        var w = Math.min(System.stageWidth, 400);
        var h = Math.min(System.stageHeight, 300);

        var popup = new Entity()
            .add(new FillSprite(0xffffff, w, h));
        var t = popup.get(Transform);
        t.x._ = System.stageWidth;
        t.x.animateTo(System.stageWidth/2 - w/2, 400, Easing.quadOut);
        t.y._ = System.stageHeight/2 - h/2;
        popup.get(FillSprite).alpha._ = 0.8;

        var playAgain = new Entity()
            .add(new TextSprite(ClientCtx.fontNinja, "Play again?"));
        var t = playAgain.get(Transform);
        var text = playAgain.get(TextSprite);
        t.x._ = w - text.getNaturalWidth() - 10;
        t.y._ = h - text.font.size - 10;
        text.mouseDown.connect(function (_) enterPlayingScene());
        popup.addChild(playAgain);

        var save :Dynamic = System.storage.get("save");
        save = (save != null) ? Unserializer.run(save) : {};

        var prevBest = FMath.toInt(save.bestScore);
        var seed = FMath.toInt(save.seed);
        var newHighScore = (seed != ClientCtx.model.seed) || (score > prevBest);

        if (newHighScore) {
            save.seed = ClientCtx.model.seed;
            save.bestScore = score;
            System.storage.set("save", Serializer.run(save));
        }

        var lines = [
            "You reached " + score + " meters",
            "Before " + cause,
            newHighScore ? "That beats today's high score!" : "Today's high score is " + prevBest,
            "",
            "Return tomorrow for a new level",
        ];
        var y = 10;
        for (line in lines) {
            var ent = new Entity().add(new TextSprite(ClientCtx.fontNinja, line));
            popup.addChild(ent);
            var t = ent.get(Transform);
            t.x._ = 10;
            t.y._ = y;
            y += ClientCtx.fontNinja.size;
        }

        // var mainMenu = new Entity()
        //     .add(new TextSprite(ClientCtx.fontBig, "Main menu"));
        // var t = mainMenu.get(Transform);
        // var text = mainMenu.get(TextSprite);
        // t.x._ = PADDING;
        // t.y._ = h - ClientCtx.fontBig.size - PADDING;
        // text.mouseDown.connect(function (_) {
        //     System.root.get(Director).unwindToScene(newMainMenu());
        // });
        // popup.addChild(mainMenu);

        return popup;
    }
}
