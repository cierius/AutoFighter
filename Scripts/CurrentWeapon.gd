extends Sprite



# Called when the node enters the scene tree for the first time.
func _ready():
	texture = get_node("../../ClassManager").call("_get_main_class").stats["attack_sprite"]
	


func _on_switch_class(stats):
	if(stats):
		texture = stats["attack_sprite"]

func _process(delta):
	pass
	#look_at()
