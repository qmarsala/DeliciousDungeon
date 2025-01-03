class_name Hurtbox
extends Area2D

# testing an idea of having a hurbox. 
# this would be what is configured with the attack to deliver.
# when encountering a hitbox.

# one tricky thing is that for some attacks it would destroy itself after the check
# other attacks, it would depend

var attack: Attack

func init(attack_data: Attack):
	attack = attack_data

func apply_attack():
	var targets = get_overlapping_areas()
	for t in targets:
		if t is Hitbox:
			t.apply_attack(attack)
