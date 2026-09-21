extends Node
class_name C_Floating_UI

@export var target: Node3D
@export var offset_3d: Vector3

@onready var _parent: Control = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos_3d := target.global_position + offset_3d
	var cam := get_viewport().get_camera_3d()
	var pos_2d := cam.unproject_position(pos_3d)
	_parent.global_position = pos_2d - _parent.pivot_offset
	_parent.visible = not cam.is_position_behind(pos_3d)
