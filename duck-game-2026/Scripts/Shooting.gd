extends Area2D


var speed = 800

func _physics_process(delta: float) -> void:
	position+=transform.x*speed*delta





func _on_enemy_area_entered(area: Area2D) -> void:
	print("Hi")
	if(area.is_in_group("enemies")):
		area.queue_free()
	queue_free()
