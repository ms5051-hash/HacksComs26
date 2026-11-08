extends Area2D
@export var player: Area2D
var speed = 720
var hp = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.play("Fox")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var y = position.y;
	position+=(player.global_position-global_position).normalized()*speed*delta
	position.y = y;
	
