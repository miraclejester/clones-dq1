extends Node

enum DialogueID {
	BattleCommand,
	BattleEnemyDefeated,
	BattleEnemyHurt,
	BattleExpGain,
	BattleGoldGain,
	BattleMiss,
	BattleStart,
	BattleUnitAttacks
}

const dialogue_dict: Dictionary = {
	DialogueID.BattleCommand : preload("res://battle/data/dialogues/battle_dialogue_command.tres"),
	DialogueID.BattleEnemyDefeated : preload("res://battle/data/dialogues/battle_dialogue_enemy_defeated.tres"),
	DialogueID.BattleEnemyHurt : preload("res://battle/data/dialogues/battle_dialogue_enemy_hurt.tres"),
	DialogueID.BattleExpGain : preload("res://battle/data/dialogues/battle_dialogue_exp_gain.tres"),
	DialogueID.BattleGoldGain : preload("res://battle/data/dialogues/battle_dialogue_gold_gain.tres"),
	DialogueID.BattleMiss : preload("res://battle/data/dialogues/battle_dialogue_miss.tres"),
	DialogueID.BattleStart : preload("res://battle/data/dialogues/battle_dialogue_start.tres"),
	DialogueID.BattleUnitAttacks : preload("res://battle/data/dialogues/battle_dialogue_unit_attacks.tres")
}

func get_dialogue(id: DialogueID) -> DialogueEvent:
	return dialogue_dict.get(id)
