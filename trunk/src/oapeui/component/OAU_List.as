package oapeui.component
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import oape.common.OALogger;
	import oape.events.io.FodderEventDispatcher;
	import oape.events.io.FodderManagerEvent;
	import oape.io.managers.FodderManager;
	
	import oapeui.OAPEUIConfig;
	import oapeui.common.OAUS_FodderInfo;
	import oapeui.component.base.OAU_HScrollbar;
	import oapeui.component.base.OAU_Panel;
	import oapeui.component.base.OAU_VScrollbar;
	import oapeui.component.items.list.OAU_ListItem;
	import oapeui.component.items.list.OAU_ListTextItem;
	import oapeui.core.OAU_SkinContainer;
	
	/**
	 * 高级UI控件:列表框
	 * */
	public final class OAU_List extends OAU_Panel
	{
		/**
		 * @private
		 * */
		public static const __$$ClassName:String = "OAU_List";
		
		
		/**
		 * 装载所有列表项的地方
		 * */
		private var _listItems:Vector.<OAU_ListItem> = new Vector.<OAU_ListItem>();
		
		/**
		 * 右侧滚动条
		 * */
		private var _vscrollBar:OAU_VScrollbar;
		
		/**
		 * @param	uiName		使用的UINAME,默认是类名
		 * */
		public function OAU_List(uiName:String = "")
		{
			if(_$ClassName == "" || _$ClassName == null)
			{
				_$ClassName = "OAU_List";
			}
			_$UIName = (uiName == null || uiName == "")?_$ClassName:uiName;
			
			//侧面滚动条
			_vscrollBar = new OAU_VScrollbar();//使用默认样式
			_vscrollBar.name = "list_vscrollbar";
			_vscrollBar.visible = false;
			var skinChilds:Vector.<OAU_SkinContainer> = new Vector.<OAU_SkinContainer>();
			skinChilds.push(_vscrollBar);
			
			_vscrollBar.setScrollTarget(this);
			
			super(_$UIName,skinChilds);
			this._enableDrop = false;
			
			
			this._rectDisplayMode = true;
		}
		
		
		/**
		 * 添加一个列表项
		 * @param	item		列表项
		 * @param	index		追加到的位置,默认追加到尾部
		 * */
		public function addItem(item:OAU_ListItem,index:int = -1):void
		{
			if(item == null){ return ;}
			
			if(index <0){ index = _listItems.length;}
			
			_listItems.splice(index,0,item);
			item.visible = false;
			this.addChild(item);
			
			this.updateDisplay();
		}
		
		
		/**
		 * 移除一个列表项
		 * */
		public function removeItem(itemName:String):void
		{
			if(itemName == null || itemName == ""){ return;}
			
			var i:int = 0;
			var itemLen:int = _listItems.length;
			
			for(i=0;i<itemLen;i++)
			{
				if(_listItems[i].name == itemName)
				{
					this.removeChild(_listItems[i]);
					_listItems.splice(i,1);
					break;
				}
			}
			
			this.updateDisplay();
		}
		
		
		/**
		 * 获取指定位置的item
		 * */
		public function getItemAt(index:int):OAU_ListItem
		{
			if(index >= _listItems.length){ return null;}
			
			return _listItems[index];
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
//			trace("listInit");
			super.initSkin();
			_vscrollBar.updateDisplay();//初始化完以后,必须updatedisplay一次滚动条
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
			_vscrollBar.height = _height;
			_vscrollBar.x = _width - _vscrollBar.width;
			updateDisplay();
		}
		
		/**
		 * 当改变大小或者父容器增加和减少子容器对象的时候,前者会自动调用这个方法,后者必须手动调用这个方法,更新滚动条的滚动值
		 * !childOverRideRequire(子类必须重载)
		 * */
		public override function updateDisplay():void
		{
			if(_hadInitSkin == false){ return ;}
			
			var i:int = 0;
			var itemLen:int = _listItems.length;
			var position:int = 0;//标记后一个item的Y坐标点
//			trace(__$$ClassName+"===================");
			for(i=0;i<itemLen;i++)
			{
				_listItems[i].width = _width;
				if(i>0)
				{
					_listItems[i].y = position;
				}else
				{
					_listItems[i].y = 0;
				}
				if(_listItems[i].visible == false)
				{
					_listItems[i].visible = true;
				}
//				trace(__$$ClassName+"=>updatedisplay,_listItems["+i+"].y:"+_listItems[i].y);
				position += _listItems[i].height;
			}
			
			if(position > this._height)
			{
				//子对象的高度超过LIST高度,显示滚动条
				_vscrollBar.visible = true;
				for(i=0;i<itemLen;i++)
				{
					_listItems[i].width = _width - _vscrollBar.width;
				}
			}else
			{
				_vscrollBar.setThumbPosition(0);
				_vscrollBar.visible = false;
				for(i=0;i<itemLen;i++)
				{
					_listItems[i].width = _width;
				}
			}
			
			super.updateDisplay();
		}
		
		
	}
}