extends Area2D


var speed = 3000
var direction = 1
@export var scoreboard: Label
@export var player: Sprite2D

var first

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	first = true
	
func _physics_process(delta: float) -> void:
	if(first):
		position+=transform.x*speed*delta*direction*6
		visible = true
		first = false
	position+=transform.x*speed*delta*direction
	


func _on_area_entered(area: Area2D) -> void:
	#print("Hi")
	if(area.is_in_group("enemies")):
		area.hp = area.hp - 1
		
		queue_free()
		if(area.hp <= 0):
			area.queue_free()
		
		Global.score += 1
		Global.level_xp += 1


func _on_hawk_area_entered(area):
	pass # Replace with function body.
