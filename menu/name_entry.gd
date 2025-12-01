# NameEntry.gd
extends Control

const MAX_PLAYERS = 6

var player_names: Array[String] = []

@onready var name_input = $VBoxContainer/NameInput
@onready var add_button = $VBoxContainer/AddButton
@onready var player_list = $VBoxContainer/PlayerList
@onready var start_button = $VBoxContainer/StartButton

func _ready():
	add_button.pressed.connect(_on_add_pressed)
	start_button.pressed.connect(_on_start_pressed)
	start_button.visible = false
	update_ui()

func _on_add_pressed():
	var player_name = name_input.text.strip_edges()
	
	if player_name.is_empty():
		return
	
	if player_names.size() < MAX_PLAYERS:
		player_names.append(player_name)
		name_input.text = ""
		update_ui()
		
		# Focus back on input for next name
		if player_names.size() < MAX_PLAYERS:
			name_input.grab_focus()

func update_ui():
	# Update the player list display
	player_list.text = "Players (%d/%d):\n" % [player_names.size(), MAX_PLAYERS]
	for i in player_names.size():
		player_list.text += "%d. %s\n" % [i + 1, player_names[i]]
	
	# Disable input if max players reached
	if player_names.size() >= MAX_PLAYERS:
		name_input.editable = false
		add_button.disabled = true
		start_button.visible = true
	else:
		name_input.editable = true
		add_button.disabled = false
		start_button.visible = player_names.size() > 1

func _on_start_pressed():
	print("Starting game with players: ", player_names)
	# Load the world scene and pass the player names
	var world_scene = load("res://world.tscn").instantiate()
	
	# Check if the world scene has a method to receive player names
	if world_scene.has_method("set_player_names"):
		world_scene.set_player_names(player_names)
	
	get_tree().root.add_child(world_scene)
	get_tree().current_scene = world_scene
	queue_free()
