extends Node2D

@export var enemy: PackedScene
@export var hawk: PackedScene
@export var snake: PackedScene
@export var spawnPoints: Array[Node2D]
@export var hps = 0
@export var player: Area2D
var spawnFoxRate = 3
var spawnHawkRate = 5
var spawnSnakeRate = 10
var timeUntilFoxSpawn = 0
var timeUntilHawkSpawn = 0
var timeUntilSnakeSpawn = 0
var wave = 0
var waveActive = false
var waveEnemies: Array[Node2D] = []
var endOfSpawn = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.level_changed.connect(_on_level_change)
	endOfSpawn = false
	Global.predator_stats[Global.PredatorType.FOX]["hp"] = 10.0
	Global.predator_stats[Global.PredatorType.FOX]["score"] = 1
	Global.predator_stats[Global.PredatorType.HAWK]["hp"] = 15.0
	Global.predator_stats[Global.PredatorType.HAWK]["score"] = 2
	Global.predator_stats[Global.PredatorType.SNAKE]["hp"] = 100.0
	Global.predator_stats[Global.PredatorType.SNAKE]["score"] = 5
	#Waves
	print("Wave 1")
	await get_tree().create_timer(1.0).timeout
	Spawn()
	await get_tree().create_timer(10.0).timeout
	Spawn()
	await get_tree().create_timer(10.0).timeout
	Spawn()
	await get_tree().create_timer(10.0).timeout
	Spawn()
	await get_tree().create_timer(8.0).timeout
	Spawn()
	await get_tree().create_timer(6.0).timeout
	Spawn()
	Spawn()
	await get_tree().create_timer(6.0).timeout
	Spawn()
	await get_tree().create_timer(10.0).timeout
	Spawn()
	SpawnHawk()
	await get_tree().create_timer(10.0).timeout
	
	print("Wave 2")
	Spawn()
	await get_tree().create_timer(6.0).timeout
	Spawn()
	await get_tree().create_timer(5.0).timeout
	Spawn()
	SpawnHawk()
	await get_tree().create_timer(5.0).timeout
	Spawn()
	await get_tree().create_timer(5.0).timeout
	Spawn()
	SpawnHawk()
	await get_tree().create_timer(10.0).timeout
	Spawn()
	SpawnHawk()
	SpawnHawk()
	await get_tree().create_timer(8.0).timeout
	
	print("Wave 3")
	Spawn()
	Spawn()
	await get_tree().create_timer(5.0).timeout
	Spawn()
	SpawnHawk()
	await get_tree().create_timer(5.0).timeout
	Spawn()
	await get_tree().create_timer(8.0).timeout
	Spawn()
	Spawn()
	await get_tree().create_timer(5.0).timeout
	Spawn()
	await get_tree().create_timer(5.0).timeout
	Spawn()
	SpawnHawk()
	await get_tree().create_timer(9.0).timeout
	Spawn()
	SpawnHawk()
	SpawnSnake()
	await get_tree().create_timer(8.0).timeout
	
	print("Wave 4")
	Spawn()
	Spawn()
	await get_tree().create_timer(5.0).timeout
	Spawn()
	Spawn()
	SpawnHawk()
	await get_tree().create_timer(5.0).timeout
	SpawnHawk()
	SpawnHawk()
	await get_tree().create_timer(6.0).timeout
	Spawn()
	Spawn()
	await get_tree().create_timer(6.0).timeout
	Spawn()
	Spawn()
	SpawnHawk()
	SpawnHawk()
	await get_tree().create_timer(6.0).timeout
	Spawn()
	Spawn()
	SpawnHawk()
	SpawnSnake()
	await get_tree().create_timer(9.0).timeout
	print("Endless Waves")
	endOfSpawn = true
	
	
	

func _on_level_change(level: int) -> void:
	if hps == 0 and Global.level > 10:
		hps = 0.1
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(endOfSpawn):
		Global.level_max_multiplier = 1.5
		if(timeUntilFoxSpawn>spawnFoxRate):
			Spawn()
			timeUntilFoxSpawn = 0
			if(spawnFoxRate > .1):
				spawnFoxRate *= .99
			Global.predator_stats[Global.PredatorType.FOX]["hp"] += .075
			Global.predator_stats[Global.PredatorType.FOX]["score"] += Global.predator_stats[Global.PredatorType.SNAKE]["hp"]/400
		else:
			timeUntilFoxSpawn+=delta
		if(timeUntilHawkSpawn>spawnHawkRate):
			SpawnHawk()
			timeUntilHawkSpawn = 0
			if(spawnHawkRate > .1):
				spawnHawkRate *= .99
			Global.predator_stats[Global.PredatorType.HAWK]["hp"] += .15
			Global.predator_stats[Global.PredatorType.HAWK]["score"] += Global.predator_stats[Global.PredatorType.SNAKE]["hp"]/200
		else:
			timeUntilHawkSpawn+=delta
		if(timeUntilSnakeSpawn>spawnSnakeRate):
			SpawnSnake()
			timeUntilSnakeSpawn = 0
			if(spawnSnakeRate > .1):
				spawnSnakeRate *= .975
			Global.predator_stats[Global.PredatorType.SNAKE]["hp"] += 1
			Global.predator_stats[Global.PredatorType.SNAKE]["score"] += Global.predator_stats[Global.PredatorType.SNAKE]["hp"]/60
		else:
			timeUntilSnakeSpawn+=delta
	
func Spawn():
	var rng = RandomNumberGenerator	.new()
	var location = spawnPoints[rng.randi()%2].global_position
	var enemySpawn = enemy.instantiate()
	enemySpawn.player = player
	enemySpawn.add_to_group("enemies")
	enemySpawn.global_position = location
	var yValue = enemySpawn.global_position.y
	yValue+=rng.randf_range(-20, 20)
	enemySpawn.global_position.y = yValue
	enemySpawn.z_index+=yValue/10
	add_child(enemySpawn)
	
	$"..".play_sfx(preload("res://Assets/Sounds/FoxMove.wav"))

func SpawnHawk():
	var rng = RandomNumberGenerator	.new()
	var location = spawnPoints[rng.randi()%2 + 2].global_position
	var enemySpawn = hawk.instantiate()
	enemySpawn.player = player	
	enemySpawn.add_to_group("enemies")
	enemySpawn.global_position = location
	var yValue = enemySpawn.global_position.y
	yValue+=rng.randf_range(-200, 200)
	enemySpawn.global_position.y = yValue
	enemySpawn.z_index+=yValue/10
	add_child(enemySpawn)
	
	$"..".play_sfx(preload("res://Assets/Sounds/CawCaw.wav"))
	
func SpawnSnake():
	var rng = RandomNumberGenerator	.new()
	var location = spawnPoints[rng.randi()%2].global_position
	var enemySpawn = snake.instantiate()
	enemySpawn.player = player
	enemySpawn.add_to_group("enemies")
	enemySpawn.global_position = location
	var yValue = enemySpawn.global_position.y
	yValue+=rng.randf_range(-20 -250, 20 -250)
	enemySpawn.global_position.y = yValue
	enemySpawn.z_index+=yValue/10
	add_child(enemySpawn)
	
	$"..".play_sfx(preload("res://Assets/Sounds/FoxMove.wav"))
