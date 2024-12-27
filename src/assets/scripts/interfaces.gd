extends Node

# since godot doesn't have interfaces
# want to explore using groups to communicate what you can do
# perhaps the 'class' keyword can be used for this? and define empty methods
# to assist with type hints?

# this way we can start doing things like dependency injection and more abstract
# components that deal with 'movables' 'damageables' etc.

const Interactable = "Interactables"
const Damageable = "Damageables"
const HasStatusEffects = "HasStatusEffects"

static func is_interface(node: Node, interface: String):
	return node and node.is_in_group(interface)
