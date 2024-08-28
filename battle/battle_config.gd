extends Resource
class_name BattleConfig

@export var field_bgm: String = ""
@export var battle_bg: Texture2D
@export var is_dark: bool
@export var victory_event: DialogueEvent
@export var run_event: DialogueEvent
@export var wait_for_end_dialogue: bool = true
