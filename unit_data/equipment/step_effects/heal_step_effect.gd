extends StepEffect
class_name HealStepEffect

@export var num_steps: int
@export var heal_amount: int

func on_step(step_amount: int) -> void:
	if step_amount % num_steps == 0:
		PlayerManager.hero.stats.modify_stat(UnitStats.StatKey.HP, heal_amount)
