extends Area2D
signal coinCollected(amount)


func _ready():
	var players = get_tree().get_nodes_in_group("Player")
	
	if not players.is_empty():
		var player = players[0]
		coinCollected.connect(player.heal)
	else:
		print("Coin couldn't find a player to connect to.")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		emit_signal('coinCollected', 30.0)
		queue_free()
		
