extends Node2D

var player: Player
@onready var count_down_label = %CountDownLabel
@onready var music_player = %MusicPlayer
@onready var game_over_overlay = %GameOverOverlay
@onready var background = %Background

var music_enabled

func _ready():
	start()

func start():
	game_over_overlay.visible = false
	
	music_enabled = Config.config.get_value(
		Config.KEY_SECTION, Config.KEY_MUSIC_ENABLED
	)
	
	player = preload("res://scenes/player.tscn").instantiate()
	player.global_position = Vector2(180, 324)
	player.game_over_happened.connect(game_over)
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
	var enemy = preload("res://scenes/enemy.tscn").instantiate()
	enemy.global_position.x = player.global_position.x + 1200
	enemy.global_position.y = randf_range(0.0, 648.0)
	add_child(enemy)
	
func game_over():
	music_player.stop()
	game_over_overlay.visible = true
	background.game_over()
	

func _on_music_player_finished():
	music_player.play(4)


func _on_play_again_button_pressed():
	get_tree().reload_current_scene()


func _on_return_to_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
