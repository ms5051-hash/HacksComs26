extends Sprite2D

@export var Bullet: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
func shoot():
	#instantiating player
	var b = Bullet.instantiate()
	
	#makes bullet a child of player
	owner.add_child(b)
	b.transform = global_transform
	
func _physics_process(delta: float) -> void:
	#get the mouse position, subtract that from the objects position
	#so we get a vector from the player to the mouse
	#convert to an angle, and finally convert to radians
	rotation = (get_global_mouse_position() - global_position).angle()
