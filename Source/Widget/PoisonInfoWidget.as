class PoisonInfoWidget extends skyui.widgets.WidgetBase
{	
  /* STAGE ELEMENTS */
	
	public var poisonLeft: MovieClip;
	public var poisonRight: MovieClip;
  
	public var poisonTextLeft: TextField;
	public var poisonTextRight: TextField;
  
  
  /* INITIALIZATION */

	public function PoisonInfoWidget()
	{
		super();
		
		poisonTextLeft = poisonLeft.poisonTextLeft;
		poisonTextLeft.textAutoSize = "shrink";
		poisonTextLeft.verticalAlign = "center";
		setPoisonTextLeft("");
		
		poisonTextRight = poisonRight.poisonTextRight;
		poisonTextRight.textAutoSize = "shrink";
		poisonTextRight.verticalAlign = "center";
		setPoisonTextRight("");
	}


  /* PUBLIC FUNCTIONS */
  
	// @overrides WidgetBase
	public function getWidth(): Number
	{
		return _width;
	}

	// @overrides WidgetBase
	public function getHeight(): Number
	{
		return _height;
	}

	// @Papyrus
	public function setVisible(a_visible: Boolean): Void
	{
		_visible = a_visible;
	}
	
	// @Papyrus
	public function setPoisonTextLeft(a_text: String): Void
	{
		poisonTextLeft.text = String(a_text);
		poisonLeft._visible = a_text != "";
	}
	
	// @Papyrus
	public function setPoisonTextRight(a_text: String): Void
	{
		poisonTextRight.text = String(a_text);
		poisonRight._visible = a_text != "";
	}
	
	
	// @Papyrus
	public function setPoisonLeftPosX(a_x: Number): Void
	{
		poisonLeft._x = a_x;
	}
	
	// @Papyrus
	public function setPoisonLeftPosY(a_y: Number): Void
	{
		poisonLeft._y = a_y;
	}
	
	// @Papyrus
	public function setPoisonRightPosX(a_x: Number): Void
	{
		poisonRight._x = a_x;
	}
	
	// @Papyrus
	public function setPoisonRightPosY(a_y: Number): Void
	{
		poisonRight._y = a_y;
	}
}