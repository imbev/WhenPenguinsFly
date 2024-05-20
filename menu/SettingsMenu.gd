extends VBoxContainer

@onready var main_menu: VBoxContainer = %MainMenu
@onready var settings_menu: VBoxContainer = %SettingsMenu
@onready var music_enabled_button = %MusicEnabledButton
@onready var sound_effects_enabled_button = %SoundEffectsEnabledButton

func _ready():
	music_enabled_button.button_pressed = Config.config.get_value(
		Config.KEY_SECTION, Config.KEY_MUSIC_ENABLED
	)
	sound_effects_enabled_button.button_pressed = Config.config.get_value(
		Config.KEY_SECTION, Config.KEY_SOUND_EFFECTS_ENABLED
	)

func _on_settings_back_button_pressed():
	settings_menu.visible = false
	main_menu.visible = true
	
func _on_music_enabled_button_toggled(toggled_on):
	Config.config.set_value(Config.KEY_SECTION, Config.KEY_MUSIC_ENABLED, toggled_on)
	Config.config.save(Config.FILE_PATH)

func _on_sound_effects_enabled_button_toggled(toggled_on):
	Config.config.set_value(Config.KEY_SECTION, Config.KEY_SOUND_EFFECTS_ENABLED, toggled_on)
	Config.config.save(Config.FILE_PATH)
