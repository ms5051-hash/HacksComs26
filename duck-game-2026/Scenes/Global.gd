extends Node

signal sticks_changed(amount: int)
signal nest_hp_changed(current: float,maximum: float)
signal wave_changed(wave: int)
signal nest_destroyed

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
		

#var predator_stats: Dictionary = {
	#PredatorType.FOX:  {"hp": 30.0, "speed": 110.0, "nest_damage": 3.0, "sticks": 2, "score": 10, "flying": false},
	#PredatorType.HAWK: {"hp": 20.0, "speed": 170.0, "nest_damage": 2.0, "sticks": 3, "score": 15, "flying": true},
	#PredatorType.SNAKE: {"hp": 80.0, "speed": 50.0, "nest_damage": 5.0, "sticks": 5, "score": 25, "flying": false},
#}

#func get_predator_stat(type: int, stat: String):
	#return predator_stats[type][stat]
	
#func is_flying(type: int) -> bool:
	
#func predator_killed(type: int) -> void:
	
#func predator_hit_nest(type: int) -> void:
	




#Nest
var nest_max_hp: float = 100.0
var nest_hp: float = 100.0:
		set(value):
			nest_max_hp = clampf(value, 0.0, nest_max_hp)
			nest_hp_changed.emit(nest_hp, nest_max_hp)
			if nest_hp <= 0.0:
				nest_destroyed.emit()
				
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
		
var score: int = 0

#Weapon
var weapon_damage: int = 10.0
var weapon_fire_rate: int = 3.0

#Helpers
func add_sticks(amount: int) -> void:
	sticks += amount
	
func spend_tickets(amount: int) -> bool:
	if sticks >= amount:
		sticks -= amount
		return true
	return false
	
func damage_nest(amount: float) -> void:
	nest_hp -= amount
	
	
	
	
# Function that when you lose brings you to the GameOver Scene
# Func _ready() -> void
#     Globals.nest_destoryed.connect(on_nest_destroyed)
# func on_nest_destroyed() -> void:
#     get_tree().change_scene_to_file("res://GameOver.tscn")
	

		
