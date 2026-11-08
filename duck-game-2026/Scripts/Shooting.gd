extends Area2D


var speed = 3000
var direction = 1
@export var scoreboard: Label
@export var player: Sprite2D
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _physics_process(delta: float) -> void:
	position+=transform.x*speed*delta*direction
	


func _on_area_entered(area: Area2D) -> void:
	print("Hi")
	if(area.is_in_group("enemies")):
		area.queue_free()
		queue_free()
		Global.score += 1


func _on_hawk_area_entered(area):
	pass # Replace with function body.
