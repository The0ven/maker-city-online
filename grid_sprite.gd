extends Sprite3D

func _ready() -> void:
	self.pixel_size = Grid.pixel_size
	self.offset = self.texture.get_size() / Vector2(2, -2)
	self.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
