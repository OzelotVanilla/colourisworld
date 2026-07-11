extends InteractableObject


const chat_resource__got: ChatResource = preload(
    "res://assets/stories/demo_202607/found_moon_grass.tres"
)


func getDialogContainerFromPlayerData(player: Player) -> DialogContainerResource:
    return chat_resource__got
