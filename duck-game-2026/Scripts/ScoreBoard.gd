extends Label

@export var score_label: Label

var displayed_score: int = 0

func _ready() -> void:
	Global.score_changed.connect(_on_score_changed)
	_update_label()

func _on_score_changed(new_score: int) -> void:
	# count up to the new score
	var tween := create_tween()
	tween.tween_property(self, "displayed_score", int(new_score), 0.3)
	tween.parallel().tween_callback(_pop)
	displayed_score = Global.score
	_update_label()
	
func _update_label() -> void:
	score_label.text = str(displayed_score)

# small bounce each time you score
func _pop() -> void:
	score_label.pivot_offset = score_label.size / 2.0
	var t := create_tween()
	t.tween_property(score_label, "scale", Vector2(1.3, 1.3), 0.08)
	t.tween_property(score_label, "scale", Vector2.ONE, 0.12)

	
