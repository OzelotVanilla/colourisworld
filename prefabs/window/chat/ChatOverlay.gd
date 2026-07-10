class_name ChatOverlay
extends Control
## UI overlay node to show chat and choices
##
## TODO: This class is currently also acted as the holder of dialog runner.
##       Should move the logic about node switching and chat process to somewhere else
##        in the future.


## When all text and choice finishes.
signal finished()


@onready var chat_text_window__ref: ChatTextWindow = $Margin/VBox/ChatTextWindow

@onready var chat_choice_window__ref: ChatChoiceWindow = $Margin/VBox/ChatChoiceWindow


## Current chat that is showing in this [ChatOverlay].
var current_chat: ChatResource:
    set = setCurrentChat

## Current node that is showing now, from active [member current_chat].
var current_node: ChatNodeDialogResource:
    set = setCurrentNode

## Execute the side-effect of dialog.
var dialog_runner := DialogRunner.new()

var game__ref: MainGame


func _ready() -> void: self.__onReady__()


func setCurrentChat(value: ChatResource) -> void:
    current_chat = value
    self.goToNode(value.first_node_id)
    self.applyLanguageOption()

func setCurrentNode(value: ChatNodeDialogResource) -> void:
    current_node = value

    # # Set text window.
    self.chat_text_window__ref.chat_node__ref = value
    self.applyLanguageOption()

    # # Set choices if choice node.
    if value is ChatChoiceDialogResource:
        self.chat_choice_window__ref.choice_dialog__ref = value
    self.chat_choice_window__ref.hide() # Hide first, appear it when text finishes.

    # # Connect signals and set focus.
    if not self.chat_text_window__ref.finished.is_connected(self.on_ChatText_finished):
        self.chat_text_window__ref.finished.connect(
            self.on_ChatText_finished, ConnectFlags.CONNECT_ONE_SHOT
        )
    if value is ChatChoiceDialogResource:
        self.chat_choice_window__ref.choice_selected.connect(
            self.on_ChatChoice_choice_selected, ConnectFlags.CONNECT_ONE_SHOT
        )
    self.chat_text_window__ref.grab_focus()

    # # Run effect if exists.
    if not value.effects.is_empty():
        self.dialog_runner.executeEffect(value.effects, self.game__ref.map__ref.id)

## Change to the specified node (by its ID).
func goToNode(node_id: String) -> void:
    var node_index := self.current_chat.nodes.find_custom(
        func(n: ChatNodeDialogResource): return n.id == node_id
    )
    if node_index < 0:
        printerr("Cannot find node in resource `", self.current_chat.resource_name, "`.")
    self.current_node = self.current_chat.nodes[node_index]

## Apply the language option to the text and choice window.[br][br]
##
## Called when [signal LanguageManager.language_changed],
##  or before the dialog is going to be showed.
func applyLanguageOption() -> void:
    self.chat_text_window__ref.applyLanguageOption()
    if self.current_node is ChatChoiceDialogResource:
        self.chat_choice_window__ref.applyLanguageOption()

func on_focus_entered() -> void:
    self.release_focus()
    self.chat_text_window__ref.grab_focus()

## Called when a chat node that only has text, finishes displaying all text.
func on_ChatText_finished() -> void:
    var node := self.current_node
    # If has a choice at last, need to show it.
    if   node is ChatChoiceDialogResource:
        self.chat_choice_window__ref.appear()
    elif node is ChatTextDialogResource:
        self.on_ChatNode_finished(node.next_node_id)

## Called when a choice node got selection.
func on_ChatChoice_choice_selected(choice_variant: ChatChoiceDialogVariantResource) -> void:
    self.on_ChatNode_finished(choice_variant.next_node_id)

## Called when the node itself is finished.
func on_ChatNode_finished(next_node_id: String) -> void:
    if not next_node_id.is_empty():
        self.goToNode(next_node_id)
    else:
        self.finished.emit()

func __onReady__():
    self.chat_text_window__ref.chat_overlay__ref = self
    language_manager.language_changed.connect(self.applyLanguageOption)
