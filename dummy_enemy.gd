extends CharacterBody2D

var health: int = 3

func take_damage(amount: int) -> void:
	health -= amount
	print("Enemy hit! Health remaining: ", health)
	
	# A quick flash effect so we know it got hit
	modulate = Color(5, 5, 5, 1) 
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if health <= 0:
		print("Dummy destroyed!")
		queue_free()


func _on_damage_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.has_method("take_damage"):
		body.take_damage(1)
