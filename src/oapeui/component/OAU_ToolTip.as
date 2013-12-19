package oapeui.component
{
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import oape.common.OALogger;
	import oape.io.managers.FodderManager;
	
	import oapeui.common.struct.OAUS_TextFormat;
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
		public static const __$$ClassName:String = "OAU_ToolTip";
		
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
		 * @param	uiName			使用的UINAME,默认是类名
		 * @param	uiResPreName	资源的名字前缀
		 * */
		public function OAU_ToolTip(uiName:String = "",uiResPreName:String = "")
		{
			if(_$ClassName == "" || _$ClassName == null)
			{
				_$ClassName = "OAU_ToolTip";
			}
			_$UIName = (uiName == null || uiName == "")?_$ClassName:uiName;
			
			super(_$UIName,uiResPreName);
			
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
		 * 设置文字的边距
		 * @param	padding		间距(像素)
		 * */
		public function setPadding(padding:int):void
		{
			_padding = padding;
			this.updateDisplay();
		}
		
		/**
		 * 获取文字的边距
		 * */
		public function getPadding():int
		{
			return _padding;
		}
		
		
		//==============================以下为必须重载的函数=============================
		
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
		 * @private
		 * !childOverRideRequire(子类必须重载)
		 * !childCallRequire(子类必须调用父类此方法)
		 * 子类必须重载这个方法,作资源的释放
		 * */
		protected override function dispose(callerClassName:String = ""):void
		{
			super.dispose(_$ClassName);
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