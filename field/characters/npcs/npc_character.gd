extends FieldCharacter
class_name NPCCharacter

@export var talk_event: DialogueEvent
@export var use_endgame_dialogue: bool = true

@onready var behaviours: Node = %Behaviours


func _ready() -> void:
	super()


func activate_events() -> void:
	for child in behaviours.get_children():
		var b: NPCBehaviour = child as NPCBehaviour
		b.set_user(self)
		b.activate()
		b.on_start()


func _process(delta: float) -> void:
	for child in behaviours.get_children():
		var b: NPCBehaviour = child as NPCBehaviour
		if b.enabled:
			b.on_process(delta)
