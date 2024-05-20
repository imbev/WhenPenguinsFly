extends VBoxContainer

@onready var main_menu: VBoxContainer = %MainMenu
@onready var about_menu: VBoxContainer = %AboutMenu
@onready var version_label: Label = %VersionLabel
func _ready():
	version_label.text = "Version " + Config.VERSION

func _on_about_back_button_pressed():
	about_menu.visible = false
	main_menu.visible = true
