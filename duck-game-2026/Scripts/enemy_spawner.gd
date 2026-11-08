extends Node2D

@export var enemy: PackedScene
@export var hawk: PackedScene
@export var spawnPoints: Array[Node2D]
@export var eps = 1
@export var player: Area2D
var spawnRate
var timeUntilSpawn = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnRate = 5/eps


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(timeUntilSpawn>spawnRate):
		Spawn()
		SpawnHawk()
		timeUntilSpawn = 0
	else:
		timeUntilSpawn+=delta
		
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
