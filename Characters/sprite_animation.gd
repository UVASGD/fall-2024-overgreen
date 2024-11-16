extends Node

class_name SpriteAnimation

signal set_anim(state: String, interrupt: bool)

var anim: AnimatedSprite2D
var anim_playing: bool = false

func _init(animation: AnimatedSprite2D) -> void:
	anim = animation
	anim.connect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished"))
	self.connect("lock_movement", Callable(self, "_on_set_anim_signal"))

func update_direction(direction: Vector2) -> void:
	if direction.x > 0:
		anim.flip_h = false
	elif direction.x < 0:
		anim.flip_h = true

func set_state(state: String) -> void:
	anim.play(state)
	anim_playing = true

func tick(direction: Vector2) -> void:
	update_direction(direction)
	if anim_playing:
		return
	if direction.x != 0 or direction.y != 0:
		anim.play("walk")
	else:
		anim.play("idle")

func _on_animated_sprite_2d_animation_finished() -> void:
	anim_playing = false

func _on_set_anim_signal(state: String, interrupt: bool) -> void:
	if not anim_playing or anim_playing and interrupt:
		set_state(state)
