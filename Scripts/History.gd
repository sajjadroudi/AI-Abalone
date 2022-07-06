extends Node

var history = []

func push(board):
	history.append(board)
	
func exists(board):
	return history.find(board) >= 0
