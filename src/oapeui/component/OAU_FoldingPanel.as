package oapeui.component
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
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
	import oapeui.component.base.OAU_ToggleButton;
	import oapeui.core.OAU_SkinContainer;
	
	
	/**
	 * 高级UI控件:折叠式面板
	 * */
	public final class OAU_FoldingPanel extends OAU_SkinContainer
	{
		/**
		 * @private
		 * */
		public static const __$$ClassName:String = "OAU_FoldingPanel";
		
		
		/**
		 * tab标签按钮
		 * */
		private var _tabItems:Vector.<OAU_ToggleButton> = new Vector.<OAU_ToggleButton>();
		
		
		/**
		 * tab标签指向的容器
		 * */
		private var _tabContainer:Vector.<OAU_Panel> = new Vector.<OAU_Panel>();
		
		/**
		 * tab标签的样式
		 * */
		private var _tabItemTextFormat:OAUS_TextFormat;
		
		/**
		 * @param	uiName		使用的UINAME,默认是类名
		 * */
		public function OAU_FoldingPanel(uiName:String = "")
		{
			if(_$ClassName == "" || _$ClassName == null)
			{
				_$ClassName = "OAU_FoldingPanel";
			}
			_$UIName = (uiName == null || uiName == "")?_$ClassName:uiName;
			super();
			
			this.initSkin();
		}
		
		
		
		/**
		 * 添加一个标签,并把这个标签跟一个容器关联起来
		 * @param	tabName			tab标签对象的name属性
		 * @param	tabTitle		tab标签的文字内容
		 * @param	container		tab标签切换到的容器,容器的宽度会跟随UI的宽度,高度需要自己设定
		 * @param	tabButtonHeight	tab标签按钮的默认高度
		 * */
		public function addTab(tabName:String  , tabTitle:String, container:OAU_Panel ,tabButtonHeight:int = 25 ):void
		{
			if(tabName == "" || tabName == null)
			{ 
				OALogger.error(_$ClassName+"=>addTab,tabName未设定");
				return ;
			}
			
			if(container == null)
			{
				OALogger.error(_$ClassName+"=>addTab,不允许添加空的容器");
				return;
			}
			
			if(_tabItems.length != _tabContainer.length)
			{
				OALogger.error(_$ClassName+"=>addTab,tab标签数和对应容器的数量不一致,添加失败");
				return ;
			}
			
			container.enableDrag(false);
			var tabItem:OAU_ToggleButton;
			if((tabItem = this.getChildByName(tabName) as OAU_ToggleButton) != null)
			{
				//已存在的按钮
			}else
			{
				tabItem = new OAU_ToggleButton(_$UIName);//这里必须使用当前的UINAME,否则会使用默认的togglebutton
				tabItem.name = tabName;
				this._tabItems[this._tabItems.length] = tabItem;
				
				this._tabContainer[this._tabContainer.length] = container;
				
				tabItem.addEventListener(MouseEvent.CLICK , tabItemClickEvent);
				
				this.addChild(tabItem);
				this.addChild(container);
			}
			tabItem.setSize(_width,tabButtonHeight);
			tabItem.setText(tabTitle,_tabItemTextFormat);
			
			this.updateDisplay();
		}
		
		protected function tabItemClickEvent(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			this.updateDisplay();
		}		
		
		/**
		 * 设置当前选中的标签
		 * @param	tabName		目标标签按钮的name
		 * */
		public function setSelectedTabItem(tabName:String):void
		{
			var i:int;
			for(i=0;i<_tabItems.length;i++)
			{
				if(_tabItems[i].name == tabName)
				{
					_tabItems[i].setSelected(true);
					_tabContainer[i].visible = true;
				}else
				{
					_tabContainer[i].visible = false;
				}
			}
			
			this.updateDisplay();
		}
		
		
		/**
		 * 返回当前被选中标签按钮的名字,如果没有被选中的标签按钮则返回null
		 * */
		public function getSelectedTabItemName():Array
		{
			var i:int;
			var selectedTabItemName:Array = [];
			for(i=0;i<_tabItems.length;i++)
			{
				if(_tabItems[i].isSelected() == true)
				{
					selectedTabItemName.push(_tabItems[i].name);
				}
			}
			
			return selectedTabItemName;
		}
		
		
		/**
		 * 会当前被选中标签的容器对象
		 * */
		public function getSelectedTabPanel():Vector.<OAU_Panel>
		{
			var i:int;
			var selectedPanel:Vector.<OAU_Panel> = new Vector.<OAU_Panel>();
			for(i=0;i<_tabItems.length;i++)
			{
				if(_tabItems[i].isSelected() == true)
				{
					selectedPanel.push(_tabContainer[i]);
				}
			}
			
			return selectedPanel;
		}
		
		/**
		 * 移除一个tab标签
		 * @param	tabName		目标标签按钮的name
		 * */
		public function removeTab(tabName:String):void
		{
			var i:int;

			for(i=0;i<_tabItems.length;i++)
			{
				if(_tabItems[i].name == tabName)
				{
					this.removeChild(_tabItems[i]);
					this.removeChild(_tabContainer[i]);
					_tabItems.splice(i,1);
					_tabContainer.splice(i,1);
					break;
				}
			}
			
			this.updateDisplay();
		}
		
		
		/**
		 *  设置tab标签按钮的文字样式
		 * */
		public function setTabItemTextFormat(tf:OAUS_TextFormat):void
		{
			_tabItemTextFormat = tf;
			
			var tablen:int = _tabItems.length;
			var i:int;
			
			for(i =0;i<tablen;i++)
			{
				_tabItems[i].setTextFormat(_tabItemTextFormat);
			}
		}
		
		
		/**
		 * 根据tab标签的name,获取对应容器
		 * */
		public function getPanelByTabName(tabName:String):OAU_Panel
		{
			if(_tabItems.length != _tabContainer.length)
			{
				OALogger.error(_$ClassName+"=>getPanelByTabName,tab标签数和对应容器的数量不一致");
				return null;
			}
			
			var tablen:int = _tabItems.length;
			var i:int;
			for(i=0;i<tablen;i++)
			{
				if(_tabItems[i].name == tabName)
				{
					return _tabContainer[i];
				}
			}
			
			return null;
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
			/**
			 * 这里添加你的代码
			 * */
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
			_tabItemTextFormat = null;
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
			
			if(_tabItems.length != _tabContainer.length)
			{
				return ;
			}
			
			var i:int;
			var tabLen:int = _tabItems.length;
			var tabYpos:int = 0;
			
			for(i=0;i<tabLen;i++)
			{
				if(_tabItems[i] == null){ continue;}
				_tabItems[i].width = _width;
				
				_tabItems[i].y = tabYpos;
				tabYpos += _tabItems[i].height;
				
				if(_tabItems[i].isSelected() == false)
				{
					_tabContainer[i].visible = false;
				}else
				{
					_tabContainer[i].y = tabYpos;
					tabYpos += _tabContainer[i].height;
					_tabContainer[i].width = _width;
					_tabContainer[i].visible = true;
				}
			}
			
			super.updateDisplay();
		}
		
	}
}
