extends Sprite2D

@onready var status_effects_component: StatusEffectComponent = $StatusEffectsComponent

func _ready() -> void:
	add_to_group(Interfaces.Damageable)
	status_effects_component.init(self)
	
func receive_damage(damage):
	SignalBusService.DamageReceived.emit(damage, global_position, false)
