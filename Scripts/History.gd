extends Node

var history = []

var current_pos = -1

func push(board):
	history.append(board)
	current_pos += 1
	
func exists(board):
	return history.find(board) >= 0

func next():
	current_pos = min(current_pos + 1, len(history) - 1)
	return history[current_pos]
	
func prev():
	current_pos = max(current_pos - 1, 0)
	return history[current_pos]
