extends Node2D

signal proj_spawn(damage)
signal get_class_stats()
signal get_main_class()
signal get_alt_class()

enum State { ATTACKING, DEFENDING, CHECKING, IDLE}
var cur_state = State.CHECKING


var main_class
var alt_class
var cur_class

# Attack range variables
export var shape: Shape2D # The collision shape we use for raycasting
export var show_in_range: bool = false # Debug tool to show when enemies are in auto-target range

# Range-checking variables 
var check_freq: float = 0.05 # Time in secs until the next range scan
var elapsed_time: float = 0.0

onready var ranged_proj_prefab: PackedScene = load("res://Prefabs/P_Projectile.tscn")
onready var melee_proj_prefab: PackedScene = load("res://Prefabs/P_Dagger.tscn")
var attack_timer: float = 0.0

func _ready():
	main_class = get_node("../ClassManager").call("_get_main_class")
	alt_class = get_node("../ClassManager").call("_get_alt_class")
	
	cur_class = main_class



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(elapsed_time >= check_freq):
		check_range()
		elapsed_time = 0
	else:
		elapsed_time += delta
	
	attack_timer += delta


func check_range():
	var space_state = get_world_2d().direct_space_state
	var enemies_in_range = []
	
	# Reset the debug range line
	$"DEBUG attack_range".points[1] = Vector2.ZERO
	
	# Shape casting the area around the player
	var query = Physics2DShapeQueryParameters.new()
	shape.radius = cur_class.stats["attack_range"]
	query.shape_rid = shape.get_rid()
	query.transform = global_transform
	
	var result = space_state.intersect_shape(query)
	
	# We get an array and must find out if we collided with any enemies
	for res in result:
		if(res.collider.is_in_group("Enemy")):
			enemies_in_range.append(res.collider)
	
	var closest = 100000
	var closest_unit
	for enemy in enemies_in_range:
		var dist = enemy.position.distance_to(get_parent().position)
		
		if(dist <= closest):
			closest = dist
			closest_unit = enemy
	
	#if(show_in_range and closest_unit):
		#$"DEBUG attack_range".points[0] = Vector2.ZERO
		#$"DEBUG attack_range".points[1] = closest_unit.position - get_parent().position
	
	if(closest_unit):
		if(closest_unit.position.distance_to(get_parent().position) <= cur_class.stats["attack_range"]):
			attack(closest_unit)
	#print("Closest: " + str(closest) + " | Enemies:" + str(enemies_in_range))


func attack(unit):
	if(attack_timer >= cur_class.stats["attack_freq"]):
		var inst = cur_class.stats["attack_prefab"].instance()
		
		inst.position = get_parent().position
		
		connect("proj_spawn", inst, "_set_damage")
		emit_signal("proj_spawn", cur_class.stats["damage"] * cur_class.stats["damage_mod"])
		
		get_tree().get_root().call_deferred("add_child", inst)
		inst.look_at(unit.position)
		inst.apply_impulse(Vector2(), (get_parent().position - unit.position).normalized() * -cur_class.stats["attack_speed"])
		
		attack_timer = 0
		

func _on_switch_class():
	if(cur_class == main_class):
		cur_class = alt_class
	else:
		cur_class = main_class
