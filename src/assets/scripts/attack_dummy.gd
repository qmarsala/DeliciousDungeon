extends Sprite2D

@onready var status_effects_component: StatusEffectComponent = $StatusEffectsComponent
	
func receive_damage(damage):
	SignalBusService.DamageReceived.emit(damage, global_position, false)
