class_name PLInventory
extends FSM

var player_equip_listener: EventListener
var effect_collect: EventListener
var scene_change_listener: EventListener

@export var display: Control

@export var white_petal: Control
@export var pink_petal: Control

@export var inventory_toggle: AbstractButton
@export var white_petal_button: AbstractButton
@export var pink_petal_button: AbstractButton

@export var item_container: GridContainer

@export var deequip_prompt: AbstractButton
@export var effect_indicator: SpriteSheetFormatter

var petal_tween: Tween

var hovered_button: GUIPanelButton
static var favourite_effect: PLEffect
@export var favourite_icon: Sprite2D

signal inventory_data_changed(_new_data: PLInventoryData)
signal inventory_data_updated(_appended_effect: PLEffect)
signal inventory_opened
signal inventory_closed

var data: PLInventoryData = DEFAULT_DATA
const DEFAULT_DATA: PLInventoryData = preload("res://src/player/inventory/data/empty.tres")


func _setup() -> void:
	white_petal.visible = false
	pink_petal.visible = false
	
	super()
	
	# --- listeners..
	scene_change_listener = EventListener.new(["SCENE_CHANGE_REQUEST"], false, self)
	player_equip_listener = EventListener.new(["PLAYER_EQUIP", "PLAYER_DEEQUIP"], false, self)
	effect_collect = EventListener.new(["PLAYER_EFFECT_FOUND"], false, self)
	
	scene_change_listener.do_on_notify("SCENE_CHANGE_REQUEST", func(): inventory_closed.emit())
	player_equip_listener.do_on_notify("PLAYER_DEEQUIP", func(): 
		deequip_prompt.set_active(false)
		effect_indicator.progress = 1
		)
	player_equip_listener.do_on_notify("PLAYER_EQUIP", func(): 
		if GameManager.EventManager.get_event_param("PLAYER_EQUIP")[0] == Player.Instance.get_pl().DEFAULT_EFFECT: 
			return
		deequip_prompt.set_active(true)
		effect_indicator.progress = 0
		)
	effect_collect.do_on_notify("PLAYER_EFFECT_FOUND", func(): 
		append_item(GameManager.EventManager.get_event_param("PLAYER_EFFECT_FOUND")[0]))
		
	# --- 
	print(inventory_toggle)
	deequip_prompt.pressed.connect(func():
		(Player.Instance.get_pl() as Player_YN).deequip_effect()
		inventory_toggle._on_press()
		)	
	inventory_toggle.toggled.connect(func(_toggled: bool): 
		if _toggled: inventory_opened.emit()
		else: inventory_closed.emit()
		)

	white_petal_button.pressed.connect(func(): _change_to_state("white_petal"))
	pink_petal_button.pressed.connect(func(): _change_to_state("pink_petal"))
	
	inventory_opened.connect(func(): GameManager.EventManager.invoke_event("SPECIAL_INVERT_CUTSCENE_BEGIN"))
	inventory_closed.connect(func(): GameManager.EventManager.invoke_event("SPECIAL_INVERT_CUTSCENE_END"))
	
	instantiate_buttons(data)

func instantiate_buttons(_inv_data: PLInventoryData) -> void:
	if _inv_data == null: return
	for effect in _inv_data.effects:
		append_item(effect)
func delete_buttons() -> void: 
	for i in item_container.get_children():
		i.queue_free()

func append_item(_item: PLEffect) -> void: 
	if _item == null or _item in data.effects: return
	data.effects.append(_item)
	
	var button = GUIPanelButton.new()
	button.unique_data = _item
	button.min_size.y = 20
	button.set_text(_item.get_eff_name())
	
	button.set_icon(_item.icon)
	button.name = (_item.get_eff_name())
	
	button.hover_exited.connect(func(): hovered_button = null)
	button.hover_entered.connect(func(): hovered_button = button)
	
	button.pressed.connect(func():
		if button.unique_data: (Player.Instance.get_pl() as Player_YN).equip(button.unique_data)
		inventory_toggle.untoggle())
	
	item_container.add_child(button)
	inventory_data_updated.emit(_item)
	
	Player.Data.update_effects_data(data.effects)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT:
			if hovered_button != null: 
				favourite_effect = hovered_button.unique_data
				favourite_icon.global_position = hovered_button.global_position
func set_inventory_data(_data: PLInventoryData) -> void:
	data = _data
	
