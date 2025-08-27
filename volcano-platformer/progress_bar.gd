extends ProgressBar

func _ready():
	var players = get_tree().get_nodes_in_group("Player")
	if not players.is_empty():
		var player = players[0]
		max_value = player.max_health
		value = player.current_health
		player.health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(new_health):
	value = new_health
