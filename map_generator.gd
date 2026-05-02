extends Node

# height is how many rows to reach the boss stage
@export var map_height: int = 5
@export var min_nodes_per_layer: int = 2
@export var max_nodes_per_layer: int = 4

# The physical spacing between dots on the screen
@export var horizontal_spacing: float = 100.0
@export var vertical_spacing: float = 80.0

@export var map_node_scene: PackedScene

# This will hold the raw data of our generated map
var map_layers: Array = []

func _ready() -> void:
	generate_map_data()
	spawn_map_visually()

func generate_map_data() -> void:
	map_layers.clear()
	
	for current_row in range(map_height):
		var layer_nodes: Array = []
		
		# node count in group
		var node_count: int
		if current_row == 0:
			node_count = 1 # start node
		elif current_row == map_height - 1:
			node_count = 1 # boss node
		else:
			# rng for how many branches
			node_count = randi_range(min_nodes_per_layer, max_nodes_per_layer)
			
		for i in range(node_count):
			var node_data = {
				"row": current_row,
				"col": i,
				"type": determine_node_type(current_row),
				"next_connections": []
			}
			layer_nodes.append(node_data)
			
		map_layers.append(layer_nodes)

func determine_node_type(row: int) -> int:
	if row == 0:
		return 0 # start
	if row == map_height - 1:
		return 3 # boss
		
	# For rows in between its rn 20% for shop and 80% for level
	if randf() > 0.8:
		return 2
	return 1
	
func spawn_map_visually() -> void:
	for row_index in range(map_layers.size()):
		var current_row = map_layers[row_index]
		
		# trick to make it have a pyramid shape
		var row_width = (current_row.size() - 1) * horizontal_spacing
		var start_x = -row_width / 2.0
		
		for col_index in range(current_row.size()):
			var node_data = current_row[col_index]
			
			# create new copy of map node
			var new_node = map_node_scene.instantiate()
			add_child(new_node)
			
			# assign color
			new_node.node_type = node_data["type"]
			
			# set pos
			var x_pos = start_x + (col_index * horizontal_spacing)
			var y_pos = -row_index * vertical_spacing
			new_node.global_position = Vector2(x_pos, y_pos)
			node_data["physical_node"] = new_node

	# start at start node
	var start_node = map_layers[0][0]["physical_node"]
	var player = get_parent().get_node("MapPlayer")
	
	if player and GameManager.current_map_node == null:
		player.current_node = start_node
		player.global_position = start_node.global_position
