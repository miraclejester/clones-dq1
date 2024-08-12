extends Node

var stack: Array[MenuStackEntry] = []

func push_stack(m: Control, a: Callable, d: Callable, on_cancel: Callable = func(): pass) -> void:
	if stack.size() > 0:
		stack[0].deactivate_method.call()
	var e: MenuStackEntry = MenuStackEntry.new()
	e.menu = m
	e.activate_method = a
	e.deactivate_method = d
	e.cancel_method = on_cancel
	stack.push_front(e)
	
	if m is UIMenu:
		m.cancelled.connect(on_cancel)
	
	await get_tree().process_frame
	e.activate_method.call()


func pop_stack() -> void:
	if stack.size() == 0:
		return
	if stack[0].menu is UIMenu:
		(stack[0].menu as UIMenu).cancelled.disconnect(stack[0].cancel_method)
	stack[0].deactivate_method.call()
	stack.pop_front()
	await get_tree().process_frame
	if stack.size() > 0:
		stack[0].activate_method.call()


func clear_menu_stack() -> void:
	while stack.size() > 0:
		await pop_stack()
