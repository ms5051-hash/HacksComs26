extends Sprite2D

@export var Bullet: PackedScene
var offsetValue;
var on_cool_down: bool = false
var holding_down_left: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if on_cool_down: return
	
	if Input.is_action_pressed("shoot"):
		print("Holding LEFT")
		holding_down_left = true
		shoot()
	else:
		holding_down_left = false
		
func shoot():
	if on_cool_down: return
	
	#instantiating player
	var b = Bullet.instantiate()
	var offsetX = Transform2D()
	var bSprite = b.get_node("BulletSprite2D")
	offsetX.origin = Vector2(offsetValue, 0)
	
	#makes bullet a child of player
	owner.add_child(b)
	if(flip_h==true):
		b.direction = -1
	else:
		b.direction = 1
	bSprite.flip_v = flip_h
	b.transform = global_transform*offsetX
	
	on_cool_down = true
	await get_tree().create_timer(1/Global.egg_fire_rate).timeout
	on_cool_down = false
	
func _physics_process(delta: float) -> void:
	#get the mouse position, subtract that from the objects position
	#so we get a vector from the player to the mouse
	#convert to an angle, and finally convert to radians
	if (get_global_mouse_position().x>global_position.x):
		flip_h = false
		rotation = (get_global_mouse_position()-global_position).angle()
		offsetValue = 10
	else:
		flip_h = true
		rotation = (-(get_global_mouse_position()-global_position)).angle()
		offsetValue = -10


func _on_timer_timeout() -> void:
	# handle regen here
	# happens every second
	Global.nest_hp += Global.regen
	pass # Replace with function body.
