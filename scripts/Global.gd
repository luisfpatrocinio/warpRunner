extends Node

var soundsDict : Dictionary = {
	"warp": preload("res://assets/Magic Cast.wav")
}

var musicsDict: Dictionary = {
	"title": preload("res://assets/Futuristic_junk.ogg"),
	"game": preload("res://assets/on_the_run.ogg")
}

var scenesDict: Dictionary = {
	"title": preload("res://scenes/title_screen.tscn"),
	"game": preload("res://scenes/game.tscn")
}

@onready var sfxPlayer : AudioStreamPlayer = get_node("SFXPlayer");
@onready var bgmPlayer : AudioStreamPlayer = get_node("BGMPlayer");
@export var transitionScene: PackedScene = preload("res://Scenes/transition_fade_in.tscn");

var playerScore: int = 0;
var levelRef = null;

var newHighScore: bool = false;
var highScore: int = 0;

## User save data
var userdata := {
	'highScore' : 0
}

## Saves the game
func save_game():
	var save_file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	save_file.store_string(JSON.stringify(userdata))

## Loads the game
func load_game():
	var save_file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	if save_file == null:
		print('No files saved.')
		return
		
	var content = save_file.get_as_text() 
	var _json_text = JSON.parse_string(content) as Dictionary
	userdata = _json_text
	print('File loaded.')

func _ready():
	load_game();
	highScore = userdata["highScore"]

func playSFX(sfxKey: String) -> void:
	var _audioToPlay = soundsDict.get(sfxKey);
	if _audioToPlay != null:
		sfxPlayer.stream = _audioToPlay;
		sfxPlayer.play();

func playBGM(bgmKey: String) -> void:
	var _audioToPlay = musicsDict.get(bgmKey);
	if _audioToPlay != null and bgmPlayer.stream != _audioToPlay:
		bgmPlayer.stream = _audioToPlay;
		bgmPlayer.play();

func transitionToScene(destinyScene: String) -> void:
	var _scene = Global.scenesDict.get(destinyScene);
	var _trans = transitionScene.instantiate();
	_trans.destinyScene = _scene;
	add_child(_trans);

func resetValues():
	print("Valores das variáveis resetados.");
	levelRef = null;
	newHighScore = false;
	playerScore = 0;
	
