class_name SignalBus
extends Node

#idea: 'signals as topics' for components that need to communicate
# such as a dungeon room telling the game to change scenes
#todo: what data do we need if any to pass here?
signal SceneChange

#probably want to know who got damaged by what?
signal DamageReceived(damage, position)
