extends Node
class_name Util

enum Size {  
	EXTRA_SMALL,
	SMALL,
	MEDIUM,
	LARGE,
	EXTRA_LARGE,
	DOUBLE_LARGE 
	}

const size_to_scale = {
	Size.EXTRA_SMALL : Vector2(2.0, 2.0),
	Size.SMALL : Vector2(2.4, 2.4),
	Size.MEDIUM : Vector2(2.8, 2.8),
	Size.LARGE : Vector2(3.2, 3.2),
	Size.EXTRA_LARGE : Vector2(3.6, 3.6),
	Size.DOUBLE_LARGE : Vector2(4.0, 4.0),
}
