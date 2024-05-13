extends Node2D

var player

func _ready():
	player = preload("res://player/player.tscn").instantiate()
	player.global_position = Vector2(180, 324)
	add_child(player)

	%Boundary.global_position.x = player.global_position.x
	
	%EnemySpawnTimer.start()

func _process(delta):
	%Boundary.global_position.x = player.global_position.x


func _on_enemy_spawn_timer_timeout():
	spawn_enemy()
	%EnemySpawnTimer.start()
	
func spawn_enemy():
	var enemy = preload("res://enemy/enemy.tscn").instantiate()
	enemy.global_position.x = player.global_position.x + 1200
	enemy.global_position.y = randf_range(0.0, 648.0)
	add_child(enemy)
