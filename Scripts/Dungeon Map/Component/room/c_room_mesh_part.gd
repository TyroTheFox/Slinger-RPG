extends MeshInstance3D
class_name C_Room_Mesh_Part

func update_material(new_material: Material, surf_idx: int = 0):
	mesh.surface_set_material(surf_idx, new_material)