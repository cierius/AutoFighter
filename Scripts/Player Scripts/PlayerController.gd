extends KinematicBody2D

signal switch_class()
signal get_class_stats()

# Movement variables
export var speed: float = 150
export var speed_mod: float = 1.0

# For passing the framerate delta between functions without hassle
var global_delta: float

#func _ready():
	#var stats = $ClassManager.call("get_class_stats")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_delta = delta
	
	keyboard_input()


func keyboard_input():
	if(Input.is_action_pressed("up")):
		move(Vector2.UP)
	if(Input.is_action_pressed("down")):
		move(Vector2.DOWN)
	if(Input.is_action_pressed("left")):
		move(Vector2.LEFT)
	if(Input.is_action_pressed("right")):
		move(Vector2.RIGHT)
	
	if(Input.is_action_just_pressed("space")):
		emit_signal("switch_class")
		
		var new_speed = $ClassManager.call("_get_class_stats")
		speed = new_speed["speed"]
		speed_mod = new_speed["speed_mod"]


func move(dir: Vector2):
	position += move_and_slide(dir * speed * global_delta * speed_mod)
