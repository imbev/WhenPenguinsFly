extends Node2D

@onready var black_rect = %BlackRect
@onready var darken_timer = %DarkenTimer

func game_over():
	darken_timer.start()


func _on_darken_timer_timeout():
	black_rect.color.a += 0.01
	darken_timer.start()
