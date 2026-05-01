extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Completed level now exiting...")
		body.active_modifier = {} 
		get_tree().paused = true
