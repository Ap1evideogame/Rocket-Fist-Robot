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

class_name HitBox
extends Area3D

# Anything with a hitbox will deal some amount of damage.
@export var damage = 10.0
# Some attacks may give virus.
@export var virus = 0.0


func _init() -> void:
	# Collision layers use binary to identify which layer it is.
	# No layers is 0. Layer 1 is 1, layer 2 is 2, 3 is 4, 4 is 8, 5 is 16, 6 is 32, etc.
	# To have multiple layers active, add them up like so: layer 4 and 5 is 8 + 16.
	collision_layer = 32 # Layer 32 is "Hitbox".
	collision_mask = 0 # 0 means there is no layer active.
