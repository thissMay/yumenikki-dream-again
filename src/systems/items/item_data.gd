class_name ItemData
extends Resource

@export var icon: Texture2D
@export var item_name: String = ""
@export var item_desc: String = ""
@export var item_id: int = 000

func use(_pl: Player = null) -> void: pass

func _update(_delta: float, _pl: Player = null) -> void: pass
func _physics_update(_delta: float, _pl: Player = null) -> void: pass

func get_icon() -> Texture2D: return icon
func get_item_name() -> String: return item_name
func get_item_desc() -> String: return item_desc
func get_item_id() -> int: return item_id
