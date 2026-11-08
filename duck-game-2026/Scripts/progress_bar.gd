extends ProgressBar
@export var health_label: Label
@export var game_over_panel: Panel

func _ready() -> void:
	max_value = Global.start_nest_max_hp
	value = Global.start_nest_max_hp
	Global.nest_hp_changed.connect(_on_nest_hp_changed)
	health_label.text = "Health: " + str(int(max_value))
	
	Global.nest_destroyed.connect(_on_nest_destroyed)
	
func _on_nest_hp_changed(current: float, maximum: float) -> void:
	max_value = maximum
	value = current
	health_label.text = "Health: " + str(int(value))
	#var tween := create_tween()
	#tween.tween_property(self, "value", current, 0.25)

func _on_nest_destroyed() -> void:
	game_over_panel._transition_to_end()
	pass
