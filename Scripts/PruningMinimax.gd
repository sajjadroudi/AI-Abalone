extends Reference

class_name PruningMinimax
	
static func alpha_beta_search(state, max_player, enable_forward_pruning = false):
	var result = max_value(state, 0, max_player, -INF, +INF, enable_forward_pruning)
	return result["action"]
	
static func max_value(state, depth, max_player, alpha, beta, enable_forward_pruning):
	if CutoffTest.test(state, depth):
		return {"value": Evaluator.eval(state, max_player), "action": null}
		
	var max_value = -INF
	var max_value_action = null
	for item in Successor.calculate_successor(state, max_player, enable_forward_pruning):
		var result = min_value(item["state"], depth + 1, max_player, alpha, beta, enable_forward_pruning)
		
		if result["value"] > max_value:
			max_value = result["value"]
			max_value_action = item["action"]
			
		if max_value >= beta:
			return {"value": max_value, "action": max_value_action}
			
		alpha = max(alpha, max_value)
			
	return {"value": max_value, "action": max_value_action}
	
static func min_value(state, depth, max_player, alpha, beta, enable_forward_pruning):
	if CutoffTest.test(state, depth):
		return {"value": Evaluator.eval(state, max_player), "action": null}
		
	var min_value = +INF
	var min_value_action = null
	for item in Successor.calculate_successor(state, max_player, enable_forward_pruning):
		var result = max_value(item["state"], depth + 1, max_player, alpha, beta, enable_forward_pruning)
		
		if result["value"] < min_value:
			min_value = result["value"]
			min_value_action = item["action"]
			
		if min_value <= alpha:
			return {"value": min_value, "action": min_value_action}
			
		beta = min(beta, min_value)
			
	return {"value": min_value, "action": min_value_action}
