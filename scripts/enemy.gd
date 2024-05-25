extends Area2D

func _ready():
	
	var textures = [
		preload("res://assets/images/krosh_corrupt_main.png"),
		preload("res://assets/images/krosh_ice_main.png"),
		preload("res://assets/images/krosh_rock_main.png")
	]
	var texture_index = randi_range(0, 2)
	%Sprite2D.texture = textures[texture_index]
	
	%DespawnTimer.start()


func _on_body_entered(body):
	if body.name == "Player":
		body.game_over()


func _on_despawn_timer_timeout():
	queue_free()
