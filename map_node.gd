extends Area2D

enum NodeType {START, LEVEL, SHOP, BOSS}
@export var node_type: NodeType = NodeType.LEVEL

# These are the variables that will show up in the Inspector!
@export var next_node: Area2D
@export var prev_node: Area2D

func _ready() -> void:
	match node_type:
		NodeType.START: $ColorRect.color = Color.GREEN
		NodeType.LEVEL: $ColorRect.color = Color.BLUE
		NodeType.SHOP: $ColorRect.color = Color.GOLD
		NodeType.BOSS: $ColorRect.color = Color.RED
