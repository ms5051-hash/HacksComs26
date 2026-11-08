extends Node2D

enum MenuPanelState{
	Menu,
	Leaderboard,
	Credits
}

@export var canvas: CanvasLayer
@export var title: Label
@export var leaderboard_panel: Panel
@export var credits_panel: Panel
@export_range(0,5) var leaderboard_duration: float = 1
@export var menu_buttons: Array[Button]
var current_menu_state: MenuPanelState = MenuPanelState.Menu
var currently_tweening: bool = false
@export_range(3,10) var amount_of_scores: int = 3
@export var score_label_prefab: PackedScene
@export var egg_prefab: PackedScene
@export var splat_duration: float = 0.3

func _ready() -> void:
	
	# get scores
	var scores = Leaderboard.get_top_scores(amount_of_scores)
	var vbox = leaderboard_panel.get_node("VBox")
	
	# fill the vbox with labels
	for i in range(amount_of_scores):
		var leaderboard_text = str(i + 1) + ") "
		if(scores.size() > i):
			leaderboard_text = leaderboard_text + scores[i]
		else:
			leaderboard_text = leaderboard_text + str(0)
		var score = score_label_prefab.instantiate()
		score.text = leaderboard_text
		vbox.add_child(score)
		
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
	
	# throw egg here
	await _tween_egg_splat()
	
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
	
func _tween_egg_splat() -> void:
	# make an egg
	var egg = egg_prefab.instantiate()
	egg.scale = Vector2(5,5)
	
	# get start and end positions
	egg.position = Vector2(randf_range(0, 1920),1100)
	canvas.add_child(egg)
	
	var end_position: Vector2 = get_global_mouse_position()
	
	# make the tween
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(egg, "position", end_position, splat_duration)
	tween.parallel().tween_property(egg, "scale", Vector2(1,1), splat_duration)
	await tween.finished
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
