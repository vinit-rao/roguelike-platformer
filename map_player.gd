extends CharacterBody2D

@export var current_node: Area2D
var is_moving: bool = false

func on_node_clicked(clicked_node: Area2D) -> void:
	if is_moving or not current_node:
		return
		
	if clicked_node in current_node.next_nodes:
		move_to_node(clicked_node)
	else:
		print("You cannot reach that node from here!")

func move_to_node(target_node: Area2D) -> void:
	is_moving = true
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_node.global_position, 0.3).set_trans(Tween.TRANS_SINE)
	
	await tween.finished
	current_node = target_node
	is_moving = false
	
	enter_level()

func enter_level() -> void:
	if current_node.node_type == current_node.NodeType.LEVEL:
		print("Transitioning to action level...")
		# save grid coords after every level
		GameManager.current_map_row = current_node.grid_row
		GameManager.current_map_col = current_node.grid_col
		
		get_tree().change_scene_to_file("res://World.tscn")
