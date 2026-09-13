extends Node
class_name C_HP

signal dies

var max_hp = 10
var hp = max_hp

var alive = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset():
	hp = max_hp
	alive = true

func take_damage(damage_taken: float):
	hp -= damage_taken
	
	print("New HP: ", hp)
	
	if hp <= 0:
		hp = 0
		alive = false
		dies.emit()

func heal_hp(healing_given: float):
	hp += healing_given
	
	if hp > max_hp:
		hp = max_hp
