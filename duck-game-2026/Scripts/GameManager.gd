extends Node

@export var audioPlayer: AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.reset_everything()
	audioPlayer.stream = load("res://Assets/Sounds/Quack1.wav")
	audioPlayer.play()
	pass # Replace with function body.

func play_sfx(stream: AudioStream) -> void:
	var p = AudioStreamPlayer.new()
	p.stream = stream
	p.autoplay = true
	p.finished.connect(p.queue_free)
	add_child.call_deferred(p)
