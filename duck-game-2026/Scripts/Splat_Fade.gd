extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# fade the splat
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "modulate:a", 0, 20)
	await tween.finished
	queue_free()
	pass # Replace with function body.
