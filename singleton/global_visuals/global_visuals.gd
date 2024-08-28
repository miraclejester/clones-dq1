extends Node

@export var spell_effect_material: ShaderMaterial
@export var ambient_hurt_material: ShaderMaterial
@export var ambient_death_material: ShaderMaterial
@export var ambient_barrier_material: ShaderMaterial
@export var darken_material: ShaderMaterial
@export var darken_hurt_material: ShaderMaterial
@export var rainbow_drop_material: ShaderMaterial
@export var darken_local_material: ShaderMaterial


var shake_step: int = 2
var ambient_hurt_enabled: bool = false


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

var death_effect_callables: Array[Callable] = [
	set_death_effect_enabled.bind(true),
	set_death_effect_enabled.bind(false),
	set_death_effect_enabled.bind(true),
	set_death_effect_enabled.bind(false),
]

var map_hurt_callables: Array[Callable] = [
	set_death_effect_enabled.bind(true),
	set_death_effect_enabled.bind(false)
]

var map_barrier_callables: Array[Callable] = [
	set_barrier_effect_enabled.bind(true),
	set_barrier_effect_enabled.bind(false)
]

var darken_callables: Array[Callable] = [
	set_darken.bind(1),
	set_darken.bind(2),
	set_darken.bind(3),
	set_darken.bind(4)
]

var lighten_callables: Array[Callable] = [
	set_darken.bind(3),
	set_darken.bind(2),
	set_darken.bind(1),
	set_darken.bind(0)
]

var rainbow_drop_callables: Array[Callable] = [
	set_rainbow_drop.bind(1),
	set_rainbow_drop.bind(2),
	set_rainbow_drop.bind(3),
	set_rainbow_drop.bind(4),
	set_rainbow_drop.bind(5),
	set_rainbow_drop.bind(6),
	set_rainbow_drop.bind(7),
	set_rainbow_drop.bind(8),
	set_rainbow_drop.bind(9),
	set_rainbow_drop.bind(10),
	set_rainbow_drop.bind(11),
	set_rainbow_drop.bind(12)
]


func play_effect(callables: Array[Callable], nodes: Array[Node], step_wait: float, num_cycles: int = 4) -> void:
	for i in range(num_cycles):
		await cycle(nodes, callables, step_wait)


func player_hurt_shake() -> void:
	await play_effect(shake_callables, get_tree().get_nodes_in_group("player_hurt_shake"), 0.03)


func spell_effect() -> void:
	await play_effect(spell_effect_callables, get_tree().get_nodes_in_group("spell_effect"), 0.03)


func enemy_spell_effect() -> void:
	await play_effect(spell_effect_callables, get_tree().get_nodes_in_group("enemy_spell_effect"), 0.03)


func death_effect() -> void:
	await play_effect(death_effect_callables, get_tree().get_nodes_in_group("player_death_effect"), 0.03)


func map_hurt_effect() -> void:
	await play_effect(map_hurt_callables, get_tree().get_nodes_in_group("player_death_effect"), 0.1, 1)


func map_barrier_effect() -> void:
	await play_effect(map_barrier_callables, get_tree().get_nodes_in_group("player_death_effect"), 0.1, 1)


func fade_out() -> void:
	await play_effect(darken_callables, get_tree().get_nodes_in_group("darken"), 0.1, 1)


func fade_in() -> void:
	await play_effect(lighten_callables, get_tree().get_nodes_in_group("darken"), 0.1, 1)


func play_rainbow_drop() -> void:
	var nodes: Array[Node] = []
	nodes.assign(get_tree().get_nodes_in_group("rainbow_drop"))
	await play_effect(rainbow_drop_callables, nodes, 0.05, 4)
	for node in nodes:
		reset_material(node)
	


func dark_out() -> void:
	for node in get_tree().get_nodes_in_group("darken"):
		set_darken(node, 4)


func lighten_up() -> void:
	for node in get_tree().get_nodes_in_group("darken"):
		set_darken(node, 0)


func set_ambient_hurt_enabled(enabled: bool) -> void:
	ambient_hurt_enabled = enabled
	for node in get_tree().get_nodes_in_group("ambient_hurt"):
		(node as CanvasItem).material = ambient_hurt_material if enabled else null


func set_death_effect_enabled(node: Node, enabled: bool) -> void:
	if enabled:
		(node as CanvasItem).material = ambient_death_material
	elif ambient_hurt_enabled:
		(node as CanvasItem).material = ambient_hurt_material
	else:
		(node as CanvasItem).material = null


func set_barrier_effect_enabled(node: Node, enabled: bool) -> void:
	if enabled:
		(node as CanvasItem).material = ambient_barrier_material
	elif ambient_hurt_enabled:
		(node as CanvasItem).material = ambient_barrier_material
	else:
		(node as CanvasItem).material = null


func set_darken(node: Node, index: int) -> void:
	var mat: ShaderMaterial = darken_material
	if ambient_hurt_enabled:
		mat = darken_hurt_material
	(node as CanvasItem).material = mat
	mat.set_shader_parameter("color_index", index)


func darken_local() -> void:
	for node in get_tree().get_nodes_in_group("darken_local"):
		(node as CanvasItem).material = darken_local_material


func set_rainbow_drop(node: Node, index: int) -> void:
	(node as CanvasItem).material = rainbow_drop_material
	rainbow_drop_material.set_shader_parameter("color_index", index)


func reset_material(node: Node) -> void:
	(node as CanvasItem).material = null


func determine_ui_colors(hp: int, max_hp: int) -> void:
	if hp <= floor(max_hp / 5.0):
		set_ambient_hurt_enabled(true)
	else:
		set_ambient_hurt_enabled(false)


func cycle(nodes: Array[Node], callables: Array[Callable], step_wait: float) -> void:
	for callable in callables:
		for node in nodes:
			if is_instance_valid(node):
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
