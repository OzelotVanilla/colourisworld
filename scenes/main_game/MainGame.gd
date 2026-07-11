class_name MainGame
extends BaseGameScene


@onready var player__ref: Player = $Player

@onready var map_container__ref: Node2D = $MapContainer

@onready var camera__ref: Camera2D = $Player/Camera2D

@onready var chat_overlay__ref: ChatOverlay = $CanvasLayer/ChatOverlay


## Managed by [method changeToMap].[br][br]
##
## Do not set this value outside [MainGame].
var map__ref: BaseMap

var is_showing_dialog: bool = false


func _ready() -> void: self.__onReady__()
func _unhandled_input(event: InputEvent) -> void: self.__onUnhandledInput__(event)


func changeToMap(map: BaseMap, coord: Vector2i = Vector2i.ZERO):
    for c in self.map_container__ref.get_children():
        self.map_container__ref.remove_child.call_deferred(c)
        c.queue_free()
    self.map_container__ref.add_child.call_deferred(map)
    self.map__ref = map
    self.player__ref.moveToCell.call_deferred(coord)

    map.request_teleport.connect(self.changeToMap)
    map.update.call_deferred()

func on_Player_require_dialog_showing(dialog_container: DialogContainerResource):
    if dialog_container is ChatResource:
        self.chat_overlay__ref.current_chat = dialog_container
        self.chat_overlay__ref.show()
        self.is_showing_dialog = true

func on_ChatOverlay_finished():
    self.chat_overlay__ref.release_focus()
    self.chat_overlay__ref.hide()
    self.is_showing_dialog = false
    self.map__ref.update()

func __onReady__():
    self.chat_overlay__ref.hide()
    self.chat_overlay__ref.game__ref = self
    self.player__ref.game__ref = self

    # TEST
    if not save_manager.isLocalSaveFileExist():
        save_manager.createSave()
    save_manager.loadFromLocalFile()
    var map: BaseMap = (
        load("res://map/demo_202607/demo_village/DemoVillage.tscn") as PackedScene
    ).instantiate()
    self.changeToMap(map, Vector2i(5, -8))

func __onUnhandledInput__(event: InputEvent):
    if event.is_action_pressed("ui_accept") and not self.is_showing_dialog:
        self.player__ref.tryInteractWithFacingObject()
