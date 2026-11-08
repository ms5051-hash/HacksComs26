extends Area2D

@export var player: Area2D
var speed: float
var predator_type: int = Global.PredatorType.HAWK
@export var attack_cooldown: float = 1.0
@export var time_since_attack: float = 0.0

#Movement
enum State { ENTER, PATROL, DIVE }
var state = State.ENTER
@export var patrol_speed = 200.0
@export var patrol_range = 400.0
@export var sweeps_before_dive = randi_range(2, 6)
var patrol_dir = 1
var patrol_start_x = 960
var sweeps_done = 0


var maxHP = 10.0
var hp = maxHP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = Global.get_predator_stat(predator_type, "speed")
	$Sprite2D.play("Hawk")
	area_entered.connect(_on_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(hp <= 0):
		Global.score += Global.predator_stats[predator_type]["score"]
		Global.level_xp += Global.predator_stats[predator_type]["score"]
		queue_free()
	
	$ProgressBar.max_value = maxHP
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(int(hp))
	
	match state:
		State.ENTER:
			_enter(delta)
		State.PATROL:
			_patrol(delta)
		State.DIVE:
			_dive(delta)
	
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
		

func _patrol(delta: float) -> void:
	global_position.x += patrol_dir * patrol_speed * delta

	# Turn around at either end of the patrol range
	if abs(global_position.x - patrol_start_x) >= patrol_range:
		patrol_dir *= -1
		sweeps_done += 1

		if sweeps_done >= sweeps_before_dive:
			state = State.DIVE

func _dive(delta: float) -> void:
	global_position += (player.global_position - global_position).normalized() * speed * delta

func _enter(delta: float) -> void:
	var abovePos = player.global_position
	abovePos.y -= 400
	global_position += (abovePos - global_position).normalized() * speed * delta
	if(global_position.x < abovePos.x + 10 && global_position.x > abovePos.x - 10):
		state = State.PATROL
