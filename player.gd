extends CharacterBody2D

@export var max_speed: float = 300.0
@export var acceleration: float = 1500.0
@export var friction: float = 1200.0
@export var gravity: float = 980.0
@export var jump_velocity: float = -400.0
@onready var attack_hitbox: CollisionShape2D = $AttackHitbox/CollisionShape2D

# define states
enum State {IDLE, RUN, AIR, ATTACK}
var current_state: State = State.IDLE


func _physics_process(delta: float) -> void:
	# state switcher
	match current_state:
		State.IDLE:
			idle_state(delta)
		State.RUN:
			run_state(delta)
		State.AIR:
			air_state(delta)
		State.ATTACK:
			attack_state(delta)
	
	# gravity (if you attack you will stop falling briefly)
	if not is_on_floor() and current_state != State.ATTACK:
		velocity.y += gravity * delta
	
	move_and_slide()
	
	# state logic
	
func idle_state(delta: float) -> void:
	apply_friction(delta)
	# jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	elif Input.get_axis("move_left","move_right") != 0:
		current_state = State.RUN
	elif Input.is_action_just_pressed("attack_primary"):
		start_attack()

func run_state(delta: float) -> void:
	
	# -1 = left, +1 = right, 0 = none
	var direction := Input.get_axis("move_left","move_right")
	
	apply_acceleration(direction, delta)
	
	if direction == 0:
		current_state = State.IDLE
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	elif Input.is_action_just_pressed("attack_primary"):
		start_attack()
		
		
		
func air_state(delta: float) -> void:
	var direction := Input.get_axis("move_left","move_right")
	apply_acceleration(direction,delta)
	
	if is_on_floor():
		if direction == 0:
			current_state = State.IDLE
		else:
			current_state = State.RUN
			
func attack_state(_delta: float) -> void:
	# prevent accidental horizontal movement
	velocity.x = 0
	
# helper functions

func apply_friction(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, friction * delta)

func apply_acceleration(direction: float, delta: float) -> void:
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)

func jump() -> void:
	velocity.y = jump_velocity
	current_state = State.AIR

func start_attack() -> void:
	current_state = State.ATTACK
	print("M1 pressed")
	
	# enable hitbox and wait
	attack_hitbox.disabled = false
	await get_tree().create_timer(0.3).timeout
	
	# disable hitbox and reset
	attack_hitbox.disabled = true
	
	if current_state == State.ATTACK:
		current_state = State.IDLE
