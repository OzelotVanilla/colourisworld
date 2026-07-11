extends InteractableObject


## Chat to show to the player when they interact with.
@export var chat_dialog: ChatResource


func getDialogContainerFromPlayerData(player: Player) -> DialogContainerResource:
    return self.chat_dialog
