extends Node

signal send_class_stats()


class Class:
	enum Role { TANK, DAMAGE, SUPPORT}
	enum Attack { STAB, SWING, HITSCAN, PROJECTILE }
	
	var name: String
	var role = Role.TANK
	var attack_type = Attack.STAB
	
	var stats = {
		"damage": 10.0,
		"damage_mod": 1.0,
		
		"attack_range": 200,
		"attack_freq": 1.0,
		"attack_speed": 100,
		"attack_prefab": PackedScene,
		"attack_sprite": Texture,
		
		"health_base": 100.0,
		"health_mod": 1.0,
		"health_regen": 1.0,
		
		"defense": 1.0,
		
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

var ranger_proj_prefab: PackedScene = preload("res://Prefabs/P_Projectile.tscn")
export var ranger_proj_sprite: Texture
var thief_proj_prefab: PackedScene = preload("res://Prefabs/P_Dagger.tscn")
export var thief_proj_sprite: Texture

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
	return main_class

func _get_alt_class():
	return alt_class

func _get_current_class():
	return cur_class

func _get_class_stats():
	return cur_class.stats

# Called from PlayerController, switches the current class on this script
func _switch_class():
	if(cur_class == main_class):
		cur_class = alt_class
	else:
		cur_class = main_class
	
	emit_signal("send_class_stats", cur_class.stats)
	return cur_class.stats


# Set up the classes below here --- I don't know a better way to do this class system with Godot
func set_up_classes():
	Ranger.name = "Ranger"
	Ranger.attack_type = Class.Attack.PROJECTILE
	Ranger.role = Class.Role.DAMAGE
	Ranger.stats["attack_range"] = 300
	Ranger.stats["damage"] = 7.5
	Ranger.stats["damage_mod"] = 0.9
	Ranger.stats["attack_freq"] = 0.5
	Ranger.stats["attack_speed"] = 500
	Ranger.stats["attack_prefab"] = ranger_proj_prefab
	Ranger.stats["attack_sprite"] = ranger_proj_sprite
	Ranger.stats["defense"] = 0.9
	Ranger.stats["health_base"] = 75.0
	Ranger.stats["health_mod"] = 1.0
	Ranger.stats["health_regen"] = 0.75
	Ranger.stats["speed"] = 125
	Ranger.stats["speed_mod"] = 1.0
	
	
	Thief.name = "Thief"
	Thief.role = Class.Role.DAMAGE
	Thief.attack_type = Class.Attack.STAB
	Thief.stats["attack_range"] = 125
	Thief.stats["damage"] = 6.0
	Thief.stats["damage_mod"] = 1.0
	Thief.stats["attack_freq"] = 0.2
	Thief.stats["attack_speed"] = 750
	Thief.stats["attack_prefab"] = thief_proj_prefab
	Thief.stats["attack_sprite"] = thief_proj_sprite
	Thief.stats["defense"] = 0.8
	Thief.stats["health_base"] = 85.0
	Thief.stats["health_mod"] = 1.0
	Thief.stats["health_regen"] = 0.75
	Thief.stats["speed"] = 250
	Thief.stats["speed_mod"] = 1.0
	
	
	Warrior.name = "Warrior"
	
	Mage.name = "Mage"
	
	Shaman.name = "Shaman"
	Shaman.role = Class.Role.SUPPORT
	Shaman.attack_type = Class.Attack.PROJECTILE
	Shaman.stats["attack_range"] = 350
	Shaman.stats["damage"] = 4.5
	Shaman.stats["damage_mod"] = 1.0
	Shaman.stats["attack_freq"] = 0.35
	Shaman.stats["attack_speed"] = 650
	Shaman.stats["attack_prefab"] = null
	Shaman.stats["attack_sprite"] = null
	Shaman.stats["defense"] = 0.5
	Shaman.stats["health_base"] = 65.0
	Shaman.stats["health_mod"] = 1.0
	Shaman.stats["health_regen"] = 1.0
	Shaman.stats["speed"] = 150
	Shaman.stats["speed_mod"] = 1.0
	
	
	Bard.name = "Bard"
	
	Mecha_Human.name = "Mecha_Human"
