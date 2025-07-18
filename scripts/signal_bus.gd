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

extends Node

# Debug variables.
signal debug_toggled(debug_mode)
var debug_mode_current = 0
var debug_music_mute = 0

# Camera variables
var camera_inputmovement = Vector3()
var camera_inputmovement_timer = 0.0

var camera_rotation = Vector3()

# Player variables
var player_position = Vector3()

# Emitted to tell the UI when and how much scrap is collected.
signal scrap_collected(scrap_value)
var scrap_amount = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	# Stop the camera movemnt from the mouse when it's not moving.
	if camera_inputmovement_timer > 0:
		camera_inputmovement_timer = camera_inputmovement_timer - 1
	else:
		camera_inputmovement = Vector3()
		

func _input(event):
	
	# handle mouse movement
	if event is InputEventMouseMotion:
		camera_inputmovement.x = -event.relative.x
		camera_inputmovement.y = event.relative.y
		camera_inputmovement_timer = 1
