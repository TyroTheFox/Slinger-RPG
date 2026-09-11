extends Node
class_name C_Player_Character

var weapon_scene = preload("res://Scenes/Weapons/weapon.tscn")

@export var weapon_hold_point: Node3D

var weapon_instance

var HP = 10

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
	if event.is_action_pressed(key_bind_attack):
		start_attack()
		
	if event.is_action_released(key_bind_attack):
		end_attack()
	
	if event.is_action_pressed(key_bind_defend):
		start_defend()
	
	if event.is_action_released(key_bind_defend):
		end_defend()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction_vector = Input.get_vector(key_bind_left, key_bind_right, key_bind_up, key_bind_down)
	
	if weapon_instance:
		weapon_instance.update_attack_button(charging_attack)

func start_attack(): 
	charging_attack = true;

func end_attack():
	charging_attack = false;

func start_defend():
	defending = true;

func end_defend():
	defending = true;

func spawn_weapon() -> void:
	weapon_instance = weapon_scene.instantiate()
	weapon_hold_point.add_child(weapon_instance)

func _on_tree_entered() -> void:
	spawn_weapon()
