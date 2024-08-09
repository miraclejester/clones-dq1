extends RefCounted
class_name ParallelPromise

signal all_completed

var queue: Array[Callable] = []
var total: int = 0
var completed: int = 0

func _init(q: Array[Callable]) -> void:
	queue.assign(q)
	total = queue.size()
	completed = 0


func run_all() -> void:
	for routine in queue:
		run(routine)
	await all_completed


func run(routine: Callable) -> void:
	await routine.call()
	on_routine_completed()


func on_routine_completed() -> void:
	completed += 1
	if completed >= total:
		all_completed.emit()
