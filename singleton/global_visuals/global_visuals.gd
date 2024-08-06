extends Node

var shake_step_wait: float = 0.03
var shake_step: int = 2


func player_hurt_shake() -> void:
	var nodes: Array[Node] = [] 
	nodes.assign(get_tree().get_nodes_in_group("player_hurt_shake"))
	for i in range(4):
		await shake_cycle(nodes)


func shake_cycle(nodes: Array[Node]) -> void:
	for node in nodes:
		shake_node_x(node, -shake_step)
	await get_tree().create_timer(shake_step_wait).timeout
	for node in nodes:
		shake_node_x(node, shake_step)
	await get_tree().create_timer(shake_step_wait).timeout
	for node in nodes:
		shake_node_y(node, -shake_step)
	await get_tree().create_timer(shake_step_wait).timeout
	for node in nodes:
		shake_node_y(node, shake_step)
	await get_tree().create_timer(shake_step_wait).timeout


func shake_node_x(node: Node, amount: int) -> void:
	if node is Node2D:
		(node as Node2D).position.x += amount
		return
	if node is CanvasLayer:
		(node as CanvasLayer).offset.x += amount


func shake_node_y(node: Node, amount: int) -> void:
	if node is Node2D:
		(node as Node2D).position.y += amount
		return
	if node is CanvasLayer:
		(node as CanvasLayer).offset.y += amount
