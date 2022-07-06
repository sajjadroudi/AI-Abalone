extends Node

func test(state, depth):
	if depth >= 1 or is_terminal(state):
		return true
	else:
		return false

func is_terminal(state):
	return state.black_score == 6 or state.white_score == 6
	
