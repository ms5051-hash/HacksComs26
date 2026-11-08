extends ProgressBar
@export var level_label: Label

func _ready() -> void:
	max_value = Global.level_xp_max
	value = Global.level_xp_max
	level_label.text = "Level: 0"
	
	Global.level_xp_changed.connect(_on_level_xp_changed)
	Global.level_changed.connect(_on_level_changed)
	Global.level_xp_max_changed.connect(_on_level_xp_max_changed)
	
func _on_level_xp_changed(new_xp: float):
	value = new_xp
	pass

func _on_level_changed(new_level: int):
	level_label.text = "Level: " + str(new_level)
	pass
	
func _on_level_xp_max_changed(new_max_xp: float):
	max_value = new_max_xp
	pass
