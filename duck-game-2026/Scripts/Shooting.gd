extends Area2D


var speed = 3000
var direction = 1
@export var scoreboard: Label
@export var player: Sprite2D
var bullet_prefab: PackedScene
const BULLET_PREFAB = preload("res://Scenes/bullet_area_2d.tscn")
var first
var damagePercent = 1

# This number represents the amount of eggs that spawn and explode around it
var is_explosive: bool = true

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	$"..".play_sfx(preload("res://Assets/Sounds/Pop.wav"))
	first = true
	await get_tree().create_timer(15.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	if(first):
		position+=transform.x*speed*delta*direction*6
		visible = true
		first = false
	position+=transform.x*speed*delta*direction
	


func _on_area_entered(area: Area2D) -> void:
	
	
			
	if($BulletSprite2D.texture == preload("res://Assets/EggSplat.png")):
		return
	
	if(area.is_in_group("enemies")):
		area.hp = area.hp - (Global.egg_damage * damagePercent)
		$BulletSprite2D.texture = preload("res://Assets/EggSplat.png")
		if($BulletSprite2D.rotation_degrees == -90):
			if(position.x > 960):
				$BulletSprite2D.rotation_degrees = 0
			else:
				$BulletSprite2D.rotation_degrees = 180
		$"..".play_sfx(preload("res://Assets/Sounds/EggCrackWithGoosh.wav"))
		
		if (Global.split_shot>1 and is_explosive):
			# Spawn the amount evenly
			var frac_deg: float = 360/Global.split_shot
			
			for i in range(Global.split_shot):
				var bullet_copy = BULLET_PREFAB.instantiate()
				bullet_copy.damagePercent = .5;
				bullet_copy.scale = Vector2(0.1, 0.1)
				bullet_copy.is_explosive = false
				bullet_copy.rotation = deg_to_rad(i * frac_deg)
				bullet_copy.global_position = global_position
				get_tree().current_scene.call_deferred("add_child", bullet_copy)
				
		await get_tree().create_timer(.05).timeout
		speed = 0
		if(area != null):
			reparent(area, true)
		await get_tree().create_timer(1.0).timeout
		queue_free()


func _on_hawk_area_entered(area):
	pass # Replace with function body.


func _on_snake_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
