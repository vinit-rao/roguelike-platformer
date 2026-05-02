extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Level Complete! Returning to Overworld...")
		body.active_modifier = {} 
		get_tree().change_scene_to_file("res://OverworldMap.tscn")
