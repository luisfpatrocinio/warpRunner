extends Node

var soundsDict : Dictionary = {
	"warp": preload("res://assets/Magic Cast.wav")
}

var musicsDict: Dictionary = {
	"game": preload("res://assets/on_the_run.ogg")
}

@onready var sfxPlayer : AudioStreamPlayer = get_node("SFXPlayer");
@onready var bgmPlayer : AudioStreamPlayer = get_node("BGMPlayer");

var levelRef = null;

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
