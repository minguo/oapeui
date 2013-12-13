package oapeui.componentmodel
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
	import oapeui.common.struct.OAUS_FodderInfo;
	import oapeui.component.base.OAU_HScrollbar;
	import oapeui.component.base.OAU_VScrollbar;
	import oapeui.core.OAU_SkinContainer;
	
	/**
	 * 带皮肤的容器,标准函数执行流程.
	 * 初始化:::构造函数=>loadUIFodders(手动)=>fodderLoadComplete(自动,重载)=>initSkin(自动,重载)=>sizeChange(手动)=>updateDisplay(手动)
	 * 释放资源:::dispose(自动,重载)
	 * */
	public class model_OAU_SkinContainer extends OAU_SkinContainer
	{
		/**
		 * @private
		 * */
		public static const __$$ClassName:String = "model_OAU_SkinContainer";/**必须修改**/
		
		/**
		 * @param	uiName		使用的UINAME,默认是类名
		 * */
		public function model_OAU_SkinContainer(uiName:String = "")
		{
			if(_$ClassName == "" || _$ClassName == null)
			{
				_$ClassName = "model_OAU_SkinContainer";/**必须修改**/
			}
			_$UIName = (uiName == null || uiName == "")?_$ClassName:uiName;
			
			var skinChilds:Vector.<OAU_SkinContainer> = new Vector.<OAU_SkinContainer>();/**如果没有滚动条之类的皮肤附加UI控件,这行代码可以注释掉**/
			/**
			 * 这里添加你的子UI控件,必须添加完了再调用super,否则的话,就不能保证子UI初始化完了再初始化当前UI的顺序
			 * */
			super(skinChilds);
			/**
			 * 这里添加你的初始化代码
			 * */
			
			this.loadUIFodders();//这行代码可选
		}
		
		
		/**
		 * 
		 * 
		 * 在这里添加你的自定义函数
		 * 
		 * 
		 * */
		
		
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
			/**
			 * 这里添加你的代码
			 * */
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
			/**
			 *  这里添加你的代码
			 * */
			super.updateDisplay();
		}
		
		
	}
}