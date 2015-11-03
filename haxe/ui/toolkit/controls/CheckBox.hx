package haxe.ui.toolkit.controls;

import openfl.events.Event;
import haxe.ui.toolkit.core.base.VerticalAlign;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.IClonable;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.layout.HorizontalLayout;
import haxe.ui.toolkit.style.Style;

/**
 Simple two state checkbox control
 **/

@:event("UIEvent.CHANGE", "Dispatched when the value of the checkbox is modified") 
class CheckBox extends Component implements IClonable<CheckBox> {
	private var _value:CheckBoxValue;
	private var _label:Text;
	private var _selected:Bool;
	
	public function new() {
		super();
		autoSize = true;
		sprite.buttonMode = true;
		sprite.useHandCursor = true;
		_value = new CheckBoxValue();
		_label = new Text();
		layout = new HorizontalLayout();
	}

	//******************************************************************************************
	// Overrides
	//******************************************************************************************
	private override function initialize():Void {
		super.initialize();

		_value.verticalAlign = VerticalAlign.CENTER;
		_label.percentWidth = 100;
		addChild(_value);
		addChild(_label);
		
		_label.addEventListener(UIEvent.CLICK, function(e) {
			_value.cycleValues();
		});
		
		_value.addEventListener(UIEvent.CHANGE, function (e) {
			selected = _value.value == "selected"; // updates checkbox state.
		}); 
	}
	
	//******************************************************************************************
	// Component overrides
	//******************************************************************************************
	private override function get_text():String {
		return _label.text;
	}
	
	private override function set_text(value:String):String {
		value = super.set_text(value);
		_label.text = value;
		return value;
	}
	
	private override function get_value():Dynamic {
		return selected;
	}
	
	private override function set_value(newValue:Dynamic):Dynamic {
		if (Std.is(newValue, String)) {
			selected = (newValue == "true");
		} else {
			selected = newValue;
		}
		return newValue;
	}
	
	//******************************************************************************************
	// Component getters/setters
	//******************************************************************************************
	/**
	 Defines whether or not the text can span more than a single line
	 **/
	@:clonable
	public var multiline(get, set):Bool;
	@:clonable
	public var wrapLines(get, set):Bool;
	/**
	 Defines whether the checkbox is checked or not
	 **/
	@:clonable
	public var selected(get, set):Bool;

	private function get_multiline():Bool {
		return _label.multiline;
	}
	
	private function set_multiline(value:Bool):Bool {
		_label.multiline = value;
		return value;
	}

	private function get_wrapLines():Bool {
		return _label.wrapLines;
	}
	
	private function set_wrapLines(value:Bool):Bool {
		_label.wrapLines = value;
		return value;
	}
	
	private function get_selected():Bool {
		return _selected;
	}
	
	private function set_selected(value:Bool):Bool {
		if (_selected == value) {
			return value;
		}
		
		_value.value = (value == true) ? "selected" : "unselected";
		_selected = value;
		
		var event:Event = new Event(Event.CHANGE);
		dispatchEvent(event);
		
		return value;
	}
	
	//******************************************************************************************
	// IStyleable
	//******************************************************************************************
	public override function applyStyle():Void {
		super.applyStyle();
		
		// apply style to label
		if (_label != null) {
			var labelStyle:Style = new Style();
			if (_baseStyle != null) {
				labelStyle.fontName = _baseStyle.fontName;
				labelStyle.fontSize = _baseStyle.fontSize;
				labelStyle.fontEmbedded = _baseStyle.fontEmbedded;
				labelStyle.color = _baseStyle.color;
			}
			_label.baseStyle = labelStyle;
		}
	}
}

@:dox(hide)
class CheckBoxValue extends Value implements IClonable<CheckBoxValue> {
	public function new() {
		super();
		_value = "unselected";
		addValue("selected");
		addValue("unselected");
	}
}