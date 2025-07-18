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

extends Camera3D

var debug = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Signal_Bus.debug_toggled.connect(_on_Signal_Bus_debug_toggled)
	debug = Signal_Bus.debug_mode_current
	if debug:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	Signal_Bus.scrap_collected.connect(_on_Signal_Bus_Scrap_Collected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Create variables.
	var focuspoint_player = Signal_Bus.player_position + Vector3(0, 2.1, 0)
	var distance_to_player = (position - focuspoint_player).length()
	
	var camera_inputmovement
	
	# Controller camera movement.
	if Input.get_vector("camera_move_left", "camera_move_right", "camera_move_up", "camera_move_down"):
		camera_inputmovement = Input.get_vector("camera_move_left", "camera_move_right", "camera_move_up", "camera_move_down")
		translate_object_local(Vector3(-camera_inputmovement.x, camera_inputmovement.y, 0) * delta * 3 * distance_to_player)
	
	# Mouse camera movement.
	else:
		camera_inputmovement = Signal_Bus.camera_inputmovement
		translate_object_local(camera_inputmovement * 0.002 * distance_to_player)
	
	position = focuspoint_player + ((position - focuspoint_player).normalized() * distance_to_player)
	
	# Move camera toward player.
	var restpoint_player = focuspoint_player + (position - focuspoint_player).normalized() * 5
	position = position.lerp(restpoint_player, delta * 2)
	look_at(focuspoint_player, transform.basis.y)
	
	# Correct roll.
	rotation.z = rotation.z * 0.9
	Signal_Bus.camera_rotation = rotation
	
	# Keep camera away from top/bottom of player.
	var position_horizontal = position
	position_horizontal.y = 0
	var focuspoint_player_horizontal = focuspoint_player
	focuspoint_player_horizontal.y = 0
	if (position_horizontal - focuspoint_player_horizontal).length() < 2.5:
		position_horizontal = focuspoint_player_horizontal + (position_horizontal - focuspoint_player_horizontal).normalized() * 2.5
		position.x = (position.x * 4 + position_horizontal.x) / 5
		position.z = (position.z * 4 + position_horizontal.z) / 5
	
	# Place camera in front of walls so you can see.
	$RayCast3D_Walls.position = Vector3(0, 0, -(focuspoint_player - position).length())
	$"RayCast3D_Walls/start visualizer".position = Vector3()
	
	$RayCast3D_Walls.target_position = Vector3(0, 0, (focuspoint_player - position).length() + 0.35)
	$"RayCast3D_Walls/target visualizer".position = $RayCast3D_Walls.target_position
	
	$RayCast3D_Walls.force_raycast_update()
	if $RayCast3D_Walls.is_colliding():
		position = $RayCast3D_Walls.get_collision_point() + (focuspoint_player - position).normalized() * 0.35
	
	# Deal with UI stuff.
	if $GUI/Label_Scrap.visible_ratio < 1:
		$GUI/Label_Scrap.visible_ratio = $GUI/Label_Scrap.visible_ratio + delta * 4

# Debug mode has been toggled. Straightforward.
func _on_Signal_Bus_debug_toggled(debug_mode):
	debug = debug_mode
	if debug:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Change amount of scrap shown by the label
func _on_Signal_Bus_Scrap_Collected(scrap_value):
	Signal_Bus.scrap_amount = Signal_Bus.scrap_amount + scrap_value
	$GUI/Label_Scrap.text = "Scrap: " + var_to_str(Signal_Bus.scrap_amount)
	$GUI/Label_Scrap.visible_ratio = 0
