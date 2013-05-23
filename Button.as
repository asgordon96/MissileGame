// Button.as
// a simple button in ActionScript

package {
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
    import flash.events.*;
    
    public class Button extends Sprite {
        public var display_text:TextField = new TextField();
        public var format:TextFormat;
        public var action:Function;
        
        public var text_color:uint = 0x000000;
        public var rollover_color:uint = 0x000000;
        
        public var font_size:int = 24;
        public var font_size_rollover:int = 24;
        
        public function Button(x:int, y:int, disp:String, callback:Function, f:TextFormat) {
            
			format = f;
            display_text.defaultTextFormat = format;
            display_text.embedFonts = true;
			
            display_text.text = disp;
            display_text.x = x
            display_text.y = y
            display_text.selectable = false;     
            addChild(display_text);
            
            display_text.autoSize = TextFieldAutoSize.CENTER;
            
            action = callback;
            
            display_text.addEventListener(MouseEvent.MOUSE_DOWN , on_click);
            display_text.addEventListener(MouseEvent.MOUSE_OVER, on_mouse_over);
            display_text.addEventListener(MouseEvent.MOUSE_OUT, on_mouse_out);
        }
        
        public function set_font_size(size:int):void {
            format.size = size;
            font_size = size;
            font_size_rollover = size;
            display_text.setTextFormat(format);
        }
        
        public function set_color(color:uint):void {
            format.color = color;
            text_color = color;
        }
        
        public function on_mouse_over(evt:MouseEvent):void {
            format.color = rollover_color;
            format.size = font_size_rollover;
            display_text.setTextFormat(format);
        }
        
        public function on_mouse_out(evt:MouseEvent):void {
            format.color = text_color;
            format.size = font_size;
			display_text.setTextFormat(format);
        }
        
        public function on_click(evt:MouseEvent):void {
            action();
        }
    }
}