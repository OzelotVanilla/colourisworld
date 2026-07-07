extends BaseMap


@onready var layer__groud: TileMapLayer = $Groud

@onready var layer__people: Node2D = $People

@onready var layer__buildings: TileMapLayer = $Buildings

@onready var layer__map_border: TileMapLayer = $MapBorder

@onready var demo_soldier_01__ref: Node2D = $People/DemoSoldier_01

@onready var demo_soldier_02__ref: Node2D = $People/DemoSoldier_02

@onready var demo_mission_guy__ref: InteractableObject = $People/DemoMissionGuy


var had_talked_to_mission_giver: bool = false


func canWalkThroughAt(coord: Vector2i) -> bool:
    # TEST: The whole code in this function is just for testing.
    coord += Vector2i(-1, -1) # TODO: for offset, not a good solution
    var soldier_01__coord: Vector2i = self.demo_soldier_01__ref.position / 64
    var soldier_02__coord: Vector2i = self.demo_soldier_02__ref.position / 64
    var mission_guy__coord: Vector2i = self.demo_mission_guy__ref.position / 64

    var is_not_character := coord != soldier_01__coord \
        and coord != soldier_02__coord \
        and coord != mission_guy__coord

    var is_passable_tile: bool = true
    var border_tile_data := self.layer__map_border.get_cell_tile_data(coord)
    if border_tile_data != null:
        is_passable_tile = is_passable_tile and border_tile_data.get_custom_data("walkable")
    var building_tile_data := self.layer__buildings.get_cell_tile_data(coord)
    if building_tile_data != null:
        is_passable_tile = is_passable_tile and building_tile_data.get_custom_data("walkable")

    return is_not_character and is_passable_tile

func tryGetDialogAt(coord: Vector2i) -> DialogResource:
    return null
