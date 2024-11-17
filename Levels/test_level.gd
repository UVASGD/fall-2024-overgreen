extends Node2D

@onready var hooks = $Hooks
@onready var hook_scene = preload("res://Characters/hook.tscn")

var hookStarts = [
	Vector2(800,0),
	Vector2(150, 0),
	Vector2(400, 0),
	Vector2(210, 160),
	Vector2(359, 499),
	Vector2(952, 725),
	Vector2(1677, 375),
	Vector2(3844, 245),
	Vector2(5190, -394),
	Vector2(2868, 692)
]
	
func _create_hooks():
	for hook in hookStarts:
		var hoo = hook_scene.instantiate()
		hoo.startPos = hook
		hooks.add_child(hoo)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		_create_hooks()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var closest = Vector2(-1000,0)
	for hoo in hookStarts:
		if get_node("Player").position.distance_to(hoo) < get_node("Player").position.distance_to(closest):
			closest = hoo
	get_node("Player").nearestHook = closest
