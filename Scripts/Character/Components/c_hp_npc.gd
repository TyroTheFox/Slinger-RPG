extends Node
class_name C_HP_NPC

signal dies

var max_hp = 10
var hp = max_hp

var alive = true

@onready var enemy_stats: GUI_Enemy_Stat_Box = $"../enemy_stats"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func reset():
	hp = max_hp
	alive = true
	
	if enemy_stats:
		enemy_stats.update_hp(hp)

func take_damage(damage_taken: float):
	hp -= damage_taken
	
	print("New HP: ", hp)
	
	if hp <= 0:
		hp = 0
		alive = false
		dies.emit()
	
	if enemy_stats:
		enemy_stats.update_hp(hp)

func heal_hp(healing_given: float):
	hp += healing_given
	
	if hp > max_hp:
		hp = max_hp
	
	if enemy_stats:
		enemy_stats.update_hp(hp)
