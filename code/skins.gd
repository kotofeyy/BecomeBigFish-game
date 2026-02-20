class_name Skins
extends Node


enum Type { 
	DEFAULT, 
	RED,
	GREEN, 
	BLUE, 
	RAINBOW
	}

const TypeToBit = {
	Type.DEFAULT: 1,
	Type.RED: 2,
	Type.GREEN: 4,
	Type.BLUE: 8,
	Type.RAINBOW: 16
}

const List: Dictionary[Type, Dictionary] = {
	Type.DEFAULT: {
		"cost": 0,
		"type": "color",
		"color": Color.BLACK,
	},
	Type.RED: {
		"cost": 5,
		"type": "color",
		"color": Color.RED,
	},
	Type.GREEN: {
		"cost": 50,
		"type": "color",
		"color": Color.GREEN,
	},
	Type.BLUE: {
		"cost": 5,
		"type": "color",
		"color": Color.BLUE,
	},
	Type.RAINBOW: {
		"cost": 10,
		"type": "rainbow",
		"color": Color.TRANSPARENT,
	},
}
