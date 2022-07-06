extends Node

var current_board = []
var neighbors = {}
var current_player = BLACK
enum {EMPTY, BLACK, WHITE} # used to represent the board
enum {L, UL, UR, R, DR, DL} # used to represent the directions of neighbors

func _ready():
	init_board()

func init_board():
	var file = File.new()
	file.open("res://adjacency_lists.json", File.READ)
	var raw_data = file.get_as_text()
	var adjacency_lists = parse_json(raw_data)
	file.close() # reading the file that specifies the adjacency lists and converting it to a dictionary
	
	for cell_number in range(61):
		var cell_value = EMPTY
		if (cell_number >= 0 and cell_number <= 10) or (cell_number >= 13 and cell_number <= 15):
			cell_value = BLACK
		elif (cell_number >= 45 and cell_number <= 47) or (cell_number >= 50 and cell_number <= 60):
			cell_value = WHITE
		else:
			cell_value = EMPTY # determining the value of the current board cell
		
		current_board.append(cell_value)
		neighbors[cell_number] = []
		for neighbor in adjacency_lists[str(cell_number)]:
			neighbors[cell_number].append(int(neighbor))
		
func check_cluster(board, cell_number, piece, cluster_length, cluster_direction):
	if board[cell_number] != piece:
		return false
	
	var neighbor = cell_number
	for i in range(1, cluster_length):
		neighbor = neighbors[neighbor][cluster_direction]
		if neighbor == -1:
			return false
		elif board[neighbor] != piece:
			return false
	return true
	
func get_stats(board, cell_number, piece, cluster_length, cluster_direction):
	var num_side_pieces = 0
	var num_opponent_pieces = 0
	var piece_has_space = false
	var opponent_has_space = false
	var is_sandwich = false
	
	var current_point = cell_number
	for i in range(cluster_length + cluster_length):
		if board[current_point] == piece:
			if num_opponent_pieces > 0:
				is_sandwich = true
				break
			else:	
				num_side_pieces += 1
				if neighbors[current_point][cluster_direction] != -1:
					if board[neighbors[current_point][cluster_direction]] == EMPTY and i == cluster_length - 1:
						piece_has_space = true
						break
					
		elif board[current_point] == EMPTY:
			continue
			
		else: # opponent
			if num_side_pieces == cluster_length:
				num_opponent_pieces += 1
			if neighbors[current_point][cluster_direction] != -1:
				if board[neighbors[current_point][cluster_direction]] == EMPTY and piece_has_space == false and num_side_pieces == cluster_length and i != cluster_length + cluster_length - 1:
					opponent_has_space = true
					break
		
		current_point = neighbors[current_point][cluster_direction]
		if current_point == -1:
			break
	return {"number of side pieces" : num_side_pieces, "number of opponent pieces" : num_opponent_pieces, \
			"piece has space" : piece_has_space, "opponent has space" : opponent_has_space, 
			"is sandwich" : is_sandwich}
	
func get_marbles(board, piece):
	var result = []
	for i in range(61):
		if board[i] == piece:
			result.append(i)
	return result
	
func get_enemy(piece):
	if piece == BLACK:
		return WHITE
	else:
		return BLACK

func get_score(board, piece):
	var enemy_piece = get_enemy(piece)
	var count = 0
	for item in board:
		if item == enemy_piece:
			count += 1
	return 14 - count

func turn():
	current_player = get_enemy(current_player)
	
func get_current_state():
	return State.new(
		current_board,
		get_score(current_board, BLACK),
		get_score(current_board, WHITE)
	)
	
func update_board(new_board):
	current_board = new_board

