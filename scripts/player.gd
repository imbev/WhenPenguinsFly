extends CharacterBody2D

class_name Player

const GRAVITY = 200.0
const JUMP_STRENGTH = -100
var speed = 75.0
var can_jump = true
var is_game_over = false
var start_seconds_elapsed = 0

@onready var sound_effects_player = %SoundEffectsPlayer
@onready var start_timer = %StartTimer
@onready var initial_y = global_position.y

var sound_effects_enabled

signal game_over_happened

func _ready():
	start_timer.start()
	%AnimationPlayer.play("fly")
	sound_effects_enabled = Config.config.get_value(
		Config.KEY_SECTION, Config.KEY_SOUND_EFFECTS_ENABLED
	)

func _physics_process(delta):
	if start_seconds_elapsed < 4:
		return
	
	if velocity.y < 300:
		velocity.y += GRAVITY * delta
		
	if not is_game_over:
		velocity.x += speed * delta
	
	if Input.is_action_pressed("jump") and can_jump:
		var jump_velocity = GRAVITY * JUMP_STRENGTH * delta
		velocity.y += clamp(jump_velocity, -300, 300)
		can_jump = false
		%JumpCooldown.start()
		if sound_effects_enabled:
			sound_effects_player.stream = preload("res://assets/sound_effects/data_sounds_pop.ogg")
			sound_effects_player.volume_db = -10.0
			sound_effects_player.play()
	
	var motion = velocity * delta
	
	move_and_collide(motion)
	%Camera2D.global_position.y = initial_y


func _on_jump_cooldown_timeout():
	if not is_game_over:
		can_jump = true

func game_over():
	if is_game_over:
		return
	is_game_over = true
	velocity = Vector2.DOWN
	%Sprite2D.show()
	%AnimatedSprite2D.hide()
	%AnimationPlayer.play("game_over")
	if sound_effects_enabled:
		sound_effects_player.stream = preload("res://assets/sound_effects/data_sounds_hurt.ogg")
		sound_effects_player.volume_db = 2.5
		sound_effects_player.play()
	game_over_happened.emit()


func _on_start_timer_timeout():
	start_seconds_elapsed += 1
	if start_seconds_elapsed < 4:
		start_timer.start()
