package oapeui.component
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
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
	 * 高级UI控件:进度条(Demo)
	 * */
	public final class OAU_ProgressBar extends OAU_SkinContainer
	{
		/**
		 * @private
		 * */
		public static const __$$ClassName:String = "OAU_ProgressBar";
		
		/**
		 * @private
		 * 进度条素材
		 * */
		protected var _skinClassNameKey_Bar:String = "progressbar_bar";
		
		/**
		 * 当前进度
		 * */
		private var _progress:int = 0;
		
		
		/**
		 * 用于记录进度条元件的最大X值,他是根据素材摆放位置决定的,见参考素材
		 * */
		private var _progress_bar_width:int = 0;
		
		/**
		 * @param	uiName			使用的UINAME,默认是类名
		 * @param	uiResPreName	资源的名字前缀
		 * */
		public function OAU_ProgressBar(uiName:String = "",uiResPreName:String = "")
		{
			if(_$ClassName == "" || _$ClassName == null)
			{
				_$ClassName = "OAU_ProgressBar";
			}
			_$UIName = (uiName == null || uiName == "")?_$ClassName:uiName;
			super(uiResPreName);
			
			this.addSkinClassNameKey(_skinClassNameKey_Bar);
			
			this.loadUIFodders();
		}
		
		
		/**
		 * 设置当前的显示进度
		 * @param	progress	(0-100)
		 * */
		public function setProgress(progress:int):void
		{
			if(progress <0 || progress > 100){ progress = 0;}
			_progress = progress;
			
			this.updateDisplay();
		}
		
		
		/**
		 * 返回当前进度
		 * */
		public function getProgress():int
		{
			return _progress;
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
			
			var skinClassName:String = getSkinClassName(_skinClassNameKey_Bar);
			var target:MovieClip = _skinObject[skinClassName];
			
			if(target && target.bar)
			{
				if(_progress_bar_width == 0)
				{
					var barRect:Rectangle = target.getBounds(target.bar);
//					trace(_$ClassName+"=>updateDisplay,barRect:"+barRect);
					_progress_bar_width = -1*barRect.x;/**这里计算素材的最大X坐标偏移量**/
				}
				
				target.width = _width;
				target.bar.x = (_progress/100)*_progress_bar_width;
				
				if(target.progresstxt)
				{
					target.progresstxt.text = _progress+"%";
				}
			}
			
			super.updateDisplay();
		}
		
	}
}
