@abstract
class_name ChatNodeDialogResource
extends DialogResource
## Abstract class for all chat node, including text-only, choice, etc.


## ID of the node.
@export var id: String = ""

## Side-effect to run when chat jumped to this node,
##  following this pattern [code]<command> <scope> <key> <value>[/code],
##  connected by [code];[/code].[br][br]
##
## See outer readme file for detailed specification.
@export_multiline var effects: String
