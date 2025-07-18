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

extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	# Exit game.
	if Input.is_action_just_pressed("menu_pause"):
		get_tree().quit()
	
	# Debug restart.
	if Input.is_action_just_pressed("debug_restart"):
		if Signal_Bus.debug_mode_current:
			get_tree().reload_current_scene()
	
	# Debug mode toggle.
	if Input.is_action_just_pressed("debug_mouse_mode"):
		if Signal_Bus.debug_mode_current:
			Signal_Bus.debug_mode_current = 0
		else:
			Signal_Bus.debug_mode_current = 1
		Signal_Bus.debug_toggled.emit(Signal_Bus.debug_mode_current)
	
	# Mute music toggle.
	if Input.is_action_just_pressed("character_action_process"):
		if Signal_Bus.debug_music_mute:
			Signal_Bus.debug_music_mute = false
		else:
			Signal_Bus.debug_music_mute = true
