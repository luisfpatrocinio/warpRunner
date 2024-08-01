extends Node

## Dicionário contendo os sons do jogo
@onready var soundsDict : Dictionary = {
	"warp": preload("res://assets/Magic Cast.wav") # Som do teleporte
}

## Dicionário contendo as músicas do jogo
@onready var musicsDict: Dictionary = {
	"title": preload("res://assets/Futuristic_junk.ogg"), 	# Música da tela de título
	"game": preload("res://assets/on_the_run.ogg") 			# Música do jogo
}

## Dicionário contendo as cenas do jogo
@onready var scenesDict: Dictionary = {
	"title": preload("res://scenes/title_screen.tscn"), # Cena da tela de título
	"game": preload("res://scenes/game.tscn") 			# Cena do jogo
}

## Referência ao player de efeitos sonoros
@onready var sfxPlayer : AudioStreamPlayer = get_node("SFXPlayer")
## Referência ao player de músicas de fundo
@onready var bgmPlayer : AudioStreamPlayer = get_node("BGMPlayer")
## Cena de transição usada ao trocar de cenas
@export var transitionScene: PackedScene = preload("res://Scenes/transition_fade_in.tscn")

## Variável para armazenar a pontuação do jogador
var playerScore: int = 0
## Referência ao nível atual
var levelRef = null

## Indica se há um novo recorde
var newHighScore: bool = false
## Armazena o recorde de pontuação
var highScore: int = 0
## User save data
var userdata := {
	'highScore' : 0
}

## Ao iniciar o jogo, carrega o highscore salvo em arquivo e atualiza a variável global.
func _ready():
	#load_game();
	highScore = userdata["highScore"]

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
	

## Função para tocar efeitos sonoros
## sfxKey: chave do efeito sonoro a ser tocado
func playSFX(sfxKey: String) -> void:
	var _audioToPlay = soundsDict.get(sfxKey);
	if _audioToPlay != null:
		sfxPlayer.stream = _audioToPlay;
		sfxPlayer.play();

## Função para tocar a música de fundo
## bgmKey: chave da música a ser tocada
func playBGM(bgmKey: String) -> void:
	var _audioToPlay = musicsDict.get(bgmKey) 	# Obtém a música a partir do dicionário
	# Checa se a música existe, ou se já não estiver sendo tocada.
	if _audioToPlay != null and bgmPlayer.stream != _audioToPlay:
		bgmPlayer.stream = _audioToPlay 		# Define a música no player
		bgmPlayer.play() 						# Toca a música

## Função para transitar para outra cena
## destinyScene: chave da cena de destino
func transitionToScene(destinyScene: String) -> void:
	var _scene = Global.scenesDict.get(destinyScene) 	# Obtém a cena a partir do dicionário
	if _scene == null: return;
	var _trans = transitionScene.instantiate() 			# Instancia a cena de transição
	_trans.destinyScene = _scene 						# Define a cena de destino na transição
	add_child(_trans) 									# Adiciona a transição como filha do nó atual

## Função para resetar os valores das variáveis globais
func resetValues():
	print("Valores das variáveis resetados."); 	# Log para depuração
	newHighScore = false; 	# Reseta o status de novo recorde
	playerScore = 0; 		# Reseta a pontuação do jogador
