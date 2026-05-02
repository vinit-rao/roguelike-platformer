extends Node

# height is how many rows to reach the boss stage
@export var map_height: int = 5
@export var min_nodes_per_layer: int = 2
@export var max_nodes_per_layer: int = 4

# The physical spacing between dots on the screen
@export var horizontal_spacing: float = 100.0
@export var vertical_spacing: float = 80.0

# This will hold the raw data of our generated map
var map_layers: Array = []

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
