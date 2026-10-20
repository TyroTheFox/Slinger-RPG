extends Node
class_name C_Avatar_Grid_Movement

signal start_moving
signal moving_update(current_position: Vector3)
signal stopped

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if moving:
		space_position = space_position.lerp(target_position, delta)
		moving_update.emit(space_position)
		update_avatar_position()

		if space_position == target_position:
			set_position(grid_target)
			moving = false
			stopped.emit()

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
	if not moving:
		moving = true
		start_moving.emit()