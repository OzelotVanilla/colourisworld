extends InteractableObject


const chat_resource__give_mission: ChatResource = preload(
    "res://assets/stories/demo_202607/mission_guy_give_mission.tres"
)


func getDialogContainerFromPlayerData(player: Player) -> DialogContainerResource:
    return chat_resource__give_mission
