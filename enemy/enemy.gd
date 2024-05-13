extends Area2D


func _ready():
	%DespawnTimer.start()


func _on_body_entered(body):
	if body.name == "Player":
		body.game_over()


func _on_despawn_timer_timeout():
	queue_free()
