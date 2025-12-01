class_name Inventory

extends Object

signal inventory_changed()

var loggers: int:
	set(value):
		loggers = value
		inventory_changed.emit()
		
var factories: int:
	set(value):
		factories = value
		inventory_changed.emit()
		
var mafia: int:
	set(value):
		mafia = value
		inventory_changed.emit()

func _init() -> void:
	self.loggers = 1
	self.factories = 1
	self.mafia = 0
