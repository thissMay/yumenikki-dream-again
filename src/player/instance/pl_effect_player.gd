extends Node2D

@export var animation_player: AnimationPlayer
var on_player_effect: EventListener
var flash_tween: Tween

func _ready() -> void:
	on_player_effect = EventListener.new(["PLAYER_EQUIP", "PLAYER_DEEQUIP"], false, self)
	on_player_effect.do_on_notify("PLAYER_EQUIP", func():
		if (GameManager.EventManager.get_event_param("PLAYER_EQUIP")[0] == load("res://src/player/madotsuki/effects/_none/_none.tres")
			or GameManager.EventManager.get_event_param("PLAYER_EQUIP_SKIP_ANIM")[0] == true): return
		
		(PLInstance.get_pl().sprite_renderer.get_node("shader") as ColorRect).color.a = 1
		if flash_tween != null: flash_tween.kill()
		flash_tween = self.create_tween()
		flash_tween.tween_property((PLInstance.get_pl().sprite_renderer.get_node("shader") as ColorRect), "color:a", 0, .5)
			
		self.global_position = PLInstance.get_pl().global_position
		animation_player.play("effect_equip"))
	
	on_player_effect.do_on_notify("PLAYER_DEEQUIP", func(): 
		(PLInstance.get_pl().sprite_renderer.get_node("shader") as ColorRect).color.a = 1
		if flash_tween != null: flash_tween.kill()
		flash_tween = self.create_tween()
		flash_tween.tween_property((PLInstance.get_pl().sprite_renderer.get_node("shader") as ColorRect), "color:a", 0, .5)
		
		self.global_position = PLInstance.get_pl().global_position
		animation_player.play("effect_deequip"))
