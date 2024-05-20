extends Node2D

var player: Player
@onready var count_down_label = %CountDownLabel
@onready var music_player = %MusicPlayer
var music_enabled

func _ready():
	music_enabled = Config.config.get_value(
		Config.KEY_SECTION, Config.KEY_MUSIC_ENABLED
	)
	
	player = preload("res://player/player.tscn").instantiate()
	player.global_position = Vector2(180, 324)
	add_child(player)

	%Boundary.global_position.x = player.global_position.x
	
	if music_enabled:
		music_player.play()
	

func _physics_process(delta):
	%Boundary.global_position.x = player.global_position.x
	if player.start_seconds_elapsed == 0:
		count_down_label.visible = true
		count_down_label.text = "3"
	if player.start_seconds_elapsed == 1:
		count_down_label.text = "2"
	if player.start_seconds_elapsed == 2:
		count_down_label.text = "1"
	if player.start_seconds_elapsed == 3:
		count_down_label.text = "Start!"
		%EnemySpawnTimer.start()
	if player.start_seconds_elapsed == 4:
		count_down_label.visible = false


func _on_enemy_spawn_timer_timeout():
	spawn_enemy()
	%EnemySpawnTimer.start()
	
func spawn_enemy():
	var enemy = preload("res://enemy/enemy.tscn").instantiate()
	enemy.global_position.x = player.global_position.x + 1200
	enemy.global_position.y = randf_range(0.0, 648.0)
	add_child(enemy)


func _on_music_player_finished():
	music_player.play(4)
