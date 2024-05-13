extends CharacterBody2D

const GRAVITY = 250.0
const JUMP_STRENGTH = -125
var speed = 100.0
var can_jump = true
var is_game_over = false


@onready var initial_y = global_position.y

func _physics_process(delta):
	if velocity.y < 300:
		velocity.y += GRAVITY * delta
		
	if not is_game_over:
		velocity.x += speed * delta
	
	if Input.is_action_pressed("jump") and can_jump:
		var jump_velocity = GRAVITY * JUMP_STRENGTH * delta
		velocity.y += clamp(jump_velocity, -300, 300)
		can_jump = false
		%JumpCooldown.start()
	
	var motion = velocity * delta
	
	move_and_collide(motion)
	%Camera2D.global_position.y = initial_y


func _on_jump_cooldown_timeout():
	can_jump = true

func game_over():
	is_game_over = true
	velocity = Vector2.DOWN
	%AnimationPlayer.play("game_over")
