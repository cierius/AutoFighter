extends Node2D

enum State { ATTACKING, DEFENDING, CHECKING, IDLE}
var cur_state = State.CHECKING

class Class:
	var damage: float = 10.0
	var damage_mod: float = 1.0
	var attack_range: int = 100
	var attack_freq: float = 1.0 # Attacks per sec

var Ranger: Class = Class.new()
var Thief: Class = Class.new()

var selected_class: Class

# Attack range variables
var attack_range: int = 200
export var shape: Shape2D # The collision shape we use for raycasting
export var show_in_range: bool = false # Debug tool to show when enemies are in auto-target range

# Range-checking variables 
var check_freq: float = 0.05 # Time in secs until the next range scan
var elapsed_time: float = 0.0


func _ready():
	set_up_classes()
	Ranger.attack_range = 300
	
	selected_class = Ranger


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(elapsed_time >= check_freq):
		check_range()
		elapsed_time = 0
	else:
		elapsed_time += delta
		


func check_range():
	var space_state = get_world_2d().direct_space_state
	var enemies_in_range = []
	
	# Reset the debug range line
	$"DEBUG attack_range".points[1] = Vector2.ZERO
	
	# Shape casting the area around the player
	var query = Physics2DShapeQueryParameters.new()
	shape.radius = selected_class.attack_range
	query.shape_rid = shape.get_rid()
	query.transform = global_transform
	
	var result = space_state.intersect_shape(query)
	
	# We get an array and must find out if we collided with any enemies
	for res in result:
		if(res.collider.is_in_group("Enemy")):
			enemies_in_range.append(res.collider.position)
	
	var closest = 100000
	var closest_unit = Vector2.ZERO
	for enemy in enemies_in_range:
		var dist = enemy.distance_to(get_parent().position)
		
		if(dist <= closest):
			closest = dist
			closest_unit = enemy
	
	if(show_in_range and closest_unit != Vector2.ZERO):
		$"DEBUG attack_range".points[0] = Vector2.ZERO
		$"DEBUG attack_range".points[1] = closest_unit - get_parent().position
	#print("Closest: " + str(closest) + " | Enemies:" + str(enemies_in_range))


func attack(unit):
	print("attacking " + str(unit))



# Set up the classes below here --- I don't know a better way to do this class system with Godot
func set_up_classes():
	Ranger.attack_range = 300
	Ranger.damage = 7.5
	Ranger.damage_mod = 0.9
	Ranger.attack_freq = 0.8
	
	Thief.attack_range = 125
	Thief.damage = 10.0
	Thief.damage_mod = 1.0
	Thief.attack_freq = 1.2

