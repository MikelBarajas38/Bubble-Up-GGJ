extends Node

@export var bubble_count = 2

func add_bubble():
	bubble_count += 1
	if bubble_count > 3:
		bubble_count = 3

func pop_bubble():
	bubble_count -= 1
	if bubble_count < 1:
		bubble_count = 1
