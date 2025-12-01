class_name Game

extends Object

signal round_changed(new_round: int)
signal player_changed(new_player: Player)

var current_round: int = 1:
	set(value):
		current_round = value
		round_changed.emit(current_round)
		
var current_player_id: int = -1
			
var current_player: Player:
	set(value):
		current_player = value
		player_changed.emit(current_player)
		
var players: Array[Player] = []
var player_colours = [Color("pink"), Color("light-blue"), Color("light-green"), Color("coral"), Color("medium-purple"), Color("sandy-brown")]

func start_game(names: Array[String]) -> void:
	for name in names:
		var player = Player.new(len(self.players), self.player_colours.pop_front(), name)
		self.players.append(player)
	self.next_turn()

func next_round():
	self.current_player_id = -1
	self.current_round += 1
	self.next_turn()

func next_turn():
	if self.current_player_id >= (self.players.size() - 1):
		self.next_round()
	else:
		self.current_player_id += 1
		print(current_player_id)
		self.current_player = self.players.get(current_player_id)
