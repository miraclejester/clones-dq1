extends DialogueEvent
class_name InnDialogueEvent

@export var inn_cost: int
@export var greet_dialogue: DialogueEvent
@export var sleep_start_dialogue: DialogueEvent
@export var good_morning_dialogue: DialogueEvent
@export var reject_dialogue: DialogueEvent
@export var not_enough_money_dialogue: DialogueEvent

func execute(window: DialogueWindow, params: Dictionary) -> void:
	var inn_sequence: SequenceDialogueEvent = SequenceDialogueEvent.new()
	
	var greet_custom: PlayCustomDialogueEvent = PlayCustomDialogueEvent.new()
	greet_custom.dialogue = greet_dialogue
	var cost_provider: IntegerFormatVarProvider = IntegerFormatVarProvider.new()
	cost_provider.value = inn_cost
	greet_custom.format_var_providers.append(cost_provider)
	inn_sequence.events.append(greet_custom)
	
	var yes_no: YesNoDecisionDialogueEvent = YesNoDecisionDialogueEvent.new()
	
	var yes_sequence: SequenceDialogueEvent = SequenceDialogueEvent.new()
	var newline_event: NewlineDialogueEvent = NewlineDialogueEvent.new()
	
	if PlayerManager.hero.gold >= inn_cost:
		yes_sequence.events.append(sleep_start_dialogue)
		
		var spend_gold: GrantGoldDialogueEvent = GrantGoldDialogueEvent.new()
		spend_gold.amount = -inn_cost
		yes_sequence.events.append(spend_gold)
		
		yes_sequence.events.append(FadeOutDialogueEvent.new())
		yes_sequence.events.append(newline_event)
		
		var bgm_event: PlayBGMDialogueEvent = PlayBGMDialogueEvent.new()
		bgm_event.bgm_key = "inn"
		bgm_event.wait_for_bgm = true
		yes_sequence.events.append(bgm_event)
		
		var heal_event: ChangeHeroStatsDialogueEvent = ChangeHeroStatsDialogueEvent.new()
		heal_event.key = ChangeHeroStatsDialogueEvent.OperationKey.FULL_HEAL
		yes_sequence.events.append(heal_event)
		
		yes_sequence.events.append(FadeInDialogueEvent.new())
		
		var return_bgm_event: PlayBGMDialogueEvent = PlayBGMDialogueEvent.new()
		return_bgm_event.bgm_key = (params.get("field_map") as FieldMap).map_bgm
		return_bgm_event.wait_for_bgm = false
		yes_sequence.events.append(return_bgm_event)
		
		yes_sequence.events.append(good_morning_dialogue)
	else:
		yes_sequence.events.append(not_enough_money_dialogue)
	
	yes_no.yes_event = yes_sequence
	yes_no.no_event = reject_dialogue
	
	inn_sequence.events.append(yes_no)
	await inn_sequence.execute(window, params)
