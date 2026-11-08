extends Node2D

@export var enemy: PackedScene
@export var hawk: PackedScene
@export var spawnPoints: Array[Node2D]
@export var eps = .1
@export var hps = 0
@export var player: Area2D
var spawnFoxRate = 0
var spawnHawkRate = 0
var timeUntilFoxSpawn = 0
var timeUntilHawkSpawn = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.level_changed.connect(_on_level_change)
	spawnFoxRate = 1/eps
	if hps > 0:
		spawnHawkRate = 1/hps

func _on_level_change(level: int) -> void:
	if hps == 0 and Global.level > 10:
		hps = 0.1
	eps *= 1.15
	hps *= 1.15
	spawnFoxRate = 1/eps
	if hps != 0:
		spawnHawkRate = 1/hps
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if(timeUntilFoxSpawn>spawnFoxRate):
		Spawn()
		timeUntilFoxSpawn = 0
	else:
		timeUntilFoxSpawn+=delta
	
	if(spawnHawkRate != 0 and timeUntilHawkSpawn>spawnHawkRate):
		SpawnHawk()
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
