class_name TeleportTile
extends Area2D


## Emit when player entered
signal player_entered()


## TODO Should not do like this in the future.
@export_file_path("*.tscn") var target_map__scene_path: String

@export var target_coord: Vector2i = Vector2i.ZERO


func on_area_entered(area: Node2D) -> void:
    if area is Player:
        self.on_Player_entered(area)

func on_Player_entered(player: Player):
    self.player_entered.emit()
