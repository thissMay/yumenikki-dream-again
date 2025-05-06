class_name PlayerStats
extends Resource

@export var base_speed: float = Player.BASE_SPEED

@export var walk_multi: float = Player.WALK_MULTI
@export var sprint_multi: float = Player.SPRINT_MULTI
@export var sneak_multi: float = Player.SNEAK_MULTI
@export var exhaust_multi: float = Player.EXHAUST_MULTI

@export var stamina_drain: float = Player.STAMINA_DRAIN
@export var stamina_regen: float = Player.STAMINA_REGEN
@export var can_run: bool = Player.CAN_RUN

func _apply(_pl: Player) -> void: 
	_pl.initial_speed = base_speed
	
	_pl.walk_multiplier = self.walk_multi
	_pl.sprint_multiplier = self.sprint_multi
	_pl.sneak_multiplier = self.sneak_multi
	_pl.exhaust_multiplier = self.exhaust_multi
	
	_pl.stamina_drain = self.stamina_drain
	_pl.stamina_regen = self.stamina_regen
	_pl.can_run = self.can_run	
func _unapply(_pl: Player) -> void: 
	_pl.initial_speed = Player.BASE_SPEED
	
	_pl.walk_multiplier = Player.WALK_MULTI
	_pl.sprint_multiplier = Player.SPRINT_MULTI
	_pl.sneak_multiplier = Player.SNEAK_MULTI
	_pl.exhaust_multiplier = Player.EXHAUST_MULTI
	
	_pl.stamina_drain = Player.STAMINA_DRAIN
	_pl.stamina_regen = Player.STAMINA_REGEN
	_pl.can_run = Player.CAN_RUN

func _physics_update(_delta: float, _pl: Player) -> void: pass
