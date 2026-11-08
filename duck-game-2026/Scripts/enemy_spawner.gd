extends Node2D

@export var enemy: PackedScene
@export var hawk: PackedScene
@export var snake: PackedScene
@export var spawnPoints: Array[Node2D]
@export var eps = .1
@export var hps = 0
@export var player: Area2D
var spawnFoxRate = 0
var spawnHawkRate = 0
var timeUntilFoxSpawn = 0
var timeUntilHawkSpawn = 0
var wave = 0
var waveActive = false
var waveEnemies: Array[Node2D] = []
var endOfSpawn = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.level_changed.connect(_on_level_change)
	spawnFoxRate = 1/eps
	if hps > 0:
		spawnHawkRate = 1/hps
	
	#Waves
	await get_tree().create_timer(1.0).timeout
	Spawn()
	await get_tree().create_timer(10.0).timeout
	Spawn()
	await get_tree().create_timer(10.0).timeout
	Spawn()
	await get_tree().create_timer(10.0).timeout
	Spawn()
	SpawnHawk()
	SpawnHawk()
	await get_tree().create_timer(8.0).timeout
	Spawn()
	await get_tree().create_timer(6.0).timeout
	Spawn()
	await get_tree().create_timer(6.0).timeout
	Spawn()
	await get_tree().create_timer(10.0).timeout
	Spawn()
	Spawn()
	SpawnHawk()
	await get_tree().create_timer(10.0).timeout
	SpawnSnake()
	await get_tree().create_timer(7.0).timeout
	SpawnHawk()
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
	Spawn()
	SpawnSnake()
	SpawnHawk()
	SpawnHawk()
	SpawnHawk()
	await get_tree().create_timer(5.0).timeout
	Spawn()
	await get_tree().create_timer(5.0).timeout
	Spawn()
	SpawnHawk()
	await get_tree().create_timer(5.0).timeout
	Spawn()
	await get_tree().create_timer(5.0).timeout
	Spawn()
	SpawnHawk()
	await get_tree().create_timer(5.0).timeout
	SpawnSnake()
	await get_tree().create_timer(5.0).timeout
	Spawn()
	SpawnHawk()
	await get_tree().create_timer(5.0).timeout
	Spawn()
	Spawn()
	Spawn()
	Spawn()
	SpawnHawk()
	await get_tree().create_timer(5.0).timeout
	SpawnHawk()
	Spawn()
	Spawn()
	await get_tree().create_timer(5.0).timeout
	SpawnHawk()
	SpawnHawk()
	SpawnHawk()
	Spawn()
	Spawn()
	Spawn()
	await get_tree().create_timer(5.0).timeout
	SpawnHawk()
	SpawnHawk()
	SpawnSnake()
	await get_tree().create_timer(5.0).timeout
	Spawn()
	Spawn()
	await get_tree().create_timer(5.0).timeout
	SpawnHawk()
	SpawnHawk()
	SpawnHawk()
	Spawn()
	Spawn()
	await get_tree().create_timer(5.0).timeout
	Spawn()
	SpawnHawk()
	Spawn()
	SpawnSnake()
	endOfSpawn = true
	
	
	

func _on_level_change(level: int) -> void:
	if hps == 0 and Global.level > 10:
		hps = 0.1
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if(timeUntilFoxSpawn>spawnFoxRate and endOfSpawn):
		
		Spawn()
		SpawnHawk()
		Spawn()
		Spawn()
		SpawnHawk()
		SpawnSnake()
		timeUntilFoxSpawn = 0
	else:
		timeUntilFoxSpawn+=delta
	
	if(spawnHawkRate != 0 and timeUntilHawkSpawn>spawnHawkRate):
		#SpawnHawk()
		timeUntilHawkSpawn = 0
	else:
		timeUntilHawkSpawn+=delta
		
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
