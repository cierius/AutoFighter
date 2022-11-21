# This is the most basic of enemies.
# Enemy doesn't use complex pathfinding, it just takes the nearest linear path straight at the target.
# May become more complex but as of current the point is to keep this as simple as possible.
extends KinematicBody2D

# Grab our refs to the player and defense so we can use their locations
onready var player = get_node("../Player")
onready var defense = get_node("../DefensePoint")

onready var proj_prefab: PackedScene = load("res://Prefabs/E_Projectile.tscn")

# For managing the state of the enemy
enum State { TRACK, ATK, FLEE, ATK_D }
var cur_state = State.TRACK

# Movement + Tracking variables
var tracking_range: int = 200 #Distance to track to player instead of defense point
var speed: float = 100
var speed_mod: float = 1.0

# Attack variables
export var attack_dmg: float = 1.0
var dmg_mod: float = 1.0
var attack_range: int = 200 #Base is 190
var attack_cd: float = 1.25
var cd_timer: float = 0.0
var is_attack_ready: bool = true
var proj_speed: float = 200.0

var health = 50.0


func _enter_tree():
	player = get_node("../Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(cur_state == State.TRACK):
		track_and_move(delta)
	elif(cur_state == State.ATK):
		attack()
	elif(cur_state == State.ATK_D):
		attack(false)
	elif(cur_state == State.FLEE):
		flee()
	
	if(!is_attack_ready):
		if(cd_timer >= attack_cd):
			is_attack_ready = true
			cd_timer = 0
		else:
			cd_timer += delta


func track_and_move(delta: float):
	if(position.distance_to(player.position) <= tracking_range):
		position += move_and_slide((player.position - position).normalized() * speed * speed_mod * delta)
		
		if(position.distance_to(player.position) <= attack_range):
			print("Attack Player")
			cur_state = State.ATK
	else:
		position += move_and_slide((defense.position - position).normalized() * speed * speed_mod * delta)
		
		if(position.distance_to(defense.position) <= attack_range):
			print("Attack D")
			cur_state = State.ATK_D


func attack(attack_player: bool = true):
	if(is_attack_ready):
		if(attack_player):
			var inst = proj_prefab.instance()
			inst.position = position + (position - player.position).normalized() * -50.0
			
			
			get_tree().get_root().call_deferred("add_child", inst)
			inst.look_at(player.position)
			inst.apply_impulse(Vector2(), (position - player.position).normalized() * -proj_speed)
			
			is_attack_ready = false
			cur_state = State.TRACK
			
		else:
			var inst = proj_prefab.instance()
			inst.position = position + (position - defense.position).normalized() * -50.0
			inst.look_at(defense.position)
			
			get_tree().get_root().call_deferred("add_child", inst)
			
			inst.apply_impulse(Vector2(), (position - defense.position).normalized() * -proj_speed)
			
			is_attack_ready = false
			cur_state = State.TRACK


func _on_damage(amount):
	health -= amount
	
	print(health)
	
	if(health <= 0):
		queue_free()


func flee():
	print("flee")
