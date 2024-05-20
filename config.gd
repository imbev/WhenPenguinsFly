extends Node

var config: ConfigFile

const FILE_PATH = "user://settings.cfg"
const KEY_SECTION = "settings"

const VERSION = "0.1.0"
const KEY_VERSION = "version"

const DEFAULT_MUSIC_ENABLED = true
const KEY_MUSIC_ENABLED = "music_enabled"

const DEFAULT_SOUND_EFFECTS_ENABLED = true
const KEY_SOUND_EFFECTS_ENABLED = "sound_effects_enabled"

func _ready():
	config = ConfigFile.new()
	config.load(FILE_PATH)
	
	config.set_value(KEY_SECTION, KEY_VERSION, VERSION)
	
	config.set_value(KEY_SECTION, KEY_MUSIC_ENABLED, 
		config.get_value(KEY_SECTION, KEY_MUSIC_ENABLED, 
			DEFAULT_MUSIC_ENABLED)
		)
		
	config.set_value(KEY_SECTION, KEY_SOUND_EFFECTS_ENABLED, 
		config.get_value(KEY_SECTION, KEY_SOUND_EFFECTS_ENABLED, 
			DEFAULT_SOUND_EFFECTS_ENABLED)
		)
		
	config.save(FILE_PATH)
