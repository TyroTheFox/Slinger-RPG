extends Node3D
class_name C_Weapon

signal charge_weapon
signal fire_weapon

signal start_defend
signal end_defend

signal start_recharge
signal end_recharge

@onready var weapon_attack_component: C_Weapon_Attack = $C_Weapon_Attack
@onready var weapon_defend_component: C_Weapon_Defend = $C_Weapon_Defend
@onready var weapon_battery_component: C_Weapon_Battery = $C_Weapon_Battery

@onready var projectile_attack_animation_component: C_Projectile_Attack_Animation = $C_Projectile_Attack_Animation

var holder_animation_player: AnimationPlayer

var recharge_speed = 1
var capacity = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	charge_weapon.connect(on_charge_weapon)
	fire_weapon.connect(on_fire_weapon)
	
	start_defend.connect(on_start_defend)
	end_defend.connect(on_end_defend)
	
	start_recharge.connect(on_start_recharge)
	end_recharge.connect(on_end_rechargee)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_charge_weapon():
	holder_animation_player.stop(false)
	holder_animation_player.play("charging_attack")
	weapon_attack_component.charge_weapon.emit()

func on_fire_weapon():
	var weapon_charged = weapon_attack_component.attack_charges > 1
	
	holder_animation_player.stop(false)
	weapon_attack_component.fire_weapon.emit()
	
	if weapon_charged:
		holder_animation_player.play("fire_charged_attack")
	else:
		holder_animation_player.play("fire_attack")

func on_start_defend():
	holder_animation_player.stop(false)
	holder_animation_player.play("start_defend")
	weapon_defend_component.start_defend.emit()

func on_end_defend():
	holder_animation_player.stop(false)
	weapon_defend_component.end_defend.emit()

func on_start_recharge():
	weapon_battery_component.start_charge.emit()

func on_end_rechargee():
	weapon_battery_component.stop_charge.emit()
