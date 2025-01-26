extends Node

@export var bubble_count = 2

@export var current_level: int = 1

func add_bubble():
	bubble_count += 1
	if bubble_count > 3:
		bubble_count = 3

func pop_bubble():
	bubble_count -= 1
	if bubble_count < 1:
		bubble_count = 1
		
func increment_level():
	current_level += 1
	print("Nivel actual: ", current_level)

func reset_level():
	current_level = 1
