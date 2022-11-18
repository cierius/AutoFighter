extends Node2D

var health_base: int = 1000
var health_mod: float = 1.0
onready var health: float = health_base * health_mod

var defense_mod: float = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_damage(amount: float):
	health -= amount * defense_mod
	
	print(health)
	
	if(health <= 0.0):
		print("GAME OVER - Defense has been compromised!")
