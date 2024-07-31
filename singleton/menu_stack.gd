extends Node

var stack: Array[MenuStackEntry] = []

func push_stack(m: Control, a: Callable, d: Callable) -> void:
	if stack.size() > 0:
		stack[0].deactivate_method.call()
	var e: MenuStackEntry = MenuStackEntry.new()
	e.menu = m
	e.activate_method = a
	e.deactivate_method = d
	stack.push_front(e)
	await get_tree().process_frame
	e.activate_method.call()


func pop_stack() -> void:
	if stack.size() == 0:
		return
	stack[0].deactivate_method.call()
	stack.pop_front()
	if stack.size() > 0:
		await get_tree().process_frame
		stack[0].activate_method.call()
