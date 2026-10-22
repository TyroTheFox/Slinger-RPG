extends Node
class_name C_Avatar_Grid_Movement

signal start_moving
signal moving_update(position: Vector2)
signal stopped

@export var movement_speed: float = 0.15
@export var player_model: Node3D
@export var model_height: float = 2.0

var player_map_avatar_component: C_Player_Map_Avatar = null

var grid_position: Vector2i = Vector2i(0, 0)
var grid_target: Vector2i = Vector2i(0, 0)

var space_position: Vector2
var target_position: Vector2

var moving: bool = false

var spacing_x: float = 1.0
var spacing_z: float = 1.0

var full_grid_width: float = 0
var full_grid_height: float = 0

func tween_to_target():
	var tween = create_tween()

	tween.tween_method(tween_movement_update, space_position, target_position, movement_speed).set_trans(Tween.TRANS_SINE)

	moving = true
	
	start_moving.emit()
	
	await tween.finished
	
	stopped.emit()
	
	moving = false

	grid_position = grid_target

func tween_movement_update(new_position: Vector2):
		space_position = new_position
		moving_update.emit(new_position)
		update_avatar_position()

func update_space_position():
	var x_position = grid_position.x * spacing_x
	var z_position = grid_position.y * spacing_z
	var grid_offset_x = full_grid_width * 0.5
	var grid_offset_z = full_grid_height * 0.5

	space_position.x = x_position - grid_offset_x
	space_position.y = z_position - grid_offset_z

func update_target_position():
	var x_position = grid_target.x * spacing_x
	var z_position = grid_target.y * spacing_z
	var grid_offset_x = full_grid_width * 0.5
	var grid_offset_z = full_grid_height * 0.5

	target_position.x = x_position - grid_offset_x
	target_position.y = z_position - grid_offset_z

func update_avatar_position():
	player_map_avatar_component.position.x = space_position.x
	player_map_avatar_component.position.z = space_position.y

func set_position(new_position: Vector2i): 
	grid_position = new_position
	update_space_position()
	update_avatar_position()

func set_target_position(new_target_position: Vector2i, move_now: bool = false):
	grid_target = new_target_position
	update_target_position()

	if move_now and not moving:
		move_avatar_to_target()

func move_avatar_to_target():
	var valid_move_target: bool = player_map_avatar_component.check_valid_grid_navigation()

	if not moving:
		face_toward_target_square()
		if valid_move_target:
			tween_to_target()

func move_target_by(move_vector: Vector2i, move_now: bool = false):
	var new_target_vector = grid_position + move_vector

	set_target_position(new_target_vector, move_now)

func face_toward_target_square():
	var target_square_3D = Vector3(target_position.x, 0, target_position.y)
	player_model.look_at(target_square_3D, Vector3(0, 1, 0))
	player_model.rotation.x = 0