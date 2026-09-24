extends Node
class_name C_HP_Player

signal dies

var max_hp = 10
var hp = max_hp

var alive = true

@export var hp_function_name = "set_up_hp_player"
@export var hp_update_function_name = "update_hp_player"

@onready var damage_numbers: GUI_Damage_Numbers_Spawner = $"../damage_numbers"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().call_group("Battle_Scene_GUI", hp_function_name, hp, max_hp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func reset():
	hp = max_hp
	alive = true
	
	get_tree().call_group("Battle_Scene_GUI", hp_update_function_name, hp)

func take_damage(damage_taken: float):
	hp -= damage_taken
	
	print("New HP: ", hp)
	damage_numbers.spawn_number(damage_taken)
	
	if hp <= 0:
		hp = 0
		alive = false
		dies.emit()
	
	get_tree().call_group("Battle_Scene_GUI", hp_update_function_name, hp)

func heal_hp(healing_given: float):
	hp += healing_given
	
	if hp > max_hp:
		hp = max_hp
	
	get_tree().call_group("Battle_Scene_GUI", hp_update_function_name, hp)
