extends Resource
class_name EncounterData

@export var enemy: EnemyData
@export var pre_battle_event: DialogueEvent
@export var intro_dialogue: PlayParagraphDialogueEvent
@export var bgm_key: String
@export var reprise_key: String
@export var show_spoils: bool = true
@export var use_dragonlord_layer: bool = false
@export var shake_on_hit: bool = true
@export var after_victory_event: DialogueEvent
