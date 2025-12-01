# game_ui.gd
extends Control

var game: Game = null

# UI References
var round_label: Label
var player_name_label: Label
var balance_label: Label
var loggers_label: Label
var factories_label: Label
var mafia_label: Label
var player_color_rect: ColorRect
var next_turn_button: Button

func _ready():
	# Allow mouse clicks to pass through to the 3D world
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	setup_ui()

func setup_ui():
	# Round panel - Top Left
	var round_panel = create_panel()
	round_panel.position = Vector2(20, 20)
	add_child(round_panel)
	
	var round_vbox = VBoxContainer.new()
	round_panel.add_child(round_vbox)
	
	round_label = Label.new()
	round_label.add_theme_font_size_override("font_size", 20)
	round_vbox.add_child(round_label)
	
	# Current Player Panel - Top Right
	var player_panel = create_panel()
	player_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	player_panel.position = Vector2(-20, 20)
	player_panel.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	add_child(player_panel)
	
	var player_vbox = VBoxContainer.new()
	player_panel.add_child(player_vbox)
	
	# Player color indicator
	var color_hbox = HBoxContainer.new()
	color_hbox.add_theme_constant_override("separation", 10)
	player_vbox.add_child(color_hbox)
	
	player_color_rect = ColorRect.new()
	player_color_rect.custom_minimum_size = Vector2(30, 30)
	color_hbox.add_child(player_color_rect)
	
	player_name_label = Label.new()
	player_name_label.add_theme_font_size_override("font_size", 24)
	color_hbox.add_child(player_name_label)
	
	balance_label = Label.new()
	balance_label.add_theme_font_size_override("font_size", 18)
	player_vbox.add_child(balance_label)
	
	# Inventory Panel - Bottom Left
	var inventory_panel = create_panel()
	inventory_panel.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	inventory_panel.position = Vector2(20, -20)
	inventory_panel.grow_vertical = Control.GROW_DIRECTION_BEGIN
	add_child(inventory_panel)
	
	var inventory_vbox = VBoxContainer.new()
	inventory_panel.add_child(inventory_vbox)
	
	loggers_label = Label.new()
	loggers_label.add_theme_font_size_override("font_size", 16)
	inventory_vbox.add_child(loggers_label)
	
	factories_label = Label.new()
	factories_label.add_theme_font_size_override("font_size", 16)
	inventory_vbox.add_child(factories_label)
	
	mafia_label = Label.new()
	mafia_label.add_theme_font_size_override("font_size", 16)
	inventory_vbox.add_child(mafia_label)
	
	# Add separator
	var separator = HSeparator.new()
	separator.add_theme_constant_override("separation", 10)
	inventory_vbox.add_child(separator)
	
	# End Turn Button
	next_turn_button = Button.new()
	next_turn_button.text = "End Turn"
	next_turn_button.add_theme_font_size_override("font_size", 18)
	next_turn_button.custom_minimum_size = Vector2(0, 50)
	next_turn_button.pressed.connect(_on_next_turn_pressed)
	inventory_vbox.add_child(next_turn_button)

func create_panel(title: String = "") -> PanelContainer:
	var panel = PanelContainer.new()
	# Allow mouse clicks on the panels themselves
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Create a StyleBox for the panel background
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.2, 0.2, 0.2, 0.8)
	style.border_color = Color(0.4, 0.4, 0.4, 1.0)
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.set_content_margin_all(10)
	panel.add_theme_stylebox_override("panel", style)
	
	var vbox = VBoxContainer.new()
	panel.add_child(vbox)
	
	if title != "":
		var title_label = Label.new()
		title_label.text = title
		title_label.add_theme_font_size_override("font_size", 14)
		title_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
		vbox.add_child(title_label)
	
	return panel

func _on_next_turn_pressed():
	if game:
		game.next_turn()

func set_game(game_instance: Game):
	# Disconnect old signals if game already set
	if game != null:
		disconnect_game_signals()
	
	self.game = game_instance
	
	# Connect to game signals
	game.round_changed.connect(_on_round_changed)
	game.player_changed.connect(_on_player_changed)
	
	# Initial UI update
	update_all_ui()

func disconnect_game_signals():
	if game.round_changed.is_connected(_on_round_changed):
		game.round_changed.disconnect(_on_round_changed)
	if game.player_changed.is_connected(_on_player_changed):
		game.player_changed.disconnect(_on_player_changed)
	
	if game.current_player:
		disconnect_player_signals(game.current_player)

func disconnect_player_signals(player: Player):
	if player.balance_changed.is_connected(_on_balance_changed):
		player.balance_changed.disconnect(_on_balance_changed)
	if player.inventory_changed.is_connected(_on_inventory_changed):
		player.inventory_changed.disconnect(_on_inventory_changed)

func _on_round_changed(new_round: int):
	round_label.text = "Round: %d" % new_round

func _on_player_changed(player: Player):
	# Disconnect signals from previous player
	if game.current_player and game.current_player != player:
		disconnect_player_signals(game.current_player)
	
	# Connect to new player's signals
	player.balance_changed.connect(_on_balance_changed)
	player.inventory_changed.connect(_on_inventory_changed)
	
	# Update UI
	update_player_ui(player)

func _on_balance_changed(new_balance: int):
	balance_label.text = "Balance: $%s" % format_money(new_balance)

func _on_inventory_changed():
	if game and game.current_player:
		update_inventory_ui(game.current_player.inventory)

func update_all_ui():
	if game == null:
		return
	
	round_label.text = "Round: %d" % game.current_round
	
	if game.current_player:
		update_player_ui(game.current_player)

func update_player_ui(player: Player):
	player_name_label.text = player.company_name
	player_color_rect.color = player.colour
	balance_label.text = "Balance: $%s" % format_money(player.balance)
	update_inventory_ui(player.inventory)

func update_inventory_ui(inventory: Inventory):
	loggers_label.text = "🪵 Loggers: %d" % inventory.loggers
	factories_label.text = "🏭 Factories: %d" % inventory.factories
	mafia_label.text = "🕴️ Mafia: %d" % inventory.mafia

func format_money(amount: int) -> String:
	var s = str(amount)
	var result = ""
	var count = 0
	for i in range(s.length() - 1, -1, -1):
		if count == 3:
			result = "," + result
			count = 0
		result = s[i] + result
		count += 1
	return result
