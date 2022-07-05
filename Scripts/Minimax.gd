extends Reference

class_name Minimax

static func minimax_decision(state, max_player):
	var result = max_value(state, 0, max_player)
	return result["action"]
	
static func max_value(state, depth, max_player):
	if cutoff_test(state, depth):
		return {"value": Evaluator.eval(state, max_player), "action": null}
		
	var max_value = -INF
	var max_value_action = null
	for item in Successor.calculate_successor(state, max_player):
		var result = min_value(item["state"], depth + 1, max_player)
		if result["value"] > max_value:
			max_value = result["value"]
			max_value_action = item["action"]
			
	return {"value": max_value, "action": max_value_action}
	
static func min_value(state, depth, max_player):
	if cutoff_test(state, depth):
		return {"value": Evaluator.eval(state, max_player), "action": null}
		
	var min_value = +INF
	var min_value_action = null
	for item in Successor.calculate_successor(state, max_player):
		var result = max_value(item["state"], depth + 1, max_player)
		if result["value"] < min_value:
			min_value = result["value"]
			min_value_action = item["action"]
			
	return {"value": min_value, "action": min_value_action}

static func cutoff_test(state, depth):
	if depth >= 1:
		return true
	else:
		return false
