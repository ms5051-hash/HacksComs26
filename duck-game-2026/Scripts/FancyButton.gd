extends Button

var default_scale: Vector2 = Vector2.ONE
var hover_scale: Vector2 = Vector2(1.2, 1.2)
var tween_duration: float = 0.5


func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.set_trans(tween.TRANS_ELASTIC)
	tween.set_ease(tween.EASE_OUT)
	tween.tween_property(self, "scale", hover_scale,tween_duration)
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.set_trans(tween.TRANS_BACK)
	tween.set_ease(tween.EASE_OUT)
	tween.tween_property(self, "scale", default_scale, tween_duration)
	pass # Replace with function body.
