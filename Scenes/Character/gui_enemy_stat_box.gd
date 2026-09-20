extends Control
class_name GUI_Enemy_Stat_Box

@export var target: Node3D
@export var offset_3d: Vector3

@onready var hp_bar: ProgressBar = $hp
@onready var enemy_name_label: Label = $enemy_name_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos_3d := target.global_position + offset_3d
	var cam := get_viewport().get_camera_3d()
	var pos_2d := cam.unproject_position(pos_3d)
	global_position = pos_2d
	visible = not cam.is_position_behind(pos_3d)

func set_up(current_hp: int, max_hp: int):
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp

func update_hp(current_hp: int):
	hp_bar.value = current_hp

func set_enemy_name(enemy_name: String):
	enemy_name_label.text = enemy_name
