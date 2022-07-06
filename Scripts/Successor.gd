extends Reference

class_name Successor

static func calculate_successor(state, piece, enable_forward_pruning = false): # calculates all the successor states of a state, given a piece
	var result = []
	for cell_number in range(len(state.board)):
		if state.board[cell_number] == piece:
			for cluster_length in range(1, 4):
				for cluster_direction in Move.get_possible_cluster_directions(cluster_length):
					if BoardManager.check_cluster(state.board, cell_number, piece, cluster_length, cluster_direction):
						for move_direction in Move.get_possible_move_directions(cluster_length, cluster_direction):
							var legal_status = []
							legal_status = Move.is_legal(state, cell_number, piece, cluster_length, cluster_direction, move_direction)
							if legal_status["move is legal"] == true:
								var new_state = State.new(state.board, state.black_score, state.white_score)
								Move.execute(new_state, cell_number, piece, cluster_length, cluster_direction, move_direction, legal_status)
								var item = {
									"action": Action.new(cell_number, piece, cluster_length, cluster_direction, move_direction, legal_status),
									"state": new_state
								}
								result.append(item)
								
	
	if(enable_forward_pruning):
		# Assign a score to each state
		for item in result:
			item["score"] = Evaluator.eval(item["state"], piece)
		
		result.sort_custom(CustomComparator, "sort_desc")
			
		# Cut off bad states
		var end = 1
		for i in range(1, len(result)):
			if result[i]["score"] < 0:
				end = i
				break
		result = result.slice(0, end)		
	
	return result

class CustomComparator:
	static func sort_desc(first, second):
		return first["score"] > second["score"]
			
