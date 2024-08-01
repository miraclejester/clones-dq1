extends Node

enum DialogueID {
	BattleCommand,
	BattleEnemyDefeated,
	BattleEnemyHurt,
	BattleExpGain,
	BattleGoldGain,
	BattleMiss,
	BattleStart,
	BattleUnitAttacks,
	BattlePlayerHurt,
	BattleExcellentMove,
	BattleEnemyDodge,
	BattlePlayerDeath,
	BattleEnemyFirst,
	BattleEnemyNoDamage,
	BattleAttemptRun,
	BattleRunFailure,
	BattleNoSpells,
	BattleChantSpell,
	BattleLowMP,
	BattleSpellWillNotWork,
	Newline
}

const dialogue_dict: Dictionary = {
	DialogueID.BattleCommand : preload("res://battle/data/dialogues/battle_dialogue_command.tres"),
	DialogueID.BattleEnemyDefeated : preload("res://battle/data/dialogues/battle_dialogue_enemy_defeated.tres"),
	DialogueID.BattleEnemyHurt : preload("res://battle/data/dialogues/battle_dialogue_enemy_hurt.tres"),
	DialogueID.BattleExpGain : preload("res://battle/data/dialogues/battle_dialogue_exp_gain.tres"),
	DialogueID.BattleGoldGain : preload("res://battle/data/dialogues/battle_dialogue_gold_gain.tres"),
	DialogueID.BattleMiss : preload("res://battle/data/dialogues/battle_dialogue_miss.tres"),
	DialogueID.BattleStart : preload("res://battle/data/dialogues/battle_dialogue_start.tres"),
	DialogueID.BattleUnitAttacks : preload("res://battle/data/dialogues/battle_dialogue_unit_attacks.tres"),
	DialogueID.BattlePlayerHurt : preload("res://battle/data/dialogues/battle_dialogue_player_hurt.tres"),
	DialogueID.BattleExcellentMove : preload("res://battle/data/dialogues/battle_dialogue_excellent_move.tres"),
	DialogueID.BattleEnemyDodge : preload("res://battle/data/dialogues/battle_dialogue_enemy_dodge.tres"),
	DialogueID.BattlePlayerDeath : preload("res://battle/data/dialogues/battle_dialogue_player_death.tres"),
	DialogueID.BattleEnemyFirst : preload("res://battle/data/dialogues/battle_dialogue_enemy_first.tres"),
	DialogueID.BattleEnemyNoDamage : preload("res://battle/data/dialogues/battle_dialogue_enemy_no_damage.tres"),
	DialogueID.BattleAttemptRun : preload("res://battle/data/dialogues/battle_dialogue_attempt_run.tres"),
	DialogueID.BattleRunFailure : preload("res://battle/data/dialogues/battle_dialogue_run_failure.tres"),
	DialogueID.BattleNoSpells : preload("res://battle/data/dialogues/battle_dialogue_no_spells.tres"),
	DialogueID.BattleChantSpell : preload("res://battle/data/dialogues/battle_dialogue_chant_spell.tres"),
	DialogueID.BattleLowMP : preload("res://battle/data/dialogues/battle_dialogue_low_mp.tres"),
	DialogueID.BattleSpellWillNotWork : preload("res://battle/data/dialogues/battle_dialogue_spell_will_not_work.tres"),
	DialogueID.Newline : preload("res://ui/data/dialogue_newline.tres")
}

func get_dialogue(id: DialogueID) -> DialogueEvent:
	return dialogue_dict.get(id)
