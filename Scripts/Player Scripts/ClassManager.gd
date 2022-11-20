extends Node

signal send_class_stats()


class Class:
	enum Role { TANK, DAMAGE, SUPPORT}
	
	var name: String
	var role = Role.TANK
	
	var stats = {
		"damage": 10.0,
		"damage_mod": 1.0,
		
		"attack_range": 200,
		"attack_freq": 1.0,
		"attack_speed": 100,
		"attack_prefab": PackedScene,
		
		"health_base": 100.0,
		"health_mod": 1.0,
		"health_regen": 1.0,
		
		"speed": 150.0,
		"speed_mod": 1.0,
	}


var Ranger: Class = Class.new()
var Thief: Class = Class.new()
var Warrior: Class = Class.new()
var Mage: Class = Class.new()
var Shaman: Class = Class.new() 
var Bard: Class = Class.new()
var Mecha_Human: Class = Class.new()

var ranged_proj_prefab: PackedScene = preload("res://Prefabs/P_Projectile.tscn")
var melee_proj_prefab: PackedScene = preload("res://Prefabs/P_Melee_Projectile.tscn")


var main_class: Class
var alt_class: Class
var cur_class: Class


func _enter_tree():
	set_up_classes()
	
	main_class = Ranger
	alt_class = Thief
	
	cur_class = main_class


func _get_main_class():
	#print(main_class.stats)
	return main_class.stats

func _get_alt_class():
	return alt_class.stats

func _get_class_stats():
	return cur_class.stats

# Called from PlayerController, switches the current class on this script
func _switch_class():
	if(cur_class == main_class):
		cur_class = alt_class
	else:
		cur_class = main_class
		
	return cur_class.stats


# Set up the classes below here --- I don't know a better way to do this class system with Godot
func set_up_classes():
	Ranger.name = "Ranger"
	Ranger.stats["attack_range"] = 300
	Ranger.stats["damage"] = 7.5
	Ranger.stats["damage_mod"] = 0.9
	Ranger.stats["attack_freq"] = 0.5
	Ranger.stats["attack_speed"] = 500
	Ranger.stats["attack_prefab"] = ranged_proj_prefab
	Ranger.stats["health_base"] = 75.0
	Ranger.stats["health_mod"] = 1.0
	Ranger.stats["health_regen"] = 0.75
	Ranger.stats["speed"] = 125
	Ranger.stats["speed_mod"] = 1.0
	
	
	Thief.name = "Thief"
	Thief.stats["attack_range"] = 125
	Thief.stats["damage"] = 6.0
	Thief.stats["damage_mod"] = 1.0
	Thief.stats["attack_freq"] = 0.2
	Thief.stats["attack_speed"] = 750
	Thief.stats["attack_prefab"] = melee_proj_prefab
	Thief.stats["health_base"] = 85.0
	Thief.stats["health_mod"] = 1.0
	Thief.stats["health_regen"] = 0.75
	Thief.stats["speed"] = 250
	Thief.stats["speed_mod"] = 1.0
	
	Warrior.name = "Warrior"
	
	Mage.name = "Mage"
	
	Shaman.name = "Shaman"
	
	Bard.name = "Bard"
	
	Mecha_Human.name = "Mecha_Human"
