extends Node3D
class_name C_Player_Character

var weapon_scene = preload("res://Scenes/Weapons/weapon.tscn")

@export var weapon_hold_point: Node3D

var weapon_instance
@onready var hp_component: C_HP_Player = $C_HP

var charging_attack = false

var defending = false;

# Movement Key Binds
## Left Movement
@export var key_bind_left: String = "ui_left"
## Right Movement
@export var key_bind_right: String = "ui_right"
## Up Movement
@export var key_bind_up: String = "ui_up"
## Down Movement
@export var key_bind_down: String = "ui_down"
## Attack Movement
@export var key_bind_attack: String = "ui_accept"
## Defend Movement
@export var key_bind_defend: String = "ui_select"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if not weapon_instance:
		return
	
	var make_action = event.is_action_pressed(key_bind_attack) or event.is_action_pressed(key_bind_defend)
	
	if make_action:
		charging_attack = event.is_action_pressed(key_bind_attack)
		defending = event.is_action_pressed(key_bind_defend)
		
		if charging_attack and defending:
			defending = true
			charging_attack = false
		
		if charging_attack:
			weapon_instance.charge_weapon.emit()
		
		if defending:
			weapon_instance.start_defend.emit()
	else:
		weapon_instance.start_recharge.emit()
	
	if event.is_action_released(key_bind_attack):
		weapon_instance.fire_weapon.emit()
	
	if event.is_action_released(key_bind_defend):
		weapon_instance.end_defend.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var direction_vector = Input.get_vector(key_bind_left, key_bind_right, key_bind_up, key_bind_down)

func spawn_weapon() -> void:
	weapon_instance = weapon_scene.instantiate()
	weapon_hold_point.add_child(weapon_instance)

func _on_tree_entered() -> void:
	spawn_weapon()

func on_deal_damage(damage_dealt: float):
	get_tree().call_group("NPC_Character", "on_take_damage", damage_dealt)
	print("DEAL DAMAGE: ", damage_dealt)

func on_take_damage(damage_taken: float):
	hp_component.take_damage(damage_taken)
	print("TAKE DAMAGE: ", damage_taken)

func on_dead():
	print("DEAD!")
