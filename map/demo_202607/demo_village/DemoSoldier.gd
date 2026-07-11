extends InteractableObject


const chat_resource__block_player: ChatResource = preload(
    "res://assets/stories/demo_202607/soilder_blocking_player.tres"
)

const chat_resource__ask_player: ChatResource = preload(
    "res://assets/stories/demo_202607/soilder_asking_player.tres"
)

const chat_resource__let_player_pass: ChatResource = preload(
    "res://assets/stories/demo_202607/soilder_let_player_pass.tres"
)


## The direction soilder will go after player can go to the mountain.
@export var direction_to_dodge: Vector2i


var map__ref: BaseMap


func getDialogContainerFromPlayerData(player: Player) -> DialogContainerResource:
    # TEST: Bad solution for converting to bool.
    var player_has_mission: bool = int(save_manager.save.runtime__maps_state \
        .getState(self.map__ref.id, "player__has_mission"))
    var player_can_pass: bool = int(save_manager.save.runtime__maps_state \
        .getState(self.map__ref.id, "soldier__should_let_pass"))

    if player_can_pass:
        return chat_resource__let_player_pass

    if player_has_mission:
        return chat_resource__ask_player
    else:
        return chat_resource__block_player
