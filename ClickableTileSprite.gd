class_name ClickableTileSprite

extends Sprite3D

var tile: Tile

func _init(hex_tile: Tile) -> void:
	self.tile = hex_tile

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if get_item_rect().has_point(event.position):
				self.tile.grid.on_tile_clicked(self.tile)
