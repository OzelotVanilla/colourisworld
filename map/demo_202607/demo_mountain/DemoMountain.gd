extends BaseMap


@onready var teleport_tiles_container__ref: Node2D = $TeleportTiles

@onready var layer__map_border: TileMapLayer = $MapBorder

@onready var demo_relic_01__ref: InteractableObject = $Object/General/DemoRelic_01

@onready var demo_relic_02__ref: InteractableObject = $Object/General/DemoRelic_02

@onready var demo_relic_03__ref: InteractableObject = $Object/General/DemoRelic_03

@onready var demo_relic_04__ref: InteractableObject = $Object/DayOnly/DemoRelic_04

@onready var demo_moon_grass__ref: InteractableObject = $Object/NightOnly/DemoMoonGrass


func _ready() -> void: self.__onReady__()


func canWalkThroughAt(coord: Vector2i) -> bool:
    var demo_relic_01__coord: Vector2i = self.demo_relic_01__ref.position / 64
    var demo_relic_02__coord: Vector2i = self.demo_relic_02__ref.position / 64
    var demo_relic_03__coord: Vector2i = self.demo_relic_03__ref.position / 64
    var demo_relic_04__coord: Vector2i = self.demo_relic_04__ref.position / 64
    var demo_moon_grass__coord: Vector2i = self.demo_moon_grass__ref.position / 64

    var is_not_object := coord != demo_relic_01__coord \
        and coord != demo_relic_02__coord \
        and coord != demo_relic_03__coord \
        and coord != demo_relic_04__coord \
        and coord != demo_moon_grass__coord

    var is_passable_tile: bool = true
    var border_tile_data := self.layer__map_border.get_cell_tile_data(coord)
    if border_tile_data != null:
        is_passable_tile = is_passable_tile and border_tile_data.get_custom_data("walkable")

    return is_not_object and is_passable_tile

func tryGetDialogAt(coord: Vector2i) -> DialogResource:
    return null

func __onReady__():
    for teletile in self.teleport_tiles_container__ref.get_children():
        if teletile is TeleportTile:
            teletile.player_entered.connect(
                func():
                    var map: BaseMap = load(teletile.target_map__scene_path).instantiate()
                    self.request_teleport.emit(map, teletile.target_coord)
            )

func update():
    pass
