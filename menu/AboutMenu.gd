extends VBoxContainer

@onready var main_menu: VBoxContainer = %MainMenu
@onready var about_menu: VBoxContainer = %AboutMenu


func _on_about_back_button_pressed():
	about_menu.visible = false
	main_menu.visible = true
