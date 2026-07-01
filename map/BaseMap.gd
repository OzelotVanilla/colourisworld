@abstract
class_name BaseMap
extends TileMapLayer


## Check if coord could be walked through
@abstract func canWalkThroughAt(coord: Vector2i) -> bool

func cannotWalkThroughAt(coord: Vector2i):
    return not self.canWalkThroughAt(coord)

## Check if there is a object that gives out a dialog resource.
## If so, return the resource. Else, null.
@abstract func tryGetDialogAt(coord: Vector2i) -> DialogResource
