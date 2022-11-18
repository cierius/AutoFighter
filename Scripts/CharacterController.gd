extends KinematicBody

export var speed = 10.0
export var jumpAmount = 5.0

var bullet = preload("res://Scenes/Bullet.tscn")
export var bulletSpeed = 20.0
export (float) var bulletLift = 0.25

var up = false 
var down = false
var left = false
var right = false
var isMoveable = true 
var isJumping = false

var velocity = Vector3.ZERO
var direction = Vector3.ZERO
var globalDelta = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	kb_input()
	m_input()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	globalDelta = delta
	movement(delta)
	
	
	if(is_on_floor()):
		isJumping = false
	else:
		isJumping = true


func m_input():
	if(Input.is_action_just_pressed("fire")):
		#fire()
		pass
		


func fire(dir):
	var inst = bullet.instance()
	inst.transform = transform
	inst.transform.origin += dir * 0.1
	
	get_tree().get_root().call_deferred("add_child", inst)
	inst.apply_impulse(Vector3(), dir * globalDelta * bulletSpeed)

func kb_input():
	if(Input.is_action_just_pressed("move_up")):
		up = true
		#direction.z -= 1
	if(Input.is_action_just_pressed("move_down")):
		down = true
		#direction.z += 1
	if(Input.is_action_just_pressed("move_left")):
		left = true
		#direction.x -= 1
	if(Input.is_action_just_pressed("move_right")):
		right = true
		#direction.x += 1
		
	if(Input.is_action_just_released("move_up")):
		up = false
	if(Input.is_action_just_released("move_down")):
		down = false
	if(Input.is_action_just_released("move_left")):
		left = false
	if(Input.is_action_just_released("move_right")):
		right = false
		
	if(Input.is_action_just_pressed("jump") and !isJumping):
		velocity.y += jumpAmount
		isJumping = true
	
	if(Input.is_action_just_pressed("fire_up")):
		fire(Vector3(0, bulletLift, -1))
	if(Input.is_action_just_pressed("fire_down")):
		fire(Vector3(0, bulletLift, 1))
	if(Input.is_action_just_pressed("fire_left")):
		fire(Vector3(-1, bulletLift, 0))
	if(Input.is_action_just_pressed("fire_right")):
		fire(Vector3(1, bulletLift, 0))


func movement(delta):
	if(isMoveable):
		if(up):
			direction.z = -1
		if(down):
			direction.z = 1
		if(!up and !down):
			direction.z = 0
		
		if(left):
			direction.x = -1 
		if(right):
			direction.x = 1
		if(!left and !right):
			direction.x = 0
		
		#if(direction != Vector3.ZERO):
			#direction = direction.normalized()
			#$Pivot.look_at(translation + direction, Vector3.ZERO)
			
		velocity.x = direction.x * speed * delta
		velocity.z = direction.z * speed * delta
		velocity.y -= 35.0 * delta
		
		velocity = move_and_slide(velocity, Vector3.UP)
