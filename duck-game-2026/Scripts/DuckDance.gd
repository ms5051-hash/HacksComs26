extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation", deg_to_rad(10),1)
	
	tween.tween_property(self, "rotation", deg_to_rad(-10),1)
	
	tween.set_loops()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
