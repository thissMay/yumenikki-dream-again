class_name PLInventory
extends FSM

var invert_cutscene_listener: EventListener
var player_equip_listener: EventListener

@export var display: Control

@export var white_petal: Control
@export var pink_petal: Control

@export var inventory_toggle: GUIPanelButton
@export var white_petal_button: GUIPanelButton
@export var pink_petal_button: GUIPanelButton

@export var item_container: GridContainer

@export var deequip_prompt: AbstractButton
@export var effect_indicator: SpriteSheetFormatter

var inventory_open: bool
var petal_tween: Tween

var hovered_button: GUIPanelButton
static var favourite_effect: PlayerEffect
@export var favourite_icon: Sprite2D

static var data: PLInventoryData = preload("res://src/player/inventory/data/default_debug_data.tres")
signal inv_updatedxx

func _setup() -> void:
		
	white_petal.visible = false
	pink_petal.visible = false
	
	super()
	
	invert_cutscene_listener = EventListener.new(["SPECIAL_INVERT_CUTSCENE_BEGIN", "SPECIAL_INVERT_CUTSCENE_END"], false, self)
	player_equip_listener = EventListener.new(["PLAYER_EQUIP", "PLAYER_DEEQUIP"], false, self)
	
	player_equip_listener.do_on_notify("PLAYER_DEEQUIP", func(): 
		deequip_prompt.set_active(false)
		effect_indicator.progress = 1
		)
	player_equip_listener.do_on_notify("PLAYER_EQUIP", func(): 
		deequip_prompt.set_active(true)
		effect_indicator.progress = 0
		)
		
	deequip_prompt.pressed.connect(func():
		(PLInstance.get_pl() as Player_YN).deequip_effect()
		inventory_toggle._on_press()
		)
	
	inventory_toggle.pressed.connect(func(): 
		inventory_open = !inventory_open
		if inventory_open: GameManager.EventManager.invoke_event("SPECIAL_INVERT_CUTSCENE_BEGIN")
		else: GameManager.EventManager.invoke_event("SPECIAL_INVERT_CUTSCENE_END")
		)

	white_petal_button.pressed.connect(func(): _change_to_state("white_petal"))
	pink_petal_button.pressed.connect(func(): _change_to_state("pink_petal"))
	
	instantiate_buttons(data)

func instantiate_buttons(_inv_data: PLInventoryData) -> void:
	if _inv_data == null: return
	for effect in _inv_data.effects:
		append_item(effect)

func append_item(_item: PlayerEffect) -> void: 
	if _item == null: return
	
	var button = GUIPanelButton.new()
	button.unique_data = _item
	button.min_size.y = 20
	button.set_text(_item.get_eff_name())
	
	button.set_icon(_item.icon)
	button.name = (_item.get_eff_name())
	
	button.hover_exited.connect(func(): hovered_button = null)
	button.hover_entered.connect(func(): hovered_button = button)
	
	button.pressed.connect(func():
		if button.unique_data: (PLInstance.get_pl() as Player_YN).equip(button.unique_data)
		inventory_toggle._on_press())
	
	item_container.add_child(button)

func _input(event: InputEvent) -> void:
	if event is InputEventKey && Global.input:
		if (Global.input["key_pressed"] == KEY_F &&
			Global.input["pressed_once"]):
			if hovered_button != null: 
				favourite_effect = hovered_button.unique_data
				favourite_icon.global_position = hovered_button.global_position
				
