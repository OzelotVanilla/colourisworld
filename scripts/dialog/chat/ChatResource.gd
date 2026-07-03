@tool
class_name ChatResource
extends DialogContainerResource
## Saves the flowchart of chat


## ID of [ChatResource].[br][br]
##
## Could be the place and character information,
##  recording what episode is being talked.[br][br]
##
## Being used as the context of the PO ID strings.
@export var id: String = "":
    set(value):
        id = value
        self.resource_name = str("chat_resource__", value)

## Nodes of the chat.[br][br]
@export var nodes: Array[ChatNodeDialogResource] = []

## First node's ID of the chat.
@export var first_node_id: String = ""
