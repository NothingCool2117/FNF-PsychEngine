package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;

class StickerTransition {
    
    public static var stickers:FlxGroup;
    public static var stickerCount:Int = 20;  // Number of stickers
    public static var transitionDuration:Float = 1.0;  // Time for transition
    public static var stickerSprites:Array<FlxSprite> = [];

    // Load sticker assets into an array
    public static function loadStickers():Void {
        // Assume sticker assets are in "assets/images/" and named "sticker1.png", "sticker2.png", etc.
        for (i in 0...12) {
            var sprite:FlxSprite = new FlxSprite().loadGraphic("assets/shared/images/stickers/sticker${i + 1}.png");
            stickerSprites.push(sprite);
        }
    }

    public static function popUpStickers(callback:Void -> Void = null):Void {
        if (stickers == null) {
            stickers = new FlxGroup();

            for (i in 0...stickerCount) {
                // Randomly select a sticker sprite from the array
                var randomIndex:Int = FlxG.random.int(0, stickerSprites.length - 1);
                var sticker:FlxSprite = new FlxSprite();
                sticker.loadGraphic(stickerSprites[randomIndex].graphic);

                // Set initial properties
                sticker.alpha = 0;
                sticker.x = FlxG.random.float(0, FlxG.width - sticker.width);
                sticker.y = FlxG.random.float(0, FlxG.height - sticker.height);
                sticker.scale.set(0, 0);  // Start small
                
                stickers.add(sticker);
                FlxG.state.add(sticker);
                
                FlxTween.tween(sticker, { alpha: 1, scaleX: 1, scaleY: 1 }, transitionDuration, { startDelay: i * 0.05 });
            }
        }
        
        FlxTween.delayedCall(transitionDuration + 0.5, function() {
            if (callback != null) callback();
        });
    }
    
    public static function popDownStickers(callback:Void -> Void = null):Void {
        for (sticker in stickers.members) {
            FlxTween.tween(sticker, { alpha: 0, scaleX: 0, scaleY: 0 }, transitionDuration, { onComplete: function(t:FlxTween) {
                FlxG.state.remove(sticker);
            }});
        }
        
        FlxTween.delayedCall(transitionDuration + 0.5, function() {
            stickers.clear();
            if (callback != null) callback();
        });
    }
}
