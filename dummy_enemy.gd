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
