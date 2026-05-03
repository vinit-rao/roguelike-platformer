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
	if GameManager.map_blueprint.is_empty():
		generate_map_data()
		generate_connections()
		GameManager.map_blueprint = map_layers
	else:
		map_layers = GameManager.map_blueprint

	spawn_map_visually()
	draw_lines()
	
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
		
	# for rows in between its rn 20% for shop and 80% for level
	if randf() > 0.8:
		return 2
	return 1
	
func spawn_map_visually() -> void:
	var player = get_parent().get_node("MapPlayer")
	
	for row_index in range(map_layers.size()):
		var current_row = map_layers[row_index]
		
		# trick to make it have a pyramid shape
		var row_width = (current_row.size() - 1) * horizontal_spacing
		var start_x = -row_width / 2.0
		
		for col_index in range(current_row.size()):
			var node_data = current_row[col_index]
			
			# create new copy of map node
			var new_node = map_node_scene.instantiate()
			
			# assign properties
			new_node.node_type = node_data["type"]
			new_node.grid_row = node_data["row"]
			new_node.grid_col = node_data["col"]
			
			if new_node.node_type == 1: # level
				new_node.node_name = "Combat Encounter"
				var diff = ["Normal", "Hard", "Elite"].pick_random()
				var gold = str(randi_range(15, 50))
				new_node.node_details = "Difficulty: " + diff + "\nReward: " + gold + " Gold"
			elif new_node.node_type == 2: # shop
				new_node.node_name = "Merchant"
				new_node.node_details = "Spend your gold for powerful modifiers!"
			elif new_node.node_type == 3: # boss
				new_node.node_name = "BOSS: The Gatekeeper"
				new_node.node_details = "WARNING: Extreme Danger."
			
			# add to scene
			add_child(new_node)
			
			# set pos
			var x_pos = start_x + (col_index * horizontal_spacing)
			var y_pos = -row_index * vertical_spacing
			new_node.global_position = Vector2(x_pos, y_pos)
			
			node_data["physical_node"] = new_node
			new_node.node_clicked.connect(player.on_node_clicked)
			
	var target_node = map_layers[GameManager.current_map_row][GameManager.current_map_col]["physical_node"]
	
	if player:
		player.current_node = target_node
		player.global_position = target_node.global_position

func generate_connections() -> void:
	for row in range(map_height - 1):
		var current_layer = map_layers[row]
		var next_layer = map_layers[row + 1]
		
		for i in range(current_layer.size()):
			var start_node = current_layer[i]
			var target_idx = clampi(i, 0, next_layer.size() - 1)
			start_node["next_connections"].append(next_layer[target_idx])
			
		for j in range(next_layer.size()):
			var target_node = next_layer[j]
			var has_incoming = false
			
			for start_node in current_layer:
				if target_node in start_node["next_connections"]:
					has_incoming = true
					
			if not has_incoming:
				var closest_idx = clampi(j, 0, current_layer.size() - 1)
				if target_node not in current_layer[closest_idx]["next_connections"]:
					current_layer[closest_idx]["next_connections"].append(target_node)

func draw_lines() -> void:
	for row in map_layers:
		for node_data in row:
			var start_node = node_data["physical_node"]
			var start_pos = start_node.global_position
			
			for target_data in node_data["next_connections"]:
				var target_node = target_data["physical_node"]
				var end_pos = target_node.global_position

				start_node.next_nodes.append(target_node)
				
				var line = Line2D.new()
				line.add_point(start_pos)
				line.add_point(end_pos)
				line.width = 4.0               
				line.default_color = Color.DIM_GRAY  
				line.z_index = -1              
				add_child(line)
