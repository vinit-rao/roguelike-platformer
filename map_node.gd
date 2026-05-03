extends Area2D

enum NodeType {START, LEVEL, SHOP, BOSS}
@export var node_type: NodeType = NodeType.LEVEL

var next_nodes: Array[Area2D] = []

signal node_clicked(node: Area2D)

var grid_row: int = 0
var grid_col: int = 0

var node_name: String = "Unknown"
var node_details: String = "No info."

func _ready() -> void:
	match node_type:
		NodeType.START: $ColorRect.color = Color.GREEN
		NodeType.LEVEL: $ColorRect.color = Color.BLUE
		NodeType.SHOP: $ColorRect.color = Color.GOLD
		NodeType.BOSS: $ColorRect.color = Color.RED

func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		node_clicked.emit(self)
