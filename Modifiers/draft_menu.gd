extends Control

@export var card_scene: PackedScene

func _ready() -> void:
	var choices = GameManager.get_draft_choices()
	
	for child in $HBoxContainer.get_children():
		child.queue_free()
		
	for data in choices:
		var new_card = card_scene.instantiate()
		$HBoxContainer.add_child(new_card)
		new_card.setup(data)
