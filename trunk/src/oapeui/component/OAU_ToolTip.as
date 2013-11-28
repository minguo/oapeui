package oapeui.component
{
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	import oape.common.OALogger;
	import oape.io.managers.FodderManager;
	
	import oapeui.component.base.OAU_Panel;
	

	/**
	 * 高级UI控件:内容提示框
	 * */
	public class OAU_ToolTip extends OAU_Panel
	{
		/**
		 * 背景块
		 * */
		private var _skinClassName_Background:String = "tooltip_background";
		
		/**
		 * 文本显示控件
		 * */
		private var _textField:TextField;
		
		/**
		 * 要显示的内容
		 * */
		private var _text:String = "";
		
		
		/**
		 * 使用的UI名字,这个名字如果不设定默认会使用类名
		 * */
		public function OAU_ToolTip(uiName:String = "")
		{
			super();
			this.enableDrop(true);
			_rectDisplayMode = true;
			__$$ClassName = "OAU_ToolTip";
			_$UIName = (uiName == null || uiName == "")?"OAU_ToolTip":uiName;
			
			
			
			this._skinClassNames.push(_skinClassName_Background);
			
			super.loadUIFodders();
		}
		
		
		/**
		 * @private
		 * !childOverRideRequire(子类必须重载)
		 * !childCallRequire(子类必须调用父类此方法)
		 * 皮肤显示的初始化函数,必须由子类重载
		 * */
		protected override function initSkin():void
		{
			var skin:DisplayObject;
			var skinClass:Class;
			var initSkinSuccess:Boolean = true;
			
			skinClass = FodderManager.getFodderClass(_fodderUrl,_skinClassName_Background);
			if(skinClass)
			{
				skin = new skinClass();
				skin.name = _skinClassName_Background;
				this._containerSkin.addChild(skin);
				_skinObject[skin.name] = skin;
			}else
			{
				OALogger.warn(__$$ClassName+"=>initSkin,name:"+this.name+",缺少资源类:"+_skinClassName_Background+",于素材文件:"+_fodderUrl);
				initSkinSuccess = false;
			}
			if(initSkinSuccess == false){ return ;}
			super.initSkin();
			
			
			sizeChange();
		}
		
		
		/**
		 * 设置要显示的文本内容
		 * */
		public function setText(text:String):void
		{
			_text = text;
			this.updateDisplay();
		}
		
		
		/**
		 * @private
		 * !childOverRideRequire(子类必须重载)
		 * !childCallRequire(子类必须调用父类此方法)
		 * 子类必须重载这个方法,作资源的释放
		 * */
		protected override function dispose(callerClassName:String = ""):void
		{
			super.dispose(__$$ClassName);
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
		 * */
		public override function updateDisplay():void
		{
			if(_hadInitSkin == false){ return ;}
			
			var target:DisplayObject;
			
			var upButtonHeight:int = 0;
			var thumbHeight:int = 0;
			
			target = _skinObject[_skinClassName_Background];
			if(target)
			{
				target.width = _width;
				target.height = _height;
			}
			
			
			super.updateDisplay();
		}
	}
}