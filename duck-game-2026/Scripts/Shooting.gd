extends Area2D


var speed = 800

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _physics_process(delta: float) -> void:
	position+=transform.x*speed*delta


func _on_enemy_area_entered(area: Area2D) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	print("Hi")
	if(area.is_in_group("enemies")):
		area.queue_free()
		queue_free()
