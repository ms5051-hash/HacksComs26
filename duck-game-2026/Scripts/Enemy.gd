extends Area2D
@export var player: Area2D
var speed = 720
var hp = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.play("Fox")
	area_entered.connect(_on_area_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var y = position.y;
	position+=(player.global_position-global_position).normalized()*speed*delta
	position.y = y;
	if(position.x < 960):
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
		
		
func _on_area_entered(area: Area2D) -> void:
	if(area.name=="PlayerArea2D"):
		print("Hi")
		speed = 0
