extends Reference

class_name Action

var cell_number = 0
var piece = 0
var cluster_length = 0
var cluster_direction = 0
var move_direction = 0
var status = {}

func _init(cell_number, piece, cluster_length, cluster_direction, move_direction, status):
	self.cell_number = cell_number
	self.piece = piece
	self.cluster_length = cluster_length
	self.cluster_direction = cluster_direction
	self.move_direction = move_direction
	self.status = status
