extends VBoxContainer

@onready var main_menu: VBoxContainer = %MainMenu
@onready var about_menu: VBoxContainer = %AboutMenu
@onready var settings_menu: VBoxContainer = %SettingsMenu

func _ready():
	main_menu.visible = true
	about_menu.visible = false
	settings_menu.visible = false

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
func _on_about_button_pressed():
	about_menu.visible = true
	main_menu.visible = false

func _on_settings_button_pressed():
	settings_menu.visible = true
	main_menu.visible = false


func _on_exit_button_pressed():
	get_tree().quit()
