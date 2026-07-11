class_name Player
extends Node2D
## Main character controlled by game player
##
## Move one tile per move.


signal require_dialog_showing(dialog_container: DialogContainerResource)


@onready var pivot_of_checking_area__ref: Node2D = $PivotOfCheckingArea

@onready var check_area__ref: Area2D = $PivotOfCheckingArea/CheckArea


var currect_cell_position: Vector2i

var is_move_cooling_down: bool = false

var facing_direction: Vector2i = Vector2i.UP:
    set(value):
        facing_direction = value
        pivot_of_checking_area__ref.rotation = Vector2.UP.angle_to(value)

var game__ref: MainGame

var status_dict: Dictionary = {}


func _ready() -> void: self.__onReady__()
func _process(delta: float) -> void: self.__onProcess__(delta)


func __onReady__():
    pass

func __onProcess__(delta: float) -> void:
    if self.is_move_cooling_down or self.game__ref.is_showing_dialog:
        return

    var direction := self.getInputDirection()
    if direction == Vector2i.ZERO:
        return

    self.facing_direction = direction # regardless of whether successfully moved.
    self.tryStep(direction)

func tryInteractWithFacingObject():
    for area in self.check_area__ref.get_overlapping_areas():
        var parent := area.get_parent()
        if parent is InteractableObject:
            var dialog := (parent as InteractableObject) \
                .getDialogContainerFromPlayerData(self)
            if dialog != null:
                self.require_dialog_showing.emit(dialog)

func getInputDirection() -> Vector2i:
    var x := int(Input.is_action_pressed("move_right")) \
           - int(Input.is_action_pressed("move_left"))
    var y := int(Input.is_action_pressed("move_down")) \
           - int(Input.is_action_pressed("move_up"))

    if x != 0:
        return Vector2i(x, 0)
    if y != 0:
        return Vector2i(0, y)

    return Vector2i.ZERO

func tryStep(direction: Vector2i) -> void:
    var next_cell := self.currect_cell_position + direction
    self.is_move_cooling_down = true
    if self.game__ref.map__ref.canWalkThroughAt(next_cell):
        self.moveToCell(next_cell)
    await get_tree().create_timer(0.3).timeout
    self.is_move_cooling_down = false

func moveToCell(next_cell_position: Vector2i) -> void:
    self.currect_cell_position = next_cell_position
    self.position = next_cell_position * 64
