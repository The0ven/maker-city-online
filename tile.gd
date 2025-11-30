class_name Tile

extends Sprite3D

enum TileType {EMPTY, FOREST, TOWN, CLEARING, CITY, LOGGER}

var rng = RandomNumberGenerator.new()

var texture_dict = {
	TileType.EMPTY: "empty",
	TileType.FOREST: "tree" + str(rng.randi_range(1,4)),
	TileType.TOWN: "town",
	TileType.CLEARING: "clearing",
	TileType.CITY: "city",
	TileType.LOGGER: "logger"
}

var t_owner: int = -1
var t_type: TileType
var t_selected: bool = false
var r_idx: int
var c_idx: int
var fields = ["t_owner", "t_type", "t_selected", "r_idx", "c_idx"]
var texture_str: String
var grid: Grid

func _init(hex_grid: Grid, row_idx: int, col_idx: int, tile_type: TileType = TileType.EMPTY) -> void:
	self.grid = hex_grid
	self.r_idx = row_idx
	self.c_idx = col_idx
	self.t_type = tile_type
	self.texture_str = "res://assets/tiles/" + self.texture_dict[self.t_type] + ".png"
	pixel_size = Grid.pixel_size
	billboard = BaseMaterial3D.BILLBOARD_DISABLED
	texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	rotation_degrees = Vector3(-90, 0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = load(self.texture_str)
	
	var area = Area3D.new()
	area.input_ray_pickable = true  # Enable input picking
	area.input_event.connect(_on_area_input_event)
	add_child(area)
	
	var hex_button = HexCollider.new(self.get_item_rect().get_center())
	area.add_child(hex_button)
	
func _on_area_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Notify the grid that this tile was clicked
		get_parent().on_tile_clicked(self)

func _to_string() -> String:
	var out_str := str(self.r_idx) + "_" + str(self.c_idx)
	return out_str

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
