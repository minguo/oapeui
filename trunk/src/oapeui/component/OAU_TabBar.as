package oapeui.component
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import oape.common.OALogger;
	import oape.events.io.FodderManagerEvent;
	import oape.io.managers.FodderManager;
	
	import oapeui.common.OAUS_TextFormat;
	import oapeui.component.base.OAU_Panel;
	import oapeui.component.base.OAU_ToggleButton;
	import oapeui.core.OAU_SkinContainer;
	

	/**
	 * 高级UI控件:标签栏
	 * 这个UI控件不受setSize影响
	 * */
	public final class OAU_TabBar extends OAU_SkinContainer
	{
		/**
		 * @private
		 * */
		protected static var __$$ClassName:String = "OAU_TabBar";
		
		/**
		 * 水平排版方式
		 * */
		public static var __LayoutDir_V:int = 0;
		
		/**
		 * 垂直排版方式
		 * */
		public static var __LayoutDir_H:int = 1;
		
		/**
		 * 默认是水平排版方式
		 * */
		private var _layoutDir:int = 0;
		
		/**
		 * 四周边距
		 * */
		private var _padding:int = 2;
		
		/**
		 * tab标签设定
		 * */
		private var _tabItems:Vector.<OAU_TabBar_Item> = new Vector.<OAU_TabBar_Item>();
		
		/**
		 * tab标签的样式
		 * */
		private var _tabItemTextFormat:OAUS_TextFormat;
		
		/**
		 * 使用的UI名字,这个名字如果不设定默认会使用类名
		 * */
		public function OAU_TabBar(uiName:String = "")
		{
			if(_$$ClassName == "" || _$$ClassName == null)
			{
				_$$ClassName = "OAU_TabBar";
			}

			super();
			
			this.initSkin();
		}
		
		
		/**
		 * 添加一个标签,并把这个标签跟一个容器关联起来
		 * @param	tabName		tab标签对象的name属性
		 * @param	tabTitle	tab标签的文字内容
		 * @param	tabTarget	tab标签切换的对象
		 * */
		public function addTab(tabName:String , tabTitle:String):void
		{
			if(tabName == "" || tabName == null)
			{ 
				OALogger.error(_$$ClassName+"=>addTab,tabName未设定");
				return ;
			}
			
			var tabItem:OAU_TabBar_Item = new OAU_TabBar_Item();
			
			tabItem._tabName = tabName;
			tabItem._tabTitle = tabTitle;
			
			this._tabItems[this._tabItems.length] = tabItem;
			
			tabItem._tabButton = new OAU_ToggleButton();
			tabItem._tabButton.setText(tabTitle,_tabItemTextFormat);
			
			this.addChild(tabItem._tabButton);
			
			this.updateDisplay();
		}
		
		/**
		 * 移除一个tab标签
		 * */
		public function removeTab(tabName:String):void
		{
			var i:int;
			for(i=0;i<_tabItems.length;i++)
			{
				if(_tabItems[i]._tabName == tabName)
				{
					this.removeChild(_tabItems[i]._tabButton);
					_tabItems[i]._tabButton = null;
					_tabItems.splice(i,1);
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
		}
		
		
		/**
		 * 设置排版方式,水平还是垂直
		 * */
		public function setLayout(layout:int):void
		{
			_layoutDir = layout
		}
		
		
		
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
			OALogger.warn(_$$ClassName+"=>fodderLoadError,素材加载失败:"+event.sourceUrl);
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
			/**
			 * 这里添加你的代码
			 * */
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
		 * !childCallRequire(子类必须调用父类此方法)
		 * */
		public override function updateDisplay():void
		{
			if(this._hadInitSkin == false){ return ;}
			
			var i:int;
			var position:int = 0;
			
			if(_layoutDir == __LayoutDir_V)
			{
				//水平方向排列
				for(i=0;i<_tabItems.length;i++)
				{
					if(_tabItems[i]._tabButton == null){ continue;}
					_tabItems[i]._tabButton.x = position;
					position += _tabItems[i]._tabButton.width + _padding;
				}
			}else
			{
				//垂直方向排列
				for(i=0;i<_tabItems.length;i++)
				{
					if(_tabItems[i]._tabButton == null){ continue;}
					_tabItems[i]._tabButton.y = position;
					position += _tabItems[i]._tabButton.height + _padding;
				}
			}
			
			super.updateDisplay();
		}

	}
}

/**
 * tab标签的信息
 * */
import flash.display.DisplayObject;

import oapeui.component.base.OAU_ToggleButton;

class OAU_TabBar_Item
{
	public var _tabName:String;
	
	public var _tabTitle:String
	
	public var _tabButton:OAU_ToggleButton;
}