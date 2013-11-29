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
	import flash.utils.Dictionary;
	
	import oape.common.OALogger;
	import oape.events.io.FodderEventDispatcher;
	import oape.events.io.FodderManagerEvent;
	import oape.io.managers.FodderManager;
	
	import oapeui.OAPEUIConfig;
	import oapeui.common.OAUS_FodderInfo;
	import oapeui.component.base.OAU_HScrollbar;
	import oapeui.component.base.OAU_VScrollbar;
	import oapeui.core.OAU_SkinContainer;
	
	/**
	 * 高级UI控件:列表项
	 * 
	 * */
	public class OAU_ListItem extends OAU_SkinContainer
	{
		/**
		 * @private
		 * */
		protected static var __$$ClassName:String = "OAU_ListItem";
		
		
		/**
		 * @private
		 * 普通背景框
		 * */
		protected var _skinClassName_BackGround_Normal:String = "listitem_background_normal";
		
		
		/**
		 * @private
		 * 鼠标移过背景框
		 * */
		protected var _skinClassName_BackGround_MouseOver:String = "listitem_background_mouseover";
		
		/**
		 * 当前是否显示鼠标经过的状态
		 * */
		private var _isMouseOver:Boolean = false;
		
		/**
		 * 这里开始添加你的变量
		 * */
		
		public function OAU_ListItem(uiName:String = "")
		{
			if(_$ClassName == "" || _$ClassName == null)
			{
				_$ClassName = "OAU_ListItem";
			}
			_$UIName = (uiName == null || uiName == "")?"OAU_ListItem":uiName;
			super();
			
			this._skinClassNames.push(_skinClassName_BackGround_Normal);
			this._skinClassNames.push(_skinClassName_BackGround_MouseOver);
			
			this.loadUIFodders();
		}
		
		
		
		protected function mouseOutEvent(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			_isMouseOver = false;
			this.updateDisplay();
		}
		
		protected function mouseOverEvent(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
//			trace(_$ClassName+"=>mouseOverEvent:"+this.name);
			_isMouseOver = true;
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
			var skin:DisplayObject;
			var skinClass:Class;
			var initSkinSuccess:Boolean = true;
			var i:int;
			
			skinClass = FodderManager.getFodderClass(_fodderUrl,_skinClassName_BackGround_Normal);
			if(skinClass)
			{
				skin = new skinClass();
				skin.name = _skinClassName_BackGround_Normal;
				this._containerSkin.addChild(skin);
				_skinObject[skin.name] = skin;
			}else
			{
				OALogger.warn(_$ClassName+"=>initSkin,name:"+this.name+",缺少资源类:"+_skinClassName_BackGround_Normal+",于素材文件:"+_fodderUrl);
				initSkinSuccess = false;
			}
			
			
			for(i=0;i<_skinClassNames.length;i++)
			{
				if(_skinClassNames[i] == _skinClassName_BackGround_Normal){ continue;}
				
				skinClass = FodderManager.getFodderClass(_fodderUrl,_skinClassNames[i]);
				if(skinClass)
				{
					skin = new skinClass();
					skin.name = _skinClassNames[i];
					this._containerSkin.addChild(skin);
					skin.visible = false;
					_skinObject[skin.name] = skin;
				}else
				{
					OALogger.warn(_$ClassName+"=>initSkin,name:"+this.name+",缺少资源类:"+_skinClassNames[i]+",于素材文件:"+_fodderUrl);
					initSkinSuccess = false;
					break;
				}
			}
			
			if(initSkinSuccess == false){ return ;}
			
			super.initSkin();
			
			this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverEvent);
			this.addEventListener(MouseEvent.MOUSE_OUT,mouseOutEvent);
			
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
			this.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverEvent);
			this.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutEvent);
			
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
			
			var i:int =0;
			for(i=0;i<_skinClassNames.length;i++)
			{
				trace("setHeight:"+_skinClassNames[i]+":"+_height);
				_skinObject[_skinClassNames[i]].width = _width;
				_skinObject[_skinClassNames[i]].height = _height;
			}
			
			if(_isMouseOver == true)
			{
				_skinObject[_$UIResPreName+_skinClassName_BackGround_Normal].visible = false;
				_skinObject[_$UIResPreName+_skinClassName_BackGround_MouseOver].visible = true;
			}else
			{
				_skinObject[_$UIResPreName+_skinClassName_BackGround_Normal].visible = true;
				_skinObject[_$UIResPreName+_skinClassName_BackGround_MouseOver].visible = false;
			}
			
			super.updateDisplay();
		}
		
		
	}
}