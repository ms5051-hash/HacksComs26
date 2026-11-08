extends Node

signal sticks_changed(amount: int)
signal nest_hp_changed(current: float,maximum: float)
signal wave_changed(wave: int)
signal nest_destroyed
signal score_changed(new_score: int)

#Enum
enum GameState {MENU, PLAYING, PAUSED, SHOP, GAME_OVER, VICTORY}
enum PredatorType { FOX, HAWK, RACCOON, SNAKE, BEAR_BOSS}
enum WeaponType { BUTT_CANNON, SPREAD_SHOT }

signal game_state_changed(new_state: int)

#Game State
var game_state: int = GameState.MENU:
	set(value):
		game_state = value
		game_state_changed.emit(game_state)
		
func start_game() -> void:
	nest_hp = nest_max_hp
	sticks = 0
	score = 0
	current_wave = 0
	game_state = GameState.PLAYING
	get_tree().paused = false
	
func toggle_pause() -> void:
	if game_state == GameState.PLAYING:
		game_state = GameState.PAUSED
		get_tree().paused = true
	elif game_state == GameState.PAUSED:
		game_state = GameState.PLAYING
		get_tree().paused = false
		
func end_game() -> void:
	game_state = GameState.GAME_OVER
	
func is_playing() -> bool:
	return game_state == GameState.PLAYING
		

#Predator stats and functions during the game
var predator_stats: Dictionary = {
	PredatorType.FOX:  {"hp": 30.0, "speed": 200, "nest_damage": 3.0, "sticks": 2, "score": 10, "flying": false},
	PredatorType.HAWK: {"hp": 20.0, "speed": 70.0, "nest_damage": 2.0, "sticks": 3, "score": 15, "flying": true},
	PredatorType.SNAKE: {"hp": 80.0, "speed": 35.0, "nest_damage": 5.0, "sticks": 5, "score": 25, "flying": false},
}

func get_predator_stat(type: int, stat: String):
	return predator_stats[type][stat]
	
func is_flying(type: int) -> bool:
	return predator_stats[type]["flying"]
	
func predator_killed(type: int) -> void:
	add_sticks(predator_stats[type]["sticks"])
	score += predator_stats[type]["score"]
	
func predator_hit_nest(type: int) -> void:
	damage_nest(predator_stats[type]["nest_damage"])
	
#Nest
var nest_max_hp: float = 100.0
var nest_hp: float = 100.0
	
				
#Currency
var sticks: int = 0:
	set(value):
		sticks = maxi(value, 0)
		sticks_changed.emit(sticks)

#Waves and Score
var current_wave: int = 0:
	set(value):
		current_wave = value
		wave_changed.emit(current_wave)
		
var score: int = 0:
	set(value):
		score = value
		score_changed.emit(score)

# Egg Damage
var egg_damage: float = 10.0
var enemy_base_hp: float = 100.0
var sticks_per_kill: int = 2
var score_per_kill: int = 10

# When enemy dies
func enemy_killed() -> void:
	add_sticks(sticks_per_kill)
	score += score_per_kill

#Helpers
func add_sticks(amount: int) -> void:
	sticks += amount
	
func spend_tickets(amount: int) -> bool:
	if sticks >= amount:
		sticks -= amount
		return true
	return false
	
func damage_nest(amount: float) -> void:
	nest_hp = clampf(nest_hp - amount, 0.0, nest_max_hp)
	print("nest_hp changing from ", nest_hp)
	nest_hp_changed.emit(nest_hp, nest_max_hp)
	if nest_hp <= 0.0:
		nest_destroyed.emit()
	
	
# Function that when you lose brings you to the GameOver Scene
# Func _ready() -> void
#     Globals.nest_destoryed.connect(on_nest_destroyed)
# func on_nest_destroyed() -> void:
#     get_tree().change_scene_to_file("res://GameOver.tscn")
	

		
