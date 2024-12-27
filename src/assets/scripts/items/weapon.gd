class_name Weapon
extends Node2D

var player: Player

func init(p: Player):
	for a in $Abilities.get_children():
		if a is MagicAttack: #todo: ability contract
			a.init(p)
