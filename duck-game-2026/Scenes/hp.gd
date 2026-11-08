extends ProgressBar

func _ready() -> void:
	max_value = Global.nest_max_hp
	value = Global.nest_hp
	Global.nest_hp_changed.connect(_on_nest_hp_changed)
	
func _on_nest_hp_changed(current: float, maximum: float) -> void:
	max_value = maximum
	var tween := create_tween()
	tween.tween_property(self, "value", current, 0.25)
