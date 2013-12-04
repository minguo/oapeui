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
	import oape.common.OsCallBackParam;
	import oape.events.io.FodderEventDispatcher;
	import oape.events.io.FodderManagerEvent;
	import oape.io.managers.FodderManager;
	
	import oapeui.OAPEUIConfig;
	import oapeui.common.OAUS_FodderInfo;
	import oapeui.common.OAUS_TextFormat;
	import oapeui.component.base.OAU_HScrollbar;
	import oapeui.component.base.OAU_Image;
	import oapeui.component.base.OAU_VScrollbar;
	import oapeui.core.OAU_SkinContainer;
	
	/**
	 * 高级UI控件:图像列表项
	 * 
	 * */
	public class OAU_ListImageItem extends OAU_ListItem
	{
		/**
		 * @private
		 * */
		protected static var __$$ClassName:String = "OAU_ListTextItem";
		
		/**
		 * 图像
		 * */
		private var _image:OAU_Image;
		
		
		/**
		 * 标记图像是否已经加载好
		 * */
		private var _imageLoadComplete:Boolean = true;
		

		public function OAU_ListImageItem(uiName:String = "")
		{
			if(_$ClassName == "" || _$ClassName == null)
			{
				_$ClassName = "OAU_ListImageItem";
			}
			_$UIName = (uiName == null || uiName == "")?"OAU_ListItem":uiName;
			
			
			super(_$UIName);

		}
		
		
		/**
		 * 加载一个图像
		 * */
		public function loadImage(sourceUrl:String):void
		{
			if(_image)
			{
				this.removeChild(_image);
				_image = null;
			}
			if(sourceUrl == ""){ return ;}
			_imageLoadComplete = false;
			_image = new OAU_Image();
			_image.loadImage(sourceUrl,imageLoadComplete);
		}
		
		
		/**
		 *  图像加载完成
		 * */
		private function imageLoadComplete(ocbp:OsCallBackParam):void
		{
			_imageLoadComplete = true;
			this.addChild(_image);
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
			if(_imageLoadComplete == false){ return ;}

			if(_image)
			{
				_image.setSize(_width , _height);
			}
			
			super.updateDisplay();
		}
		
		
	}
}