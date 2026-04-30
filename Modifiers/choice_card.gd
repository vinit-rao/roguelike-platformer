extends Control

var modifier_data: Dictionary

func _ready() -> void:
	pivot_offset = size / 2 
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func setup(data: Dictionary) -> void:
	modifier_data = data
	%TitleLabel.text = data["title"]
	%DescLabel.text = data["description"]

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1)
	z_index = 1 

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	z_index = 0

# on card select
func _on_select_button_pressed() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.active_modifier = modifier_data
		print("Applied: ", modifier_data["title"])
	
	var menu = get_tree().root.find_child("DraftMenu", true, false)
	if menu:
		menu.queue_free()
