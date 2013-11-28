package oapeui.component
{
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import oape.common.OALogger;
	import oape.io.managers.FodderManager;
	
	import oapeui.common.OAUS_TextFormat;
	import oapeui.component.base.OAU_Panel;
	

	/**
	 * 高级UI控件:内容提示框
	 * 这个UI的的大小,根据宽度,高度自动判定
	 * 
	 * */
	public final class OAU_ToolTip extends OAU_Panel
	{
		/**
		 * @private
		 * */
		protected static var __$$ClassName:String = "OAU_ToolTip";
		
		/**
		 * 文本显示控件
		 * */
		private var _textField:TextField;
		
		/**
		 * 要显示的内容
		 * */
		private var _text:String = "";
		
		/**
		 * 要显示的HTML内容,优先级大于text
		 * */
		private var _htmlText:String = "";
		
		/**
		 * 文本的样式
		 * */
		protected var _textFormat:OAUS_TextFormat = null;
		
		/**
		 * 四周边距
		 * */
		protected var _padding:int = 20;
		
		
		/**
		 * 使用的UI名字,这个名字如果不设定默认会使用类名
		 * */
		public function OAU_ToolTip(uiName:String = "")
		{
			if(_$$ClassName == "" || _$$ClassName == null)
			{
				_$$ClassName = "OAU_ToolTip";
			}
			_$UIName = (uiName == null || uiName == "")?"OAU_ToolTip":uiName;
			super(_$UIName);
			
//			this._rectDisplayMode = false;
		}
		
		
		/**
		 * @private
		 * !childOverRideRequire(子类必须重载)
		 * !childCallRequire(子类必须调用父类此方法)
		 * 皮肤显示的初始化函数,必须由子类重载
		 * */
		protected override function initSkin():void
		{
			_textField = new TextField();
			_textField.multiline = true;
			_textField.wordWrap = true;
			this.addChild(_textField);
			
			super.initSkin();
			sizeChange();
		}
		
		
		/**
		 * 设置要显示的文本内容
		 * */
		public function setText(text:String , tf:OAUS_TextFormat):void
		{
			_text = text;
			
			if(tf == null)
			{
				tf = new OAUS_TextFormat();
			}
			if(tf._textFormat == null)
			{
				tf._textFormat = new TextFormat();
			}
			tf._textFormat.align = TextFormatAlign.LEFT;
			
			_textFormat = tf;
			
			this.updateDisplay();
		}
		
		
		/**
		 * @private
		 * !childOverRideRequire(子类必须重载)
		 * !childCallRequire(子类必须调用父类此方法)
		 * 子类必须重载这个方法,作资源的释放
		 * */
		protected override function dispose(callerClassName:String = ""):void
		{
			super.dispose(_$$ClassName);
		}
		
		
		
		/**
		 * 当改变大小的时候,会调用这个函数
		 * !childOverRideRequire(子类必须重载)
		 * */
		protected override function sizeChange():void
		{
			updateDisplay();	
		}
		
		/**
		 * 当改变大小或者父容器增加和减少子容器对象的时候,前者会自动调用这个方法,后者必须手动调用这个方法,更新滚动条的滚动值
		 * !childOverRideRequire(子类必须重载)
		 * */
		public override function updateDisplay():void
		{
			if(_hadInitSkin == false){ return ;}
			
			var target:DisplayObject;
			
			var upButtonHeight:int = 0;
			var thumbHeight:int = 0;
			
			if(_width < _padding*3){ _width = _padding*3;}

			_textField.x = _textField.y = _padding;
			_textField.width = _width - _padding*2;
			
			if(_htmlText != "")
			{
				_textField.htmlText = _htmlText;
				_textField.autoSize = TextFieldAutoSize.LEFT;
			}else
			{
				//更新显示
				_textField.text = _text;
				_textField.autoSize = TextFieldAutoSize.LEFT;
				if(_textFormat)
				{
					_textField.setTextFormat(_textFormat._textFormat);
					_textField.filters = _textFormat._filters;
				}
			}
			_height = _textField.height+_padding*2;
			
			super.updateDisplay();
		}
	}
}