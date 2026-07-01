extends InteractableObject


const chat_resource__block_player: ChatResource = preload(
    "res://assets/stories/demo_village/soilder_blocking_player.tres"
)

const chat_resource__ask_player: ChatResource = preload(
    "res://assets/stories/demo_village/soilder_asking_player.tres"
)


func getDialogContainerFromPlayerData(player: Player) -> DialogContainerResource:
    if player.status_dict.get("has_mission", false):
        return chat_resource__ask_player
    else:
        return chat_resource__block_player
