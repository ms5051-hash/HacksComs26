extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "+" + str(Global.regen)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", 2, 2)
	
	tween.parallel().tween_property(self, "modulate:a", 0.0, 1.0)
	
	await tween.finished
	
	self.queue_free()
	
	pass # Replace with function body.
