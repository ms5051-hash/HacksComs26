extends Node

enum Upgrades{
	MaxHealth,
	FireRate,
	Damage,
	Regen
}

var upgrade_snippets = {
	Upgrades.MaxHealth: "Increase Max Health",
	Upgrades.FireRate: "Increase Fire Rate",
	Upgrades.Damage: "Increase Egg Damage",
	Upgrades.Regen: "Increase Regen"
}

@export var array_of_upgrade_buttons: Array[Button]
var num_of_times_upgraded: int = 0
var is_tweening: bool = false
var button_upgrade_array: Array[Upgrades]
var is_choosing: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.level_changed.connect(_on_level_changed)
	button_upgrade_array.resize(3)
	pass # Replace with function body.

func _on_level_changed(new_level) -> void:
	# for now just try tweening it down here
	if is_choosing or new_level == 0: return
	
	await _tween_down()
	pass
	
func _make_buttons_interactable(interactable: bool) -> void:
	for b in array_of_upgrade_buttons:
		if interactable:
			b.mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pass
	
func _tween_down() -> void:
	is_choosing = true
	# Generate random upgrades
	var number_array: Array[int]
	number_array.resize(Upgrades.size())
	for i in range(Upgrades.size()):
		number_array[i] = i
		
	number_array.shuffle()
	
	# get the first three and those are the buttons
	button_upgrade_array[0] = number_array[0]
	button_upgrade_array[1] = number_array[1]
	button_upgrade_array[2] = number_array[2]
	
	# Loop through the array of buttons and give them their message
	for i in array_of_upgrade_buttons.size():
		array_of_upgrade_buttons[i].text = upgrade_snippets[number_array[i]]
	
	is_tweening = true
	_make_buttons_interactable(false)
	# Make 3 tweens, one for each board
	var tween_one = create_tween()
	tween_one.set_trans(Tween.TRANS_BACK)
	tween_one.set_ease(Tween.EASE_OUT)
	tween_one.tween_property(array_of_upgrade_buttons[0],
	"position:y", 60, 1)
	
	var tween_two = create_tween()
	tween_two.set_trans(Tween.TRANS_BACK)
	tween_two.set_ease(Tween.EASE_OUT)
	tween_two.tween_property(array_of_upgrade_buttons[1],
	"position:y", 320, 1)
	
	var tween_three = create_tween()
	tween_three.set_trans(Tween.TRANS_BACK)
	tween_three.set_ease(Tween.EASE_OUT)
	tween_three.tween_property(array_of_upgrade_buttons[2],
	"position:y", 580, 1)
	await tween_three.finished
	is_tweening = false
	_make_buttons_interactable(true)
	pass
	
func _tween_up() -> void:
	num_of_times_upgraded += 1
	is_tweening = true
	_make_buttons_interactable(false)
	# Make 3 tweens, one for each board
	var tween_three = create_tween()
	tween_three.set_trans(Tween.TRANS_BACK)
	tween_three.set_ease(Tween.EASE_OUT)
	tween_three.tween_property(array_of_upgrade_buttons[2],
	"position:y", -216, 1)
	
	var tween_two = create_tween()
	tween_two.set_trans(Tween.TRANS_BACK)
	tween_two.set_ease(Tween.EASE_OUT)
	tween_two.tween_property(array_of_upgrade_buttons[1],
	"position:y", -216, 1)
	
	var tween_one = create_tween()
	tween_one.set_trans(Tween.TRANS_BACK)
	tween_one.set_ease(Tween.EASE_OUT)
	tween_one.tween_property(array_of_upgrade_buttons[0],
	"position:y", -216, 1)
	
	await tween_three.finished
	is_tweening = false
	is_choosing = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _determine_upgrade(button_num: int) -> void:
	match button_upgrade_array[button_num]:
		Upgrades.FireRate:
			Global.egg_fire_rate *= Global.fire_rate_multiplier
		Upgrades.MaxHealth:
			Global.nest_max_hp *= Global.nest_max_hp_multiplier
		Upgrades.Damage:
			Global.egg_damage *= Global.egg_damage_multiplier
		Upgrades.Regen:
			Global.regen *= Global.regen_multiplier
	pass

func _on_random_one_pressed() -> void:
	# Upgrade here
	_determine_upgrade(0)
	await _tween_up()
	if num_of_times_upgraded < Global.level:
		_tween_down()
	pass # Replace with function body.


func _on_random_two_pressed() -> void:
	
	_determine_upgrade(1)
	await _tween_up()
	if num_of_times_upgraded < Global.level:
		_tween_down()
	pass # Replace with function body.


func _on_random_three_pressed() -> void:
	
	_determine_upgrade(2)
	await _tween_up()
	if num_of_times_upgraded < Global.level:
		_tween_down()
	pass # Replace with function body.
