extends Control
class_name Credits

func _ready() -> void:
	for header in get_children():
		var h: CreditsHeader = header as CreditsHeader
		await h.start()
