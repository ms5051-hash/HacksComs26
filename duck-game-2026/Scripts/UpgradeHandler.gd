extends Node
@export var array_of_upgrade_buttons: Array[Button]
var num_of_level_ups: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.level_changed.connect(_on_level_changed)
	pass # Replace with function body.

func _on_level_changed(new_level) -> void:
	# for now just try tweening it down here
	if new_level == 0: return
	_tween_down()
	pass
	
func _tween_down() -> void:
	# Make 3 tweens, one for each board
	var tween_one = create_tween()
	tween_one.set_trans(Tween.TRANS_BACK)
	tween_one.set_ease(Tween.EASE_OUT)
	tween_one.tween_property(array_of_upgrade_buttons[0],
	"position:y", 60, 1)
	
	var tween_two = create_tween()
	tween_two.set_trans(Tween.TRANS_BACK)
	tween_two.set_ease(Tween.EASE_OUT)
	tween_two.tween_property(array_of_upgrade_buttons[1],
	"position:y", 320, 1)
	
	var tween_three = create_tween()
	tween_three.set_trans(Tween.TRANS_BACK)
	tween_three.set_ease(Tween.EASE_OUT)
	tween_three.tween_property(array_of_upgrade_buttons[2],
	"position:y", 580, 1)
	
	pass
	
func _tween_up() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
