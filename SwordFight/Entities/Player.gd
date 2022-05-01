extends KinematicBody2D

const UP = Vector2(0, -1)

var velocity = Vector2()
var basic_animation = true
var move_direction = 1
var look_direction = 1

export var gravity = 800
export var jump_strenght = -500

var current_speed = 0
export var run_speed = 100


onready var character_anim = $CharacterRig/AnimationPlayer

func _physics_process(delta):
	
	if basic_animation == true:
		animation()
	
	velocity = move_and_slide(velocity, UP)
	velocity.y += gravity * delta
	
	var move_direction = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	velocity.x = lerp(velocity.x, run_speed * move_direction, 1)
	if move_direction != 0:
		$CharacterRig.scale.x = move_direction
		look_direction = move_direction
	
	if Input.is_action_just_pressed("attack1"):
		basic_animation = false
		character_anim.play("attack1")
	if character_anim.current_animation == "attack1":
		velocity.x += 50 * look_direction
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_strenght
	
func animation():
	
	if velocity.x != 0:
		character_anim.play("run")
	if velocity.x == 0:
		character_anim.play("idle")


func _on_AnimationPlayer_animation_finished(anim_name):
	basic_animation = true
