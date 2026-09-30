extends Node3D
class_name Dungeon_Map_Scene

@onready var map_manager: Map_Manager = $map_manager
@onready var lookdown_camera: Camera3D = $lookdown_camera
@onready var explore_look_camera: Camera3D = $explore_look_camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explore_look_camera.current = true
	map_manager.load_saved_scene("test_map")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func switch_to_lookdown_camera():
	lookdown_camera.current = true
	explore_look_camera.current = false

func switch_to_explore_camera():
	lookdown_camera.current = false
	explore_look_camera.current = true
