extends BaseMap


@onready var layer__groud: TileMapLayer = $Groud

@onready var layer__people: Node2D = $People

@onready var layer__buildings: TileMapLayer = $Buildings

@onready var layer__map_border: TileMapLayer = $MapBorder

@onready var demo_soldier_01__ref: Node2D = $People/DemoSoldier_01

@onready var demo_soldier_02__ref: Node2D = $People/DemoSoldier_02

@onready var demo_mission_guy__ref: InteractableObject = $People/DemoMissionGuy


var had_talked_to_mission_giver: bool = false

var demo_soldier_01_dodged_position: Vector2i

var demo_soldier_02_dodged_position: Vector2i


func _ready() -> void: self.__onReady__()


func canWalkThroughAt(coord: Vector2i) -> bool:
    # TEST: The whole code in this function is just for testing.
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

func __onReady__():
    # Init map state.
    save_manager.save.runtime__maps_state.setState(
        self.id, "player__has_mission", false
    )
    save_manager.save.runtime__maps_state.setState(
        self.id, "soldier__should_let_pass", false
    )

    self.demo_soldier_01_dodged_position = \
        self.demo_soldier_01__ref.position \
        + self.convertMapCoordToLocal(self.demo_soldier_01__ref.direction_to_dodge)
    self.demo_soldier_02_dodged_position = \
        self.demo_soldier_02__ref.position \
        + self.convertMapCoordToLocal(self.demo_soldier_02__ref.direction_to_dodge)
    self.demo_soldier_01__ref.map__ref = self
    self.demo_soldier_02__ref.map__ref = self

## TEST
func update():
    # TEST: Bad solution for converting to bool.
    var soldier_should_let_player_pass: bool = int(save_manager.save.runtime__maps_state \
        .getState(self.id, "soldier__should_let_pass"))

    if soldier_should_let_player_pass:
        self.demo_soldier_01__ref.position = self.demo_soldier_01_dodged_position
        self.demo_soldier_02__ref.position = self.demo_soldier_02_dodged_position

    self.demo_mission_guy__ref.refreshSprite()
