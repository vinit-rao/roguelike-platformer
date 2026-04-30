extends CharacterBody2D

@export var max_speed: float = 300.0
@export var acceleration: float = 1500.0
@export var friction: float = 1200.0
@export var gravity: float = 980.0
@export var jump_velocity: float = -400.0
@onready var attack_hitbox: CollisionShape2D = $AttackHitbox/CollisionShape2D

# level modifiers
@export var active_modifier: Dictionary = {}

# define states
enum State {IDLE, RUN, AIR, ATTACK}
var current_state: State = State.IDLE

func _ready() -> void:
	var my_choices = GameManager.get_draft_choices()
	print("Draft Choice 1: ", my_choices[0]["title"])
	print("Draft Choice 2: ", my_choices[1]["title"])
	print("Draft Choice 3: ", my_choices[2]["title"])
	active_modifier = my_choices[0]


func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# user input
	var input_dir = Input.get_axis("move_left", "move_right")

	# define states
	match current_state:
		State.IDLE:
			apply_friction(delta)
			if input_dir != 0: current_state = State.RUN
			if Input.is_action_just_pressed("jump") and is_on_floor(): jump()
			if Input.is_action_just_pressed("attack_primary"): start_attack()
			
		State.RUN:
			apply_acceleration(input_dir, delta)
			if input_dir == 0: current_state = State.IDLE
			if Input.is_action_just_pressed("jump") and is_on_floor(): jump()
			if Input.is_action_just_pressed("attack_primary"): start_attack()
			
		State.AIR:
			apply_acceleration(input_dir, delta)
			if is_on_floor():
				current_state = State.IDLE if input_dir == 0 else State.RUN
				
		State.ATTACK:
			velocity.x = 0

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
	var current_friction = friction
	
	if active_modifier.has("friction_multiplier"):
		current_friction *= active_modifier["friction_multiplier"]
		
	velocity.x = move_toward(velocity.x, 0, current_friction * delta)

func apply_acceleration(direction: float, delta: float) -> void:
	if direction != 0:
		var current_speed = max_speed
		var current_accel = acceleration
		
		if active_modifier.has("max_speed_multiplier"):
			current_speed *= active_modifier["max_speed_multiplier"]
		if active_modifier.has("acceleration_multiplier"):
			current_accel *= active_modifier["acceleration_multiplier"]
			
		velocity.x = move_toward(velocity.x, direction * current_speed, current_accel * delta)

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
