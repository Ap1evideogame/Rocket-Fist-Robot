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

class_name HurtBox
extends Area3D


func _init() -> void:
	# Give the node a collision layer and mask.
	collision_layer = 0
	collision_mask = 32

func _ready() -> void:
	#pass
	#connect("area_entered", self, "_on_area_entered") #doesn't work in 4.0
	connect("area_entered", Callable(self, "_on_area_entered"))

# For when a hitbox touches a hurtbox.
func _on_area_entered(hitbox: HitBox) -> void:
	# If anything other than a hitbox touches it, nothing happens.
	if hitbox == null:
		return
	# If the owner of this hurtbox can be hurt, take damage.
	if owner.has_method("_take_damage"):
		owner._take_damage(hitbox.damage)
