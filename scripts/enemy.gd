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


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var movement_timer = 0.0
var movement_random = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
var direction = Vector3()


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("character_move_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	movement_timer = movement_timer - delta
	if movement_timer <= 0:
		movement_timer = randf_range(0.1, 1.2)
		movement_random = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
	var input_dir = Vector3()
	if (Signal_Bus.player_position - position - get_parent_node_3d().position).length() < 25:
		input_dir = Signal_Bus.player_position - position - get_parent_node_3d().position
	
	direction = Vector3(input_dir.x, 0, input_dir.z).normalized() + movement_random * 1.1
	direction = direction.normalized()
	if direction:
		transform = Transform3D(direction.rotated(Vector3.UP, deg_to_rad(-90)).normalized(), Vector3.UP, -direction, position)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

	move_and_slide()

func _take_damage(_amount: float) -> void:
	queue_free()
