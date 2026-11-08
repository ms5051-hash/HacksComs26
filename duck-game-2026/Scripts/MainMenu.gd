extends Node

enum MenuPanelState{
	Menu,
	Leaderboard,
	Credits
}

@export var title: Label
@export var leaderboard_panel: Panel
@export var leaderboard_places: Array[Label]
@export var credits_panel: Panel
@export_range(0,5) var leaderboard_duration: float = 1
@export var menu_buttons: Array[Button]
var current_menu_state: MenuPanelState = MenuPanelState.Menu
var currently_tweening: bool = false

func _ready() -> void:
	var scores = Leaderboard.get_top_scores()
	
	# fill leaderboard
	for i in range(leaderboard_places.size()):
		var leaderboard_text = str(i + 1) + ") "
		if(scores.size() > i):
			leaderboard_text = leaderboard_text + scores[i]
		else:
			leaderboard_text = leaderboard_text + str(0)
		leaderboard_places[i].text = leaderboard_text
	
	# set up title tween
	var tween = create_tween()
	
	# one side
	tween.tween_property(
		title,
		"rotation",
		deg_to_rad(10),
		1
	)
	
	tween.parallel().tween_property(
		title,
		"scale",
		Vector2(1,1) * 1.5,
		1
	)
	
	# middle
	tween.tween_property(
		title,
		"rotation",
		deg_to_rad(0),
		1
	)
	
	tween.parallel().tween_property(
		title,
		"scale",
		Vector2(1,1),
		1
	)
	
	# other side
	tween.tween_property(
		title,
		"rotation",
		deg_to_rad(-10),
		1
	)
	
	tween.parallel().tween_property(
		title,
		"scale",
		Vector2(1,1) * 1.5,
		1
	)
	
	# middle
	tween.tween_property(
		title,
		"rotation",
		deg_to_rad(0),
		1
	)
	
	tween.parallel().tween_property(
		title,
		"scale",
		Vector2(1,1),
		1
	)
	tween.set_loops()
	pass

# Tweens
func _tween_panel_up(panel: Panel) -> void:
	if currently_tweening: return
	
	_set_buttons(false)
	currently_tweening = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "position", Vector2(0,0), leaderboard_duration)
	
	await tween.finished
	_set_buttons(true)
	currently_tweening = false
	pass
	
func _tween_panel_down(panel: Panel) -> void:
	if currently_tweening: return
	
	_set_buttons(false)
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "position", Vector2(0,1080), leaderboard_duration)
	
	await tween.finished
	_set_buttons(true)
	currently_tweening = false
	pass
	
# Signal Functions
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	pass # Replace with function body.

func _on_leaderboard_button_pressed() -> void:
	# Open up the leaderboard!
	current_menu_state = MenuPanelState.Leaderboard
	_tween_panel_up(leaderboard_panel)
	
	pass # Replace with function body.

func _on_credits_button_pressed() -> void:
	current_menu_state = MenuPanelState.Credits
	_tween_panel_up(credits_panel)
	pass # Replace with function body.

func _on_exit_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.

# Extra helpers
func _set_buttons(enabled: bool) -> void:
	for b:Button in menu_buttons:
		if !enabled:
			b.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
		else:
			b.mouse_filter = Control.MouseFilter.MOUSE_FILTER_STOP
	pass

# Update
func _process(delta: float) -> void:
	
	if currently_tweening: return
	# Use finite state machine to determine what scene
	match(current_menu_state):
		MenuPanelState.Menu:
			if Input.is_action_just_pressed("escape"):
				get_tree().quit()
				
		MenuPanelState.Leaderboard:
			if Input.is_action_just_pressed("escape"):
				current_menu_state = MenuPanelState.Menu
				_tween_panel_down(leaderboard_panel)
				
		MenuPanelState.Credits:
			if Input.is_action_just_pressed("escape"):
				current_menu_state = MenuPanelState.Menu
				_tween_panel_down(credits_panel)
