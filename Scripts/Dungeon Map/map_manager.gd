extends Node
class_name Map_Manager

signal progress_changed(progress)
signal load_finished

var loaded_resource: PackedScene
var scene_path: String
var progress: Array = []
var use_sub_threads: bool = true

@onready var map_space: Node3D = $"../map_space"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)

func load_scene(_scene_path: String) -> void:
	scene_path = _scene_path
	
	start_load()

func load_saved_scene(scene_name: String) -> void:
	if GlobalVariables.map_scene_list.has(scene_name):
		scene_path = GlobalVariables.map_scene_list.get(scene_name)
		
		start_load()
	else:
		print("Error: Cannot Find Scene called ", scene_name)

func start_load() -> void:
	var state = ResourceLoader.load_threaded_request(scene_path, "", use_sub_threads)
	
	if state == OK:
		set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	progress_changed.emit(progress[0])
	
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			loaded_resource = ResourceLoader.load_threaded_get(scene_path)
			var instance = loaded_resource.instantiate()
			map_space.add_child(instance)
			
			load_finished.emit()
