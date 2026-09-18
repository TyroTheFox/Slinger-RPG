extends Node
class_name C_Projectile_Attack_Animation

signal end_animation

@export var emit_point: Node3D
@export var projectile_scene: PackedScene

var target: Vector3 = Vector3(0, 0, 0)

# Called when the node enters the scene tree for the first time.6
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func emit_attack_projectile():
	var npcs = get_tree().get_nodes_in_group("NPC_Character")
	var npc = npcs[0]
	
	target = (npc as Node3D).global_position
	
	var projectile = projectile_scene.instantiate()
	
	emit_point.add_child(projectile)
	
	var callback = func(): 
		projectile.queue_free()
		end_animation.emit()
	
	var tween = get_tree().create_tween()
	tween.tween_property(projectile, "global_position", target, 1.0)
	tween.tween_callback(callback)
