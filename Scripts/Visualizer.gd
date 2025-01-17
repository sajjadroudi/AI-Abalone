extends Node

export var pieces_path : NodePath
onready var pieces = get_node(pieces_path)
var white_piece = preload("res://Scenes/White Piece.tscn")
var black_piece = preload("res://Scenes/Black Piece.tscn")

func _ready():
	History.push(BoardManager.current_board)
	draw_complete_board(BoardManager.current_board)
	
func _process(delta):
	play()

func _input(ev):
	var state = BoardManager.get_current_state()
	
	if CutoffTest.is_terminal(state):
		if Input.is_key_pressed(KEY_LEFT):
			clean_and_draw_board(History.prev())
		elif Input.is_key_pressed(KEY_RIGHT):
			clean_and_draw_board(History.next())
	
func play():
	var state = BoardManager.get_current_state()
	
	if CutoffTest.is_terminal(state):
		return
	
	#var action = Minimax.minimax_decision(state, BoardManager.current_player)
	var action = PruningMinimax.alpha_beta_search(state, BoardManager.current_player, true)
	Move.execute(state, action.cell_number, action.piece, action.cluster_length, action.cluster_direction, action.move_direction, action.status)
	
	update_board(state.board)
	
	BoardManager.turn()
	
func update_board(new_board):
	History.push(new_board)
	BoardManager.update_board(new_board)
	clean_and_draw_board(new_board)
	
func clean_and_draw_board(board):
	for child in pieces.get_children():
		child.queue_free()
	
	draw_complete_board(board)

func draw_complete_board(board):
	var coordinates = Vector3(0, 0, 0)
	for cell_number in range(len(board)):
		if board[cell_number] == BoardManager.WHITE:
			coordinates = get_3d_coordinates(cell_number)
			var piece = white_piece.instance()
			pieces.add_child(piece)
			piece.translation = coordinates
		elif board[cell_number] == BoardManager.BLACK:
			coordinates = get_3d_coordinates(cell_number)
			var piece = black_piece.instance()
			pieces.add_child(piece)
			piece.translation = coordinates

func get_3d_coordinates(cell_number):
	if cell_number >= 0 and cell_number <= 4:
		return Vector3(-0.6 + cell_number * 0.3, 0.01, -1.04)
	elif cell_number >= 5 and cell_number <= 10:
		return Vector3(-0.75 + (cell_number - 5) * 0.3, 0.01, -0.78)
	elif cell_number >= 11 and cell_number <= 17:
		return Vector3(-0.9 + (cell_number - 11) * 0.3, 0.01, -0.52)
	elif cell_number >= 18 and cell_number <= 25:
		return Vector3(-1.05 + (cell_number - 18) * 0.3, 0.001, -0.26)
	elif cell_number >= 26 and cell_number <= 34:
		return Vector3(-1.2 + (cell_number - 26) * 0.3, 0.01, 0)
	elif cell_number >= 35 and cell_number <= 42:
		return Vector3(-1.05 + (cell_number - 35) * 0.3, 0.01, 0.26)
	elif cell_number >= 43 and cell_number <= 49:
		return Vector3(-0.9 + (cell_number - 43) * 0.3, 0.01, 0.52)
	elif cell_number >= 50 and cell_number <= 55:
		return Vector3(-0.75 + (cell_number - 50) * 0.3, 0.01, 0.78)
	else:
		return Vector3(-0.6 + (cell_number - 56) * 0.3, 0.01, 1.04)
	
