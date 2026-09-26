extends Control
class_name GUI_Damage_Numbers_Spawner

@onready var number_space: Control = $number_space
@onready var spawn_points: Node2D = $spawn_points
@onready var target_points: Node2D = $target_points

@export var damage_number_scene: PackedScene
@export var movement_duration: float = 1

var number_spawn_points: Array[Node2D]
var number_target_points: Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in spawn_points.get_children():
		number_spawn_points.push_back(node)
	
	for node in target_points.get_children():
		number_target_points.push_back(node)

func spawn_number(number_value: int) -> void:
	var damage_number = damage_number_scene.instantiate()
	var random_number = randi() % number_spawn_points.size()
	var rand_spawn_point = number_spawn_points[random_number]
	var rand_target_point = number_target_points[random_number]
	
	number_space.add_child(damage_number)
	damage_number.position = rand_spawn_point.position
	
	(damage_number as Label).text = str(number_value)
	
	var callback = func(): 
		damage_number.queue_free()
	
	var tween = get_tree().create_tween()
	tween.tween_property(
		damage_number, 
		"position", 
		rand_target_point.position, 
		movement_duration
	).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(callback)
