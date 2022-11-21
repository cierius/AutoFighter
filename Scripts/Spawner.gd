extends Node


var base_enemy: PackedScene = preload("res://Prefabs/BaseEnemy.tscn")

export var spawns: Array = []

var spawn_freq: float = 7.0
var spawn_quantity: int = 3

var elapsed_time: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	print(spawns[0])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(elapsed_time >= spawn_freq):
		for index in range(spawn_quantity):
			var rand_pos = round(rand_range(1, 3))
			var inst = base_enemy.instance()
			
			get_parent().call_deferred("add_child", inst)
			
			inst.position = get_node(spawns[rand_pos-1]).position
		
		elapsed_time = 0 
	else:
		elapsed_time += delta
