package oapeui.dialog
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import oape.common.OALogger;
	import oape.common.OAToolkit;
	import oape.common.OsCallBackParam;
	import oape.events.io.FodderManagerEvent;
	import oape.io.managers.FodderManager;
	
	import oapeui.common.OAPopUpManager;
	import oapeui.common.struct.OAUS_TextFormat;
	import oapeui.component.base.OAU_Button;
	import oapeui.component.base.OAU_Panel;
	import oapeui.component.base.OAU_TextArea;
	import oapeui.component.base.OAU_TextInput;
	import oapeui.component.base.OAU_ToggleButton;
	import oapeui.component.items.list.OAU_ListImageItem;
	import oapeui.component.items.list.OAU_ListItem;
	import oapeui.component.items.list.OAU_ListTextItem;
	import oapeui.core.OAU_SkinContainer;
	

	/**
	 * 对话框:提示框,
	 * uiResPreName属性对按钮皮肤不起效,考虑到可能会使用不同样式的按钮,方便后续扩展和修改,
	 * */
	public final class OAU_AlertDialog extends OAU_Panel
	{
		/**
		 * @private
		 * */
		public static const __$$ClassName:String = "OAU_AlertDialog";
		
		/**
		 * @private
		 * 关闭按钮
		 * */
		protected var _skinClassNameKey_CloseButton:String = "alertdialog_closebutton";
		
		/**
		 * 关闭按钮对象
		 * */
		private var _closeButton:DisplayObject;
		
		/**
		 * 对话框按钮
		 * */
		private var _buttons:Vector.<OAU_Button> = new Vector.<OAU_Button>();
		
		/**
		 * 文本显示框
		 * */
		private var _textArea:OAU_TextArea;
		
		/**
		 * 内部子对象的边距
		 * */
		private var _contentPadding:int = 10;
		
		
		/**
		 * 按钮之间的间距
		 * */
		private var _buttonPadding:int = 10;
		
		
		/**
		 * 回调函数
		 * */
		private var _callBackFunction:Dictionary = new Dictionary();
		
		/**
		 * @param	content				显示的文本
		 * @param	buttons				显示的按钮(key=>value,按钮的name=>array{按钮的文本,按钮的资源前缀[uiResPreName]})
		 * @param	buttonTextFormat	按钮的文本样式
		 * @param	contentTextFormat	显示的文本的样式
		 * @param	uiName				使用的UINAME,默认是类名
		 * @param	uiResPreName		资源的名字前缀(不能影响按钮样式)
		 * */
		public function OAU_AlertDialog(content:String,buttons:Dictionary , buttonTextFormat:OAUS_TextFormat , contentTextFormat:OAUS_TextFormat, uiName:String = "" ,uiResPreName:String = "")
		{
			if(_$ClassName == "" || _$ClassName == null)
			{
				_$ClassName = "OAU_AlertDialog";
			}
			_$UIName = (uiName == null || uiName == "")?_$ClassName:uiName;
			
			var skinChilds:Vector.<OAU_SkinContainer> = new Vector.<OAU_SkinContainer>();
			if(buttons != null)
			{
				var dialogButtons:OAU_Button;
				var buttoninfo:Array;
				for(var btname:String in buttons)
				{
					buttoninfo = buttons[btname] as Array;
					if(buttoninfo == null || buttoninfo.length <2){ continue;}
					dialogButtons = new OAU_Button(_$UIName,buttoninfo[1]);
					dialogButtons.width = 50;
					dialogButtons.name = btname;
					dialogButtons.setText(buttoninfo[0],buttonTextFormat);
					_buttons.push(dialogButtons);
					skinChilds.push(dialogButtons);
				}
			}
			
			_textArea = new OAU_TextArea(_$UIName,uiResPreName);
			_textArea.name = __$$ClassName+"_textArea";
			_textArea.setText(content,contentTextFormat);
			_textArea.setEditable(false);
			skinChilds.push(_textArea);
			
			super(uiName,uiResPreName,"","",skinChilds);
			
			this.setSize(200,100);
			
			this.addSkinClassNameKey(_skinClassNameKey_CloseButton);
			
			this.loadUIFodders();
		}
		
		
		/**
		 * 设置点击回调函数
		 * @param	buttonClickFunc	按钮点击的回调函数
		 * @param	closeFunc		窗口关闭按钮点击的回调函数
		 * */
		public function setCallbackFunction(buttonClickFunc:Function,closeFunc:Function):void
		{
			_callBackFunction["buttonClickFunc"] = buttonClickFunc;
			_callBackFunction["closeFunc"] = closeFunc;
		}
		
		
		protected function buttonClickEvent(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
//			trace(_$ClassName+"=>buttonClickEvent:"+event.target.name);
			var ocbp:OsCallBackParam = new OsCallBackParam();
			ocbp._message = event.target.name;
			ocbp._dataObject["target"] = this;
			OAPopUpManager.removePopUp(this);
			
			var callBackFunc:Function;
			
			if(event.target.name == getSkinClassName(_skinClassNameKey_CloseButton))
			{
				callBackFunc = _callBackFunction["closeFunc"] as Function;
			}else
			{
				callBackFunc = _callBackFunction["buttonClickFunc"] as Function;
			}
			if(callBackFunc != null)
			{
				OAToolkit.callCallBackFunction([callBackFunc],ocbp);
			}
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
			var skinClass:Class;
			var initSkinSuccess:Boolean = true;
			var skinClassName:String;
			var i:int;
			
			skinClassName = getSkinClassName(_skinClassNameKey_CloseButton);
				
			skinClass = FodderManager.getFodderClass(_fodderUrl,skinClassName);
			if(skinClass)
			{
				_closeButton = new skinClass();
				_closeButton.name = skinClassName;
				this._containerSkinExtra.addChild(_closeButton);
				_closeButton.addEventListener(MouseEvent.CLICK , buttonClickEvent);
				_skinObject[_closeButton.name] = _closeButton;
			}else
			{
				OALogger.warn(_$ClassName+"=>initSkin,name:"+this.name+",缺少资源类:"+skinClassName+",于素材文件:"+_fodderUrl);
				initSkinSuccess = false;
			}
			
			if(initSkinSuccess == false){ return ;}
			
			for(i=0;i<_buttons.length;i++)
			{
				_buttons[i].addEventListener(MouseEvent.CLICK , buttonClickEvent);
			}
			super.initSkin();
			
			sizeChange();
		}	
				
		
		/**
		 * @private
		 * @param	callerClassName		调用者的类名
		 * !childOverRideRequire(子类必须重载)
		 * 子类必须重载这个方法,作资源的释放
		 * */
		protected override function dispose(callerClassName:String = ""):void
		{
			var i:int;
			for(i=0;i<_buttons.length;i++)
			{
				_buttons[i].removeEventListener(MouseEvent.CLICK , buttonClickEvent);
				this.removeChild(_buttons[i]);
			}
			_closeButton.removeEventListener(MouseEvent.CLICK , buttonClickEvent);
			this.removeChild(_textArea);
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
		 * !childCallRequire(子类必须调用父类此方法)
		 * */
		public override function updateDisplay():void
		{
			if(this._hadInitSkin == false){ return ;}
			
			_closeButton.x = _width - _closeButton.width - _contentPadding;
			_closeButton.y = _contentPadding;
			
			_textArea.x = _contentPadding;
			_textArea.y = _closeButton.height + _contentPadding+5;
			_textArea.width = _width - _contentPadding*2;
			
			if(_buttons.length == 0)
			{
				_textArea.height = _height - _contentPadding - _textArea.y;
			}else
			{
				_textArea.height = _height - _contentPadding - _textArea.y - _buttons[0].height - 5;
				
				var i:int,totalWidth:int;
				for(i=0;i<_buttons.length;i++)
				{
					totalWidth += _buttons[i].width;
				}
				//计算间距
				var padding:int = 0;
				var xpos:int = 0;
				var distance:int = _width - _contentPadding*2 - totalWidth;
				if(distance >0)
				{
					padding = distance / (_buttons.length - 1);
					if(padding > _buttonPadding){ padding = _buttonPadding;}
					
					xpos = (_width - totalWidth - padding*(_buttons.length - 1))/2;
				}
				
				for(i=0;i<_buttons.length;i++)
				{
					_buttons[i].x = xpos;
					_buttons[i].y = _height - _buttons[i].height - _contentPadding;
					xpos += _buttons[i].width+padding;
				}
				
			}
			super.updateDisplay();
		}

	}
}
