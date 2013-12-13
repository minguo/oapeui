package oapeui.component.items.list
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import oape.common.OALogger;
	import oape.events.io.FodderEventDispatcher;
	import oape.events.io.FodderManagerEvent;
	import oape.io.managers.FodderManager;
	
	import oapeui.OAPEUIConfig;
	import oapeui.common.struct.OAUS_FodderInfo;
	import oapeui.common.struct.OAUS_TextFormat;
	import oapeui.component.base.OAU_HScrollbar;
	import oapeui.component.base.OAU_VScrollbar;
	import oapeui.core.OAU_SkinContainer;
	
	/**
	 * 高级UI控件:文本框列表项
	 * 
	 * */
	public class OAU_ListTextItem extends OAU_ListItem
	{
		/**
		 * @private
		 * */
		public static const __$$ClassName:String = "OAU_ListTextItem";
		
		/**
		 * 文本框
		 * */
		private var _textField:TextField;
		
		/**
		 * 文本样式
		 * */
		private var _textFormat:OAUS_TextFormat;
		
		/**
		 * @private
		 * 文本
		 * */
		protected var _text:String = "";
		
		/**
		 * @private
		 * 文本的HTML内容,这个内容的显示优先级比_text高
		 * */
		protected var _htmlText:String = "";
		

		/**
		 * @param	uiName		使用的UINAME,默认是类名
		 * */		
		public function OAU_ListTextItem(uiName:String = "")
		{
			if(_$ClassName == "" || _$ClassName == null)
			{
				_$ClassName = "OAU_ListTextItem";
			}
			_$UIName = (uiName == null || uiName == "")?_$ClassName:uiName;
			super(_$UIName);
		}
		
		
		/**
		 *  设置文字样式
		 * */
		public function setItemTextFormat(tf:OAUS_TextFormat):void
		{
			_textFormat = tf;
		}
		
		
		/**
		 * 设置文本的内容
		 * */
		public function setText(text:String,tf:OAUS_TextFormat = null):void
		{
			_text = text;
			
			this.setTextFormat(tf);
		}
		
		/**
		 * 获取文本内容
		 * */
		public function getText():String
		{
			return _text;
		}
		
		/**
		 * 设置文本格式
		 * */
		public function setTextFormat(tf:OAUS_TextFormat = null):void
		{
			if(tf)
			{
				if(tf._textFormat == null)
				{
					tf._textFormat = new TextFormat();
				}
				tf._textFormat.align = TextFormatAlign.LEFT;
			}
			
			_textFormat = tf;
			
			this.updateDisplay();
		}
		
		
		/**
		 * 设置文本的HTML内容,如果设置了HTMLText,则会忽略Text的内容
		 * */
		public function setHtmlText(htmlText:String):void
		{
			_htmlText = htmlText;
			this.updateDisplay();
		}
		
		
		
		//==============================以下为必须重载的函数=============================
		
		/**
		 * @private
		 * 子类可以重载这个方法,显示加载进度
		 * */
		protected override function fodderLoadProcess(event:FodderManagerEvent):void
		{
			// TODO Auto-generated method stub
			/**
			 * 这里添加你的初始化代码
			 * */
		}		
		
		/**
		 * @private
		 * 加载素材失败会在这里抛出日志
		 * */
		protected override function fodderLoadError(event:FodderManagerEvent):void
		{
			// TODO Auto-generated method stub
			OALogger.warn(_$ClassName+"=>fodderLoadError,素材加载失败:"+event.sourceUrl);
		}
		
		
		/**
		 * @private
		 * !childOverRideRequire(子类必须重载)
		 * !childCallRequire(子类必须调用父类此方法)
		 * 子类必须重载这个方法,执行操作,不过必须调用父类的相同方法.
		 * 这个方法会调用checkFodderSkinClass函数检查素材的完整性,调用initSkin函数开始显示的初始化
		 * */
		protected override function fodderLoadComplete(event:FodderManagerEvent):void
		{
			// TODO Auto-generated method stub
			/**
			 * 这里添加你的代码
			 * */
			super.fodderLoadComplete(event);
		}
		
		
		/**
		 * @private
		 * !childOverRideRequire(子类必须重载)
		 * !childCallRequire(子类必须调用父类此方法)
		 * 皮肤的初始化函数,必须由子类去重载
		 * */
		protected override function initSkin():void
		{
			
			_textField = new TextField();
			_textField.name = "listTextItemTextField";
			_textField.mouseEnabled = false;
			this.addChild(_textField);
			
			super.initSkin();
			
			this.sizeChange();
		}
		
		
		/**
		 * @private
		 * @param	callerClassName		调用者的类名
		 * !childOverRideRequire(子类必须重载)
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
			/**
			 * 这里添加你的代码
			 * */
			updateDisplay();	
		}
		
		
		/**
		 * 当改变大小或者父容器增加和减少子容器对象的时候,前者会自动调用这个方法,后者必须手动调用这个方法,更新滚动条的滚动值
		 * !childOverRideRequire(子类必须重载)
		 * !childCallRequire(子类必须调用父类此方法)
		 * */
		public override function updateDisplay():void
		{
			if(this._hadInitSkin == false){ return ;}
			
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
			
			if(_width < _textField.width)
			{
				//宽度超出范围了
				_textField.width = _width;
				_textField.x = 0;
			}else
			{
				_textField.x = (_width - _textField.width)/2;
			}
			
			if(_height < _textField.height)
			{
				//高度超出范围
				_height = _textField.height;
				
			}else
			{
				_textField.y = (_height - _textField.height)/2;
			}
			
//			trace(_$ClassName+"=>updateDisplay,height:"+_height);
			
			
			super.updateDisplay();
		}
		
		
	}
}