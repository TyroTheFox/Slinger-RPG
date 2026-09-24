extends Node
class_name C_Projectile_Attack_Animation

signal end_animation

@export var emit_point: Node3D
@export var projectile_scene: PackedScene
@export var projectile_speed: float = 0.5

@export var charge_level_projectile_scale_increase: float = 0.5

var target: Vector3 = Vector3(0, 0, 0)

# Called when the node enters the scene tree for the first time.6
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func emit_attack_projectile(charge_level: int = 1):
	var npcs = get_tree().get_nodes_in_group("NPC_Character")
	var npc = npcs[0]
	var projectile_scale_increase = (charge_level - 1) * charge_level_projectile_scale_increase
	
	target = (npc as Node3D).global_position
	
	var projectile = projectile_scene.instantiate()
	
	emit_point.add_child(projectile)
	
	(projectile as Node3D).scale.x += projectile_scale_increase
	(projectile as Node3D).scale.y += projectile_scale_increase
	(projectile as Node3D).scale.z += projectile_scale_increase
	
	var callback = func(): 
		projectile.queue_free()
		end_animation.emit()
	
	var tween = get_tree().create_tween()
	tween.tween_property(projectile, "global_position", target, projectile_speed)
	tween.tween_callback(callback)
