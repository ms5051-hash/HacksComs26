extends Area2D

@export var player: Area2D
var speed: float
var predator_type: int = Global.PredatorType.HAWK
@export var attack_cooldown: float = 1.0
@export var time_since_attack: float = 0.0

var maxHP = 10.0
var hp = maxHP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = Global.get_predator_stat(predator_type, "speed")
	$Sprite2D.play("Hawk")
	area_entered.connect(_on_area_entered)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ProgressBar.max_value = maxHP
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(int(hp))
	
	position+=(player.global_position-global_position).normalized()*speed*delta
	
	if(position.x < 960):
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
	if (speed == 0):
		time_since_attack += delta
		if time_since_attack >= attack_cooldown:
			time_since_attack = 0.0
			Global.predator_hit_nest(predator_type)
			print(Global.nest_hp)
		
		
func _on_area_entered(area: Area2D) -> void:
	if(area.name=="PlayerArea2D"):
		speed = 0
