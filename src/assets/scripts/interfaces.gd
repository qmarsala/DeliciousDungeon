extends Node

const Interactable = "Interactables"
const Damageable = "Damageables"

static func is_interface(node: Node, interface: String):
	return node and node.is_in_group(interface)
