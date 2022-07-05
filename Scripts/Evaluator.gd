extends Reference

class_name Evaluator

static func eval(state, piece):
	var marbles = BoardManager.get_marbles(state.board, piece)
	var enemy_piece = BoardManager.get_enemy(piece)
	var enemy_marbles = BoardManager.get_marbles(state.board, enemy_piece)
	
	var result = 0
	result += 1000000 * game_result(marbles, enemy_marbles)
	result += 100 * len(marbles)
	result += 5 * center(marbles) # I'm not sure about weight
	result += 1000 * grouping(state, piece)
	result += -1000 * grouping(state, enemy_piece)
	result += 15 * attack(state, piece)
	result += -15 * attack(state, enemy_piece)
	
	return result

static func game_result(marbles, enemy_marbles):
	if len(marbles) == 8:
		return -10000000
	elif len(enemy_marbles) == 8:
		return 10000000
	else:
		return 0
		
static func grouping(state, piece):
	var score = 0
	for cell_number in range(len(state.board)):
		if state.board[cell_number] != piece:
			continue
			
		for cluster_length in range(2, 4):
			for cluster_direction in Move.get_possible_cluster_directions(cluster_length):
				if BoardManager.check_cluster(state.board, cell_number, piece, cluster_length, cluster_direction):
					score += cluster_length
	return score

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
								if legal_status["move is legal"] == false:
									continue
									
								var f1 = BoardManager.neighbors[cell_number][move_direction]
								if f1 == -1:
									continue
									
								var enemy_piece = BoardManager.get_enemy(piece)
									
								var f2 = BoardManager.neighbors[f1][move_direction]
								if f2 == -1:
									continue
								elif f2 == enemy_piece:
									score += 1
								else:
									var f3 = BoardManager.neighbors[f2][move_direction]
									if f3 == enemy_piece:
										score += 1
	return score

static func center(marbles):
	var score = 0
	for marble in marbles:
		if marble in [6, 7, 8, 9, 16, 24, 33, 41, 48, 54, 53, 52, 51, 44, 36, 27, 19, 12]:
			score += 1
		elif marble in [13, 14, 15, 23, 32, 40, 47, 46, 45, 37, 28, 20]:
			score += 2
		elif marble in [21, 22, 31, 39, 38, 29]:
			score += 3
		elif marble == 30:
			score += 4
	return score
