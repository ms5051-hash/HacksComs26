extends Node

const level_max_multiplier: float = 1.1
signal sticks_changed(amount: int)
signal nest_hp_changed(current: float,maximum: float)
signal wave_changed(wave: int)
signal nest_destroyed
signal score_changed(new_score: int)
signal level_xp_changed(new_level_max: int)
signal level_xp_max_changed(new_level_max: int)
signal level_changed(new_level: int)


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
	
# FIELD START VALUES HERE
const start_nest_max_hp: float = 100.0
const start_level_xp_max: float = 10.0
const start_egg_damage: float = 10.0
const start_enemy_base_hp: float = 100.0
const start_sticks_per_kill: int = 2
const start_score_per_kill: int = 10

# FIELDS HERE

#Nest
var nest_max_hp: float = start_nest_max_hp
var nest_hp: float = start_nest_max_hp
	
				
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

# this is the total XP
var score: float = 0:
	set(value):
		score = value
		score_changed.emit(score)

# current level xp in the bar
var level_xp: float = 0:
	set(value):
		# if its ever over the max,
		# then simply increment level and 
		# set new max
		# set new current level
		if value >= level_xp_max:
			level_xp = level_xp - level_xp_max
			level_xp_max = level_xp_max * level_max_multiplier
			level += 1
		else:
			level_xp = value
		level_xp_changed.emit(level_xp)

# current level
var level: int = 0:
	set(value):
		level = value
		level_changed.emit(level)

# current max xp in the bar
var level_xp_max: float = start_level_xp_max:
	set(value):
		level_xp_max = value
		level_xp_max_changed.emit(level_xp_max)

# Egg Damage
var egg_damage: float = start_egg_damage
var enemy_base_hp: float = start_enemy_base_hp
var sticks_per_kill: int = start_sticks_per_kill
var score_per_kill: int = start_score_per_kill

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
			
func reset_everything() -> void:
	nest_max_hp = start_nest_max_hp
	nest_hp = start_nest_max_hp
	level_xp_max = start_level_xp_max
	egg_damage = start_egg_damage
	enemy_base_hp = start_enemy_base_hp
	sticks_per_kill = start_sticks_per_kill
	score_per_kill = start_score_per_kill
	sticks = 0
	current_wave = 0
	score = 0
	level_xp = 0
	level = 0
	pass
# Function that when you lose brings you to the GameOver Scene
# Func _ready() -> void
#     Globals.nest_destoryed.connect(on_nest_destroyed)
#func on_nest_destroyed() -> void:
#     get_tree().change_scene_to_file("res://GameOver.tscn")
	

		
