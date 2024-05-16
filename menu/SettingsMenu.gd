extends VBoxContainer

@onready var main_menu: VBoxContainer = %MainMenu
@onready var settings_menu: VBoxContainer = %SettingsMenu

func _on_back_button_pressed():
	main_menu.visible = true
	settings_menu.visible = false
