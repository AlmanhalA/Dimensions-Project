extends CharacterBody2D

signal health_changed(current_health)

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@export var max_health = 100.0
@export var current_health = 100.0
@export var DOT = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idel")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	

func heal(amount):
	current_health += amount
	current_health = min(current_health, max_health) 
	print("Healed! Current health is: ", current_health)
	health_changed.emit(current_health)

	
func _process(delta):
	current_health -= DOT * delta
	current_health = max(0, current_health)
	health_changed.emit(current_health)
	
	if current_health == 0:
		print("Player has run out of health!")
		get_tree().reload_current_scene()
