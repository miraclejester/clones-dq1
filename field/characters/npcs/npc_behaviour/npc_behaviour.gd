extends Node
class_name NPCBehaviour

var user: NPCCharacter
var enabled: bool = false


func _ready() -> void:
	deactivate()


func activate() -> void:
	enabled = true


func deactivate() -> void:
	enabled = false


func set_user(u: NPCCharacter) -> void:
	user = u


func on_start() -> void:
	pass


func on_process(_delta: float) -> void:
	pass
