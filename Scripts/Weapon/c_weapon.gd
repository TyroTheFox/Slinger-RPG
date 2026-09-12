extends Node
class_name C_Weapon

var weapon_attack_component: C_Weapon_Attack
var weapon_defend_component: C_Weapon_Defend

var recharge_speed = 1
var capacity = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapon_attack_component = $C_Weapon_Attack
	weapon_defend_component = $C_Weapon_Defend

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_attack_button(pressed: bool): 
	weapon_attack_component.attack_button_held = pressed

func update_defend_button(pressed: bool): 
	weapon_defend_component.defend_button_held = pressed
