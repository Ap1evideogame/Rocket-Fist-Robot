#Rocket Fist Robot is a 3D platformer with Metroidvania elements and combat.
#Copyright (C) 2025 Richard Engel
#
#This file is part of Rocket Fist Robot
#
#Rocket Fist Robot is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#Rocket Fist Robot is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#I (Richard Engel) can be reached online at ap1evideogame@gmail.com

extends CharacterBody3D

# Declare variables.
# Constants and debug variables.
const SPEED = 5.0
const JUMP_VELOCITY = 6.25
var debug = 0
# Regular variables.
var speed_max = 5.0
var boosting = false
var boosting_sound = false
@export var boost_amount = 2
var floor_touched = true
# Timer variables.
var timer_downboost_delay = 0.0
@export var timer_downboost_delay_max = 0.25
var timer_footstep = 1
var timer_cyotetime = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	Signal_Bus.debug_toggled.connect(_on_Signal_Bus_debug_toggled)
	debug = Signal_Bus.debug_mode_current


func _process(delta):
	
	# Reset boosting_sound.
	boosting_sound = false
	
	# Self destruct and respawn.
	if Input.is_action_just_pressed("character_action_self_destruct"):#add controller button to "self_destruct" later
		_respawn()
	
	# Death by enemy!
	#if you collide with an enemy attack:
		#_respawn()
	
	# Add the gravity.
	timer_downboost_delay -= delta
	if not is_on_floor():
		floor_touched = false
		# Handle Boost_Down
		if Input.is_action_just_pressed("character_move_down"):
			# The player should be able to boost down whenever they initiate the action.
			# However, there should be a brief delay after a jump, when they cant boost down.
			timer_downboost_delay = 0.0
		if Input.is_action_pressed("character_move_down") and timer_downboost_delay <= 0.0:
			velocity.y -= (gravity * delta * 4) + (delta * 40)
			boosting_sound = true
		else:
			velocity.y -= gravity * delta
	else:
		# Landing on the floor.
		if floor_touched == false:
			$Sound_Landing.play()
		
		floor_touched = true
		timer_cyotetime = 0.1
		
	# Handle jump.
	timer_cyotetime = timer_cyotetime - delta
	if Input.is_action_just_pressed("character_move_up"):
		if is_on_floor() or timer_cyotetime > 0:
			$Sound_Jump.play()
			velocity.y = JUMP_VELOCITY
			timer_cyotetime = 0
			timer_downboost_delay = timer_downboost_delay_max
	
	# Handle footstep sounds
	if is_on_floor() and velocity and !boosting:
		timer_footstep = timer_footstep - delta * velocity.length() * 0.75
		if timer_footstep <= 0:
			timer_footstep = 1
			$Sound_Footstep.playing = true

	# Handle initial Boost_Horizontal.
	if Input.is_action_just_pressed("character_action_boost"):
		$Sound_Boost.play()
		if debug:
			boost_amount = 20
		else:
			boost_amount = 2
	
	# Handle held Boost_Horizontal.
	if Input.is_action_pressed("character_action_boost"):
		boosting = true
		boosting = 1
		boosting_sound = true
	else:
		boosting = false
		boosting = 0
	
	# Handle Boost_Up.
	if Input.is_action_pressed("character_move_up") and velocity.y < 1 + (debug * 19):
		velocity.y = 1 + (debug * 19)
		boosting_sound = true
	
	# Handle attack.
	if Input.is_action_just_pressed("character_action_attack"):
		$CollisionShape3D/Animation_Player_Fist_Right_Throw.play("Animation_Fist_Right_Throw")
		$Sound_punch.play()
		Input.start_joy_vibration(0, 0.2, 0.0, 0.15)
		# For air combos.
		if floor_touched == false:
			velocity.y = 3
	
	
	# Handle unhandled sounds.
	if boosting_sound:
		if !$Sound_Boosting.playing:
			$Sound_Boosting.play()
			#Input.start_joy_vibration(0, 1, 1)#try it using the Xbox controller?
	else:
		if $Sound_Boosting.playing:
			$Sound_Boosting.stop()
			#Input.stop_joy_vibration(0)


	# Get the input direction.
	var input_direction = Input.get_vector("character_move_left", "character_move_right", "character_move_forward", "character_move_backward")
	var direction = Vector3(input_direction.x, 0, input_direction.y)
	# make direction relative to the camera
	direction = direction.rotated(Vector3.UP, Signal_Bus.camera_rotation.y)
	direction = direction.rotated(Vector3.UP, Signal_Bus.camera_rotation.z)
	
	# calculate character movement.
	if direction:
		# set rotation
		transform = Transform3D(direction.rotated(Vector3.UP, deg_to_rad(-90)).normalized(), Vector3.UP, -direction.normalized(), position)
		
		# Handle acceleration.
		velocity.x = velocity.x + (direction.x * (SPEED + SPEED * (boost_amount * boosting))) * 0.1
		velocity.z = velocity.z + (direction.z * (SPEED + SPEED * (boost_amount * boosting))) * 0.1
		
		# Preventing the player from going over the max speed.
		var velocity_horizontal_new = Vector3(velocity.x, 0, velocity.z)
		
		if velocity_horizontal_new.length() > speed_max * ((debug * 19 + 1) * boosting + 1):
			velocity_horizontal_new = velocity_horizontal_new.normalized() * speed_max * ((debug * 19 + 1) * boosting + 1)
			velocity.x = velocity_horizontal_new.x
			velocity.z = velocity_horizontal_new.z
	else:
		# Handle deceleration.
		var velocity_horizontal_decelerated = velocity
		velocity_horizontal_decelerated.y = 0
		velocity_horizontal_decelerated = velocity.normalized() * move_toward(velocity.length(), 0, SPEED * 0.25)
		velocity.x = velocity_horizontal_decelerated.x
		velocity.z = velocity_horizontal_decelerated.z
	move_and_slide()
	Signal_Bus.player_position = position

# Handle Respawn
func _respawn():#In future, put a robot dispenser in the brackets, use that for position.
	position = Vector3(0, 0, 0)

# Toggle debug mode.
func _on_Signal_Bus_debug_toggled(debug_mode):
	debug = debug_mode
