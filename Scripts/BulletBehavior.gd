extends RigidBody

signal damaged(amount)

var startTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	contacts_reported = 2
	startTime = Time.get_ticks_msec()
	
# Destroys self if time surpasses 10 seconds
func _process(_delta):
	if(Time.get_ticks_msec() - startTime > 10.0 * 1000):
		queue_free()

func _on_collision_enter(body):
	if(body.is_in_group("wall")):
		queue_free()
	
	if(body.is_in_group("enemy")):
		# Connects the damage to the colliding body, if its an enemy
		connect("damaged", body, "_on_damaged")
		
		# Then sends the damage through to the enemy
		emit_signal("damaged", 5)
		queue_free()
