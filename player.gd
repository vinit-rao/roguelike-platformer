extends CharacterBody2D

@export var max_speed: float = 300.0
@export var acceleration: float = 1500.0
@export var friction: float = 1200.0
@export var gravity: float = 980.0
@export var jump_velocity: float = -400.0

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# -1 = left, +1 = right, 0 = none
	var direction := Input.get_axis("move_left","move_right")

	# accelerate & decelerate
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	move_and_slide()
