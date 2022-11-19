extends RigidBody2D

signal hit(amount)

export var life: float = 0.5
var elapsed_time = 0.0

var is_player_proj: bool = false
var damage = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed_time += delta
	
	if(elapsed_time >= life):
		queue_free()


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if(body.is_in_group("Enemy")):
		connect("hit", body, "_on_damage")
		emit_signal("hit", damage)
		#queue_free()
	
	elif(body.is_in_group("Player")):
		connect("hit", body.get_node("./Collider"), "_on_damage")
		emit_signal("hit", 10.0)
		queue_free()
	
	elif(body.is_in_group("Defense")):
		connect("hit", body.get_parent(), "_on_damage")
		emit_signal("hit", 10.0)
		queue_free()
	
	else:
		if(!body.is_in_group("Enemy_Projectile")):
			queue_free()


func _set_damage(amount):
	is_player_proj = true
	damage = amount
