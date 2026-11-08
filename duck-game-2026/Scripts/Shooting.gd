extends Area2D


var speed = 3000
var direction = 1
@export var scoreboard: Label
@export var player: Sprite2D

var first

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	$"..".play_sfx(preload("res://Assets/Sounds/Pop.wav"))
	first = true
	
func _physics_process(delta: float) -> void:
	if(first):
		position+=transform.x*speed*delta*direction*6
		visible = true
		first = false
	position+=transform.x*speed*delta*direction
	


func _on_area_entered(area: Area2D) -> void:
	if($BulletSprite2D.texture == preload("res://Assets/EggSplat.png")):
		return
	
	#print("Hi")
	if(area.is_in_group("enemies")):
		area.hp = area.hp - Global.egg_damage
		$BulletSprite2D.texture = preload("res://Assets/EggSplat.png")
		if($BulletSprite2D.rotation_degrees == -90):
			if(position.x > 960):
				$BulletSprite2D.rotation_degrees = 0
			else:
				$BulletSprite2D.rotation_degrees = 180
		$"..".play_sfx(preload("res://Assets/Sounds/EggCrackWithGoosh.wav"))
		await get_tree().create_timer(.05).timeout
		speed = 0
		if(area != null):
			reparent(area, true)
		await get_tree().create_timer(1.0).timeout
		queue_free()


func _on_hawk_area_entered(area):
	pass # Replace with function body.
