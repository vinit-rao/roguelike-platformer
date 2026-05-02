extends Node

var current_map_node: Area2D = null

var modifiers = [
	{
		"title": "Icy Ground",
		"description": "Friction is drastically reduced. Slippery!",
		"friction_multiplier": 0.1,
		"max_speed_multiplier": 1.2
	},
	{
		"title": "Heavy Boots",
		"description": "Sluggish acceleration, but you stop instantly.",
		"friction_multiplier": 5.0,
		"acceleration_multiplier": 0.5
	},
	{
		"title": "Speed Demon",
		"description": "Move and accelerate twice as fast.",
		"max_speed_multiplier": 2.0,
		"acceleration_multiplier": 2.0
	},
	{
		"title": "No Modifier",
		"description": "Default and Simple",
		"max_speed_multiplier": 1.0,
		"acceleration_multiplier": 1.0
	}
]

func get_draft_choices():
	var available = modifiers.duplicate()
	available.shuffle()
	return available.slice(0, 3)
