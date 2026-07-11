@abstract
class_name BaseMap
extends TileMapLayer


@warning_ignore("unused_signal") # Will be used in child class.
signal request_teleport(map: BaseMap, coord: Vector2i)


## The ID of the base map.[br][br]
##
## Used in [GameSave] when saving player's location ([member PlayerData.location__map_id]).
@export var id: String

## Check if coord could be walked through.
@abstract func canWalkThroughAt(coord: Vector2i) -> bool

## Check if coord could not be walked through.
func cannotWalkThroughAt(coord: Vector2i):
    return not self.canWalkThroughAt(coord)

## Check if there is a object that gives out a dialog resource.
## If so, return the resource. Else, null.
@abstract func tryGetDialogAt(coord: Vector2i) -> DialogResource

func convertMapCoordToLocal(map_coord: Vector2i) -> Vector2:
    return map_coord * 64

## Update map entities according to updated global/map/player status.
@abstract func update() -> void
