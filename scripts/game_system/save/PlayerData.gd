class_name PlayerData
extends Resource
## Save/State about player (coord, inventory, etc.)


## The [member BaseMap.id] of the map when the player saves the game
@export var location__map_id: String

## The coord of player in the map ([member location__map_id]).
@export var location__coord_in_map: Vector2i
