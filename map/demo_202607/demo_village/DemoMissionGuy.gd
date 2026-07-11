extends InteractableObject


const chat_resource__give_mission: ChatResource = preload(
    "res://assets/stories/demo_202607/mission_guy_give_mission.tres"
)

const chat_resource__check_mission: ChatResource = preload(
    "res://assets/stories/demo_202607/mission_guy_check_mission.tres"
)


@onready var quest_giver_sprite__ref: Sprite2D = $Sprite/QuestGiver

@onready var quest_checker_sprite__ref: Sprite2D = $Sprite/QuestChecker


var player_has_grass: bool:
    get():
        var value = save_manager.save.runtime__global_state.getState("found_moon_grass")
        if value == null:
            return false
        else:
            return int(value)


func getDialogContainerFromPlayerData(player: Player) -> DialogContainerResource:
    if self.player_has_grass:
        return chat_resource__check_mission
    else:
        return chat_resource__give_mission

func refreshSprite():
    if self.player_has_grass:
        self.quest_checker_sprite__ref.show()
        self.quest_giver_sprite__ref.hide()
    else:
        self.quest_giver_sprite__ref.show()
        self.quest_checker_sprite__ref.hide()
