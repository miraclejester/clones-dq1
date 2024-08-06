extends Node

@export var spell_effect_material: ShaderMaterial
@export var ambient_hurt_material: ShaderMaterial

var step_wait: float = 0.03
var shake_step: int = 2

var shake_callables: Array[Callable] = [
	shake_node_x.bind(-shake_step),
	shake_node_x.bind(shake_step),
	shake_node_y.bind(-shake_step),
	shake_node_y.bind(shake_step),
]

var spell_effect_callables: Array[Callable] = [
	set_spell_effect_enabled.bind(true),
	set_spell_effect_enabled.bind(false),
	set_spell_effect_enabled.bind(true),
	set_spell_effect_enabled.bind(false),
]


func play_effect(callables: Array[Callable], nodes: Array[Node]) -> void:
	for i in range(4):
		await cycle(nodes, callables)


func player_hurt_shake() -> void:
	await play_effect(shake_callables, get_tree().get_nodes_in_group("player_hurt_shake"))


func spell_effect() -> void:
	await play_effect(spell_effect_callables, get_tree().get_nodes_in_group("spell_effect"))


func set_ambient_hurt_enabled(enabled: bool) -> void:
	for node in get_tree().get_nodes_in_group("ambient_hurt"):
		(node as CanvasItem).material = ambient_hurt_material if enabled else null


func cycle(nodes: Array[Node], callables: Array[Callable]) -> void:
	for callable in callables:
		for node in nodes:
			callable.call(node)
		await get_tree().create_timer(step_wait).timeout


func shake_node_x(node: Node, amount: int) -> void:
	if node is Node2D:
		(node as Node2D).position.x += amount
		return
	if node is CanvasLayer:
		(node as CanvasLayer).offset.x += amount


func shake_node_y(node: Node, amount: int) -> void:
	if node is Node2D:
		(node as Node2D).position.y += amount
		return
	if node is CanvasLayer:
		(node as CanvasLayer).offset.y += amount


func set_spell_effect_enabled(node: Node, enabled: bool) -> void:
	if enabled:
		(node as CanvasItem).material = spell_effect_material
	else:
		(node as CanvasItem).material = null
