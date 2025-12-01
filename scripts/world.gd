extends Node3D

var player_names: Array[String] = []
var game: Game = Game.new()

@onready var ui_layer: CanvasLayer = $UILayer
@onready var game_ui: Control = $UILayer/GameUI

func _ready():
	# If no player names were set, open the main menu
	if self.player_names.is_empty():
		open_main_menu()
	else:
		print("Game starting with players: ", self.player_names)
		initialize_game()
		setup_ui()

func set_player_names(names: Array[String]):
	self.player_names = names

func open_main_menu():
	# Load and switch to main menu
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")

func initialize_game():
	self.game.start_game(self.player_names)
	if game_ui:
		game_ui.set_game(self.game)

func setup_ui():
	# Create CanvasLayer
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	
	# Load and instantiate UI scene
	var ui_scene = load("res://gui/game_ui.tscn")
	var ui_instance = ui_scene.instantiate()
	canvas_layer.add_child(ui_instance)
	
	# Pass game reference
	ui_instance.set_game(self.game)
