extends Node

@onready var _player_select_screen_scene: PackedScene = load("res://Core/Controls/player_select_screen.tscn")

@onready var _all_minigames: Array[Minigame] = get_all_minigames()

var _player_select_screen: PlayerSelectScreen = null
var _current_minigame: Minigame = null
var _current_minigame_scene: Node = null


func _ready() -> void:
	open_player_select_screen()


func _on_player_select_screen_start_pressed() -> void:
	if _player_select_screen != null:
		_player_select_screen.queue_free()
		_player_select_screen = null
		
		# TODO: Open game board instead
		if _all_minigames.size() > 0:
			_current_minigame = _all_minigames[0]
			_current_minigame_scene = _current_minigame.scene.instantiate()
			add_child(_current_minigame_scene)


func get_all_minigames() -> Array[Minigame]:
	var dir = DirAccess.open("res://Core/Minigames")
	
	if not dir:
		return []
	
	var minigames: Array[Minigame] = []
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.get_extension() == "tres":
			var resource = ResourceLoader.load("res://Core/Minigames/" + file_name)
			if resource is Minigame:
				minigames.append(resource)
		file_name = dir.get_next()
	
	return minigames


func open_player_select_screen() -> void:
	if _player_select_screen != null:
		return
	
	_player_select_screen = _player_select_screen_scene.instantiate()
	add_child(_player_select_screen)
	_player_select_screen.pressed_start.connect(_on_player_select_screen_start_pressed)