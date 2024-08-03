extends Resource
class_name ItemData

@export var item_name: String
@export var item_id: int
@export var target_type: SpellData.TargetType
@export var consumable: bool
@export var use_dialogue: DialogueEvent
@export var spell_effects: Array[SpellEffect]
