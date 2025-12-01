class_name Player

extends Object

signal balance_changed(new_balance: int)
signal inventory_changed()

var balance: int:
	set(value):
		balance = value
		balance_changed.emit(balance)
var player_id: int
var colour: Color
var company_name: String
var inventory: Inventory

func _init(id: int, p_colour: Color, name: String) -> void:
	self.balance = 6_000
	self.inventory = Inventory.new()
	self.player_id = id
	self.colour = p_colour
	self.company_name = name
	
	self.inventory.inventory_changed.connect(_on_inventory_changed)
	
func _on_inventory_changed():
	inventory_changed.emit()
