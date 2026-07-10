class_name GameSave
extends Resource
## State of game progress
##
## This could be load to [SaveManager] as a runtime game state,
##  or saved to disk as a file.[br][br]
##
## [member global_state] and [member map_state] does not have a fixed value type.
## Please check the design specification for details.


## Data that is read-ed and modified in real-time.
@export_group("Runtime Data", "runtime__")

## Real-time data.[br][br]
##
## Global event flag.
@export var runtime__global_state: GameSaveGlobalState

## Real-time data.[br][br]
##
## Map-specified event flag:[br]
## * First key ([String]): [member BaseMap.id].[br]
## * Second key ([String]): event name.
@export var runtime__maps_state: GameSaveMapsState


## Data that is not updated in real-time.
@export_group("Snapshot", "snapshot__")

## Not updated in real-time.[br][br]
##
## Snapshot data about player itself, such as location or inventory.[br][br]
##
## Read real-time player data from [member MainGame.player__ref] instead.
@export var snapshot__player_data: PlayerData


func _init() -> void:
    self.runtime__global_state = GameSaveGlobalState.new()
    self.runtime__maps_state = GameSaveMapsState.new()
    self.snapshot__player_data = PlayerData.new()
