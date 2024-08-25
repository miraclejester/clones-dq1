extends MapEvent
class_name KeyItemChestEvent

@export var important_item_found_dialogue: PlayParagraphDialogueEvent
@export var key_item: ItemData
@export var map_key: String
@export var data_key: String
@export var post_take_event: DialogueEvent

func _ready():
	make_take_event()
	make_map_start_event()

func make_take_event() -> void:
	var take_sequence: SequenceDialogueEvent = SequenceDialogueEvent.new()
	
	#1. Play Chest SFX
	var chest_sfx: PlaySFXDialogueEvent = PlaySFXDialogueEvent.new()
	chest_sfx.sfx_key = "treasure"
	take_sequence.events.append(chest_sfx)
	
	#2. Play important item found dialogue
	var important_dialogue: PlayCustomParagraphEvent = PlayCustomParagraphEvent.new()
	important_dialogue.dialogue = important_item_found_dialogue
	important_dialogue.format_var_providers.append(PlayerNameFormatVarProvider.new())
	var item_name_provider: ItemNameFormatVarProvider = ItemNameFormatVarProvider.new()
	item_name_provider.item = key_item
	important_dialogue.format_var_providers.append(item_name_provider)
	take_sequence.events.append(important_dialogue)
	
	#3. Branch. Check if the inventory is full
	var inventory_full_branch: BranchDialogueEvent = BranchDialogueEvent.new()
	
	var inventory_full_check: PlayerBoolStatusDialogueCondition = PlayerBoolStatusDialogueCondition.new()
	inventory_full_check.condition_to_check = PlayerBoolStatusDialogueCondition.PlayerCondition.ITEM_FITS_INVENTORY
	inventory_full_check.item = key_item
	inventory_full_branch.condition = inventory_full_check
	
	#3.1 If it is not full, grant the item
	var grant_item_event: GrantItemDialogueEvent = GrantItemDialogueEvent.new()
	grant_item_event.item = key_item
	inventory_full_branch.condition_true_event = grant_item_event
	
	#3.2 If it is full, start the inventory full flow
	var inventory_full_flow: FullInventoryDialogueEvent = FullInventoryDialogueEvent.new()
	inventory_full_flow.item = key_item
	inventory_full_branch.condition_false_event = inventory_full_flow
	
	take_sequence.events.append(inventory_full_branch)
	
	#4. Branch. Check that the player got the item
	var got_item_branch: BranchDialogueEvent = BranchDialogueEvent.new()
	
	var got_item_condition: HasItemDialogueCondition = HasItemDialogueCondition.new()
	got_item_condition.item = key_item
	got_item_branch.condition = got_item_condition
	
	#4.1 If the player has the item, remove the event and save to data
	var delete_sequence: SequenceDialogueEvent = SequenceDialogueEvent.new()
	
	#4.1.1 Remove event
	delete_sequence.events.append(make_remove_sequence())
	
	#4.1.2 Save chest data
	var save_event: SaveMapBoolDialogueEvent = SaveMapBoolDialogueEvent.new()
	save_event.value = true
	save_event.map_key = map_key
	save_event.data_key = data_key
	delete_sequence.events.append(save_event)
	
	got_item_branch.condition_true_event = delete_sequence
	take_sequence.events.append(got_item_branch)
	
	#5. Optional post-take event
	if post_take_event != null:
		take_sequence.events.append(post_take_event)
	
	take_event = take_sequence


func make_map_start_event() -> void:
	#1. Branch. Check that the save data is present
	var check_save_branch: BranchDialogueEvent = BranchDialogueEvent.new()
	var save_condition: MapBoolDataDialogueCondition = MapBoolDataDialogueCondition.new()
	save_condition.map_key = map_key
	save_condition.data_key = data_key
	check_save_branch.condition = save_condition
	
	#1.1 If true, remove the event
	check_save_branch.condition_true_event = make_remove_sequence()
	
	check_save_branch.skip_window = true
	map_start_event = check_save_branch


func make_remove_sequence() -> SequenceDialogueEvent:
	var delete_sequence: SequenceDialogueEvent = SequenceDialogueEvent.new()
	
	#1 Change tile to brick
	var change_to_brick: ChangeTilemapDialogueEvent = ChangeTilemapDialogueEvent.new()
	change_to_brick.target_pos = position
	change_to_brick.tile_key = "brick"
	delete_sequence.events.append(change_to_brick)
	
	#2 Remove the event
	var remove_event: ChangeMapEventsDialogueEvent = ChangeMapEventsDialogueEvent.new()
	remove_event.target_pos = position
	remove_event.operation = ChangeMapEventsDialogueEvent.EventOperation.REMOVE
	delete_sequence.events.append(remove_event)
	
	return delete_sequence
