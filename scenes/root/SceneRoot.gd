@tool
class_name SceneRoot
extends Control
## The root node of the game
##
## Method start with "pop"/"push"/"change" will switch to an existed scene.[br][br]
##
## Note: Derived from DeepMaze project.


const scene__dict: Dictionary[StringName, PackedScene] = {

}

## Preloads all video. Convert them to Ogg Theora format first.
const video__dict: Dictionary[StringName, VideoStreamTheora] = {
}


@onready var scene_stack__ref: Control = $SceneStack


func _ready() -> void: self.__onReady__()


## Push a new scene into the stack.
## The scene pushed before will be alived.
func pushScene(scene_name: StringName, ...postInit__args):
    # If there is existing scene:
    if self.scene_stack__ref.get_child_count() > 0:
        var old_scene: BaseGameScene = self.scene_stack__ref.get_child(-1)
        old_scene.hibernate()

    var scene: BaseGameScene = self.scene__dict[scene_name].instantiate()
    self.scene_stack__ref.add_child(scene)
    scene.postInit(postInit__args)

## Pop a scene from stack.
## If no enough scene to be pop-ed, an error generates.
func popScene():
    if self.scene_stack__ref.get_child_count() <= 1:
        printerr(str(
            "Cannot pop anymore because the scene stack is empty,",
            " or only contains one last scene."
        ))
        return

    var poped_scene: BaseGameScene = self.scene_stack__ref.get_child(-1)
    self.scene_stack__ref.remove_child(poped_scene)
    poped_scene.queue_free()

    var previous_scene: BaseGameScene = self.scene_stack__ref.get_child(-1)
    previous_scene.aestivate()

## Change the active scene to a new scene.
func changeScene(scene_name: StringName, ...postInit__args):
    var scene: BaseGameScene = self.scene__dict[scene_name].instantiate()
    scene.postInit(postInit__args)

    var poped_scene: BaseGameScene = self.scene_stack__ref.get_child(-1)
    self.scene_stack__ref.remove_child(poped_scene)
    poped_scene.queue_free.call_deferred()

    # If there is existing scene:
    if self.scene_stack__ref.get_child_count() > 0:
        var old_scene: BaseGameScene = self.scene_stack__ref.get_child(-1)
        old_scene.hibernate()

    self.scene_stack__ref.add_child(scene)

func __onReady__():
    #self.pushScene("press_any_key_title")
    pass

func quitGame():
    self.get_tree().quit()
