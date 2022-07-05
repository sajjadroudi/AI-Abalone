extends Reference

class_name Evaluator

static func eval(state, piece):
	var marbles = BoardManager.get_marbles(state.board, piece)
	var enemy_piece = BoardManager.get_enemy(piece)
	var enemy_marbles = BoardManager.get_marbles(state.board, enemy_piece)
	
	var result = 0
	result += 1000000 * game_result(marbles, enemy_marbles)
	result += 5 * len(marbles)
	result += 15 * attack(state, piece)
	result *= -15 * attack(state, enemy_piece)
	
	return result

static func game_result(marbles, enemy_marbles):
	if len(marbles) == 8:
		return -10000000
	elif len(enemy_marbles) == 8:
		return 10000000
	else:
		return 0

static func attack(state, piece):
	var score = 0
	for cell_number in range(len(state.board)):
		if state.board[cell_number] == piece:
			for cluster_length in range(2, 4):
				for cluster_direction in Move.get_possible_cluster_directions(cluster_length):
					if BoardManager.check_cluster(state.board, cell_number, piece, cluster_length, cluster_direction):
						for move_direction in Move.get_possible_move_directions(cluster_length, cluster_direction):
							var direction_difference = cluster_direction - move_direction
							if direction_difference == 0 or direction_difference == 3:
								var legal_status = Move.is_directional_move_legal(state, cell_number, piece, cluster_length, cluster_direction, move_direction)
								var f1 = BoardManager.neighbors[cell_number][move_direction]
								var f2 = BoardManager.neighbors[f1][move_direction]
								var f3 = BoardManager.neighbors[f2][move_direction]
								var enemy_piece = BoardManager.get_enemy(piece)
								if legal_status["move is legal"] == true and (f2 == enemy_piece or f3 == enemy_piece):
									score += 1
	return score
