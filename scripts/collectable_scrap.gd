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

var value = 1
var timer_destruction = 1
var collected = 0

var velocity = Vector3(0, 3, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if collected == 1:
		timer_destruction = timer_destruction - delta
		if timer_destruction <= 0:
			queue_free()
		velocity.y = velocity.y - delta * 6
		position = position + velocity * delta


func _on_area_3d_body_entered(_body):
	Signal_Bus.scrap_collected.emit(value)
	collected = 1
	$Collision_Detector/Collision.queue_free()
	if $Sound_Collect.playing == false:
		$Sound_Collect.pitch_scale = randf_range(0.8, 1.25)
		$Sound_Collect.play()
