class_name HexCollider

extends CollisionPolygon3D

func _init(center: Vector2) -> void:
	self.depth = 0.1
	self.polygon = PackedVector2Array([
		center + Vector2(-1.0, 0.5), 
		center + Vector2(0.0, 1.0), 
		center + Vector2(1.0, 0.5), 
		center + Vector2(1.0, -0.5), 
		center + Vector2(0, -1.0), 
		center + Vector2(-1.0, -0.5)
	])
