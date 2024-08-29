extends MarginContainer
class_name CreditsHeader

@export var duration: float = 5
@export var fade_out: bool = true

func start() -> void:
	visible = true
	await GlobalVisuals.fade_in()
	await get_tree().create_timer(duration).timeout
	if fade_out:
		await GlobalVisuals.fade_out()
		visible = false
	
