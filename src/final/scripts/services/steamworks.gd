class_name SteamworksService
extends Node

var app_id = 480 # example game for dev
var steam_enabled = false
var steam_initialized = false

func _ready() -> void:
	if not steam_enabled: return
	initialize_steam()

func _process(_delta: float) -> void:
	Steam.run_callbacks()

func initialize_steam() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx(true, app_id)
	print("Steam init: %s " % initialize_response)
	
	if initialize_response['status'] > Steam.STEAM_API_INIT_RESULT_OK:
		print("Failed to initialize Steam, shutting down: %s" % initialize_response)
		get_tree().quit()
	else:
		steam_initialized = true
