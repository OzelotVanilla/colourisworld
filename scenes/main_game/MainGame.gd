class_name MainGame
extends BaseGameScene


@onready var player__ref: Player = $Player

@onready var map_container__ref: Node2D = $MapContainer

@onready var camera__ref: Camera2D = $Player/Camera2D

@onready var chat_overlay__ref: ChatOverlay = $CanvasLayer/ChatOverlay


var map__ref: BaseMap:
    get():
        if not self.is_node_ready() or self.map_container__ref.get_child_count() < 1:
            return null

        return self.map_container__ref.get_child(0)

var is_showing_dialog: bool = false


func _ready() -> void: self.__onReady__()
func _unhandled_input(event: InputEvent) -> void: self.__onUnhandledInput__(event)


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

    # TEST
    if not save_manager.isLocalSaveFileExist():
        save_manager.createSave()
    save_manager.loadFromLocalFile()
    var map = (
        load("res://map/demo_202607/demo_village/DemoVillage.tscn") as PackedScene
    ).instantiate()
    self.map_container__ref.add_child(map)
    self.player__ref.map__ref = map
    self.player__ref.game__ref = self
    self.player__ref.moveToCell(Vector2i(5, -8))

func __onUnhandledInput__(event: InputEvent):
    if event.is_action_pressed("ui_accept") and not self.is_showing_dialog:
        self.player__ref.tryInteractWithFacingObject()
