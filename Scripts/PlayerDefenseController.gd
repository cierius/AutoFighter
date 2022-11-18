extends CollisionShape2D

onready var hp_bar: TextureProgress = get_parent().get_node("../HUD/CenterContainer/Player_Healthbar")

var health_base: int = 100
var health_mod: float = 1.0
onready var health: float = health_base * health_mod
var defense_mod: float = 1.0


func _ready():
	hp_bar.max_value = health_base * health_mod
	hp_bar.value = health

func _on_damage(amount: float):
	health -= amount * defense_mod
	
	hp_bar.value = health
	
	print("player health: " + str(health))
	
	if(health <= 0.0):
		print("GAME OVER - Player has been defeated!")
