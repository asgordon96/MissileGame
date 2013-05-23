// ButtonTest.as
// testing if the button works

package {
    import flash.display.Sprite;
    import flash.text.TextField;
    import Button;
    
    public class ButtonTest extends Sprite {
        public var b:Button;
        public var debug:TextField = new TextField();
        
        public function ButtonTest() {
            b = new Button(200, 200, "Test Button", test);
            b.set_font_size(48);
            b.font_size_rollover = 54;
            b.set_color(0xFF0000);
            b.rollover_color = 0x0000FF;
            
            addChild(b);
            addChild(debug);
            debug.text = "Here";
        }
        
        public function test():void {
            debug.text = "It Worked!";
        }
    }
}
            