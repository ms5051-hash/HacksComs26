extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _transition_to_end() -> void:
	# gonna change this later to something fancy
	visible = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and visible:
		_on_menu_button_pressed()
	pass

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/mainScene.tscn")
	pass
