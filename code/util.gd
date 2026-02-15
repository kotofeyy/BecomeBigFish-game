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
	Size.SMALL : Vector2(2.3, 2.3),
	Size.MEDIUM : Vector2(2.6, 2.6),
	Size.LARGE : Vector2(2.9, 2.9),
	Size.EXTRA_LARGE : Vector2(3.1, 3.1),
	Size.DOUBLE_LARGE : Vector2(3.4, 3.4),
}
