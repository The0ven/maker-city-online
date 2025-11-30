class_name Grid

extends Node3D

const length = 8
const height = 8
const pixel_size = 0.01
const h_gap_amt = 8 * pixel_size
const v_gap_amt = 6 * pixel_size
const hex_v_blank_pixels = 60
var grid: Array[Array] = []
var selectedTile: Tile
var camera: Camera3D

func _ready() -> void:

	camera = get_viewport().get_camera_3d()
	if not camera:
		camera = Camera3D.new()
		add_child(camera)

	# Create a temporary tile to get sprite dimensions
	var sample_texture = load("res://assets/tiles/tree1.png")
	var texture_size = sample_texture.get_size()
	
	# Calculate hex dimensions from actual sprite size
	var hex_width = texture_size.x * self.pixel_size
	var hex_height = texture_size.y * self.pixel_size

	# Position camera above the grid looking down
	camera.position = Vector3(length * hex_width / 2.0, 10, height * hex_height / 2.0)
	camera.rotation_degrees = Vector3(-90, 0, 0)  # Look straight down

	for row_idx in range(self.height):
		var row: Array[Tile] = []
		const towns = ["3_4"]
		const cities = ["7_7"]
		const loggers = ["1_1"]
		const clearings = ["2_2", "2_4", "2_5", "3_3", "3_5", "4_4", "4_5", "6_7", "7_6"]
		for col_idx in range(self.length):
			var coords = str(row_idx) + "_" + str(col_idx)
			var tile = Tile.new(self, row_idx, col_idx, Tile.TileType.CLEARING if coords in clearings else Tile.TileType.TOWN if coords in towns else Tile.TileType.LOGGER if coords in loggers else Tile.TileType.CITY if coords in cities else Tile.TileType.FOREST)
			add_child(tile)
			
			# Hexagonal grid positioning with gap (offset rows)
			var x = col_idx * hex_width + (col_idx * self.h_gap_amt) + (195 * self.pixel_size)
			var z = row_idx * (hex_height - (self.hex_v_blank_pixels * self.pixel_size)) + (row_idx * self.v_gap_amt) + (209 * self.pixel_size)
			
			# Offset every other row
			if row_idx % 2 == 1:
				x += hex_width * 0.5# half the width
				x += self.h_gap_amt / 2.0
			
			tile.position = Vector3(x, 0, z)
			
			row.append(tile)
		self.grid.append(row)
	print(self.grid)

func on_tile_clicked(tile: Tile) -> void:
	# Deselect previous tile
	if selectedTile:
		selectedTile.t_selected = false
		selectedTile.modulate = Color(1, 1, 1)  # Reset color
	
	# Select new tilewd
	selectedTile = tile
	tile.t_selected = true
	tile.modulate = Color(0.4, 0.6, 0.8)  # Highlight in light blue
	
	print("Clicked tile: ", tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
