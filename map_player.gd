extends CharacterBody2D

@export var current_node: Area2D
var is_moving: bool = false

func _ready() -> void:
	if GameManager.current_map_node != null:
		current_node = GameManager.current_map_node
	if current_node:
		global_position = current_node.global_position

func _process(_delta: float) -> void:
	if is_moving or not current_node:
		return
		
	if Input.is_action_just_pressed("ui_right") and current_node.next_node:
		move_to_node(current_node.next_node)
		
	elif Input.is_action_just_pressed("ui_left") and current_node.prev_node:
		move_to_node(current_node.prev_node)
		
	elif Input.is_action_just_pressed("ui_accept"): 
		enter_level()

func move_to_node(target_node: Area2D) -> void:
	is_moving = true
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_node.global_position, 0.3).set_trans(Tween.TRANS_SINE)
	await tween.finished
	current_node = target_node
	is_moving = false

func enter_level() -> void:
	if current_node.node_type == current_node.NodeType.LEVEL:
		print("Transitioning to action level...")
		GameManager.current_map_node = current_node
		get_tree().change_scene_to_file("res://World.tscn")
