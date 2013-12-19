package oapeui.component
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import oape.common.OALogger;
	import oape.events.io.FodderManagerEvent;
	import oape.io.managers.FodderManager;
	
	import oapeui.common.struct.OAUS_TextFormat;
	import oapeui.component.base.OAU_Panel;
	import oapeui.component.base.OAU_TextInput;
	import oapeui.component.base.OAU_ToggleButton;
	import oapeui.component.items.list.OAU_ListImageItem;
	import oapeui.component.items.list.OAU_ListItem;
	import oapeui.component.items.list.OAU_ListTextItem;
	import oapeui.core.OAU_SkinContainer;
	

	/**
	 * 高级UI控件:下拉列表选择框
	 * */
	public final class OAU_ComboBox extends OAU_SkinContainer
	{
		/**
		 * @private
		 * */
		public static const __$$ClassName:String = "OAU_ComboBox";
		
		/**
		 * @private
		 * 弹出下拉列表的按钮
		 * */
		protected var _skinClassNameKey_DropDownButton:String = "combobox_dropdownbutton";
		
		/**
		 * 文本框
		 * */
		private var _textInput:OAU_TextInput;
		
		/**
		 * 下拉列表框
		 * */
		private var _dropDownList:OAU_List;
		
		/**
		 * 下拉列表显示列表项的个数
		 * */
		private var _dropDownListNum:int = 5;
		
		/**
		 * @param	uiName				使用的UINAME,默认是类名
		 * */
		public function OAU_ComboBox(uiName:String = "" )
		{
			if(_$ClassName == "" || _$ClassName == null)
			{
				_$ClassName = "OAU_ComboBox";
			}
			_$UIName = (uiName == null || uiName == "")?_$ClassName:uiName;
			
			var skinChilds:Vector.<OAU_SkinContainer> = new Vector.<OAU_SkinContainer>();
			
			_textInput = new OAU_TextInput(_$UIName);
			_textInput.name = __$$ClassName+"_textInput";
			skinChilds.push(_textInput);
			
			_dropDownList = new OAU_List(_$UIName);
			_dropDownList.name = __$$ClassName+"_dropDownList";
			_dropDownList.visible = false;
			skinChilds.push(_dropDownList);
			
			super();
			
			this.setSize(100,25);
			
			this.addSkinClassNameKey(_skinClassNameKey_DropDownButton);
			
			this.loadUIFodders();
		}
		
		
		/**
		 * 修改下拉列表的列出项数量
		 * */
		public function setDropDownListNum(num:int):void
		{
			_dropDownListNum = num;
			this.updateDisplay();
		}
		
		
		/**
		 * 设置是否可编辑状态
		 * */
		public function setEditable(bool:Boolean):void
		{
			_textInput.setEditable(bool);
		}
		
		
		/**
		 * 返回当前的可编辑状态
		 * */
		public function getEditable():Boolean
		{
			return _textInput.getEditable();
		}
		
		
		/**
		 * 获取当前的内容
		 * */
		public function getText():String
		{
			return _textInput.getText();
		}
		
		
		/**
		 * 设置文本框样式
		 * */
		public function setTextFormat(tf:OAUS_TextFormat):void
		{
			_textInput.setTextFormat(tf);
		}
		
		
		/**
		 * 添加一个下拉列表项
		 * */
		public function addItem(item:OAU_ListItem):void
		{
			if(item.getValue() == null || item.getValue() == "")
			{
				OALogger.warn(_$ClassName+"=>addItem,添加了一个没有调用setValue设置值的OAU_ListItem");
			}
			_dropDownList.addItem(item);
			this.updateDisplay();
		}
		
		
		/**
		 * 根据Item的name属性移除一个列表项
		 * */
		public function removeItem(itemName:String):void
		{
			_dropDownList.removeItem(itemName);
			this.updateDisplay();
		}
		
		
		/**
		 * 获取当前列表项的数量
		 * */
		public function getItemNum():int
		{
			return _dropDownList.getItemNum();
		}
		
		/**
		 * 获取指定位置的item
		 * */
		public function getItemAt(index:int):OAU_ListItem
		{
			return _dropDownList.getItemAt(index);
		}
		
		
		/**
		 * 设置最多可以容纳的字符数量
		 * */
		public function setMaxChars(num:int):void
		{
			_textInput.setMaxChars(num);
		}
		
		
		protected function dropDownButtonClick(event:Event):void
		{
			// TODO Auto-generated method stub
			_dropDownList.visible = !_dropDownList.visible;
		}
		
		
		protected function dropDownListMouseClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(event.target)
			{
				if(event.target is OAU_ListItem)
				{
					_textInput.setText(OAU_ListTextItem(event.target).getValue());
					_dropDownList.visible = false;
				}
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
			var skin:DisplayObject;
			var skinClass:Class;
			var initSkinSuccess:Boolean = true;
			var skinClassName:String;
			var i:int;
			
			for(i=0;i<_skinClassNameKeys.length;i++)
			{
				skinClassName = getSkinClassName(_skinClassNameKeys[i]);
				
				skinClass = FodderManager.getFodderClass(_fodderUrl,skinClassName);
				if(skinClass)
				{
					skin = new skinClass();
					skin.name = skinClassName;
					this._containerSkin.addChild(skin);
					_skinObject[skin.name] = skin;
				}else
				{
					OALogger.warn(_$ClassName+"=>initSkin,name:"+this.name+",缺少资源类:"+skinClassName+",于素材文件:"+_fodderUrl);
					initSkinSuccess = false;
					break;
				}
			}
			
			if(initSkinSuccess == false){ return ;}
			
			/**添加文本输入框**/
			this.addChild(_textInput);
			
			/**添加下拉列表框**/
			_dropDownList.visible = false;
			this.addChild(_dropDownList);
			_dropDownList.addEventListener(MouseEvent.CLICK , dropDownListMouseClick);
			
			
			/**设置按钮的监听事件**/
			skinClassName = getSkinClassName(_skinClassNameKey_DropDownButton);
			if(_skinObject[skinClassName])
			{
				DisplayObject(_skinObject[skinClassName]).addEventListener(MouseEvent.CLICK , dropDownButtonClick);
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
			var skinClassName:String = getSkinClassName(_skinClassNameKey_DropDownButton);
			if(_skinObject[skinClassName])
			{
				DisplayObject(_skinObject[skinClassName]).removeEventListener(MouseEvent.CLICK , dropDownButtonClick);
			}
			_dropDownList.removeEventListener(MouseEvent.CLICK , dropDownListMouseClick);
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
			
			var skinClassName:String = getSkinClassName(_skinClassNameKey_DropDownButton);
			if(_skinObject[skinClassName] == null){ return ;}
			

			_textInput.width = _width - _skinObject[skinClassName].width;
			_skinObject[skinClassName].height = _textInput.height = _height;
			_skinObject[skinClassName].x = _textInput.width;
			
			_dropDownList.width = _width;
			_dropDownList.y = _height;
			
			var i:int = 0;
			var dropDownNum:int = _dropDownList.getItemNum();
			var totalHeight:int = 0;
			for(i=0;i<_dropDownListNum;i++)
			{
				if(i>= dropDownNum){ break;}/**到最后一个了**/
				
				totalHeight += _dropDownList.getItemAt(i).height;
			}
			if(totalHeight == 0 ){ totalHeight = 20;}/**给他一个默认的高度吧**/
			_dropDownList.height = totalHeight;
			
			super.updateDisplay();
		}

	}
}
