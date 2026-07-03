class_name ChatChoiceWindow
extends PanelContainer
## Choice window of [ChatOverlay]


const choice_row_instance := preload("res://prefabs/window/chat/ChatChoiceWindowRow.tscn")


## Emitted when a signal is selected.
signal choice_selected(choice_variant: ChatChoiceDialogVariantResource)


@onready var option_row_container__ref: VBoxContainer = $Margin/OptionRowContainer


## Will trigger clear and adding of option inside the [ChatChoiceDialogResource].
var choice_dialog__ref: ChatChoiceDialogResource:
    set(value):
        if choice_dialog__ref != value:
            choice_dialog__ref = value
            if not self.is_node_ready():
                await self.ready
            self.clear()
            for choice in value.choices:
                self.addOption(choice)
            self.addNeighbourSettingAndIndexToOptions()

var current_selected_index: int = 0:
    set(value):
        # Do not check if writing same value here.
        # Since the focus of row need to be given.
        current_selected_index = value

        # If got `-1` here, and nothing to select, nothing happend.
        var length = self.option_row_container__ref.get_child_count()
        if length <= 0:
            return # No element to grab focus.

        # If got `-1` here, need to round-clamp.
        value = ((value % length) + length) % length
        current_selected_index = value
        var node: ChatChoiceWindowRow = self.option_row_container__ref.get_child(value)
        node.grab_focus()

func _unhandled_input(event: InputEvent) -> void: self.__onUnhandledInput__(event)


func addOption(choice_option: ChatChoiceOptionResource):
    var row: ChatChoiceWindowRow = ChatChoiceWindow.choice_row_instance.instantiate()
    self.option_row_container__ref.add_child(row)
    row.name = choice_option.comment
    row.choice_window__ref = self
    row.choice_option__ref = choice_option
    row.applyLanguageOption()

func addNeighbourSettingAndIndexToOptions():
    var options: Array[ChatChoiceWindowRow] = []
    for c in self.option_row_container__ref.get_children(): if c is ChatChoiceWindowRow:
        options.append(c)
    for i in range(options.size() - 1):
        options[i].index_in_choice_window = i
        options[i].focus_neighbor_bottom = options[i + 1].get_path()
        options[i + 1].focus_neighbor_top = options[i].get_path()
    var last_index := options.size() - 1
    options[last_index].focus_neighbor_bottom = options[0].get_path()
    options[last_index].index_in_choice_window = last_index
    options[0].focus_neighbor_top = options[last_index].get_path()

## Clear all item and reset current selected index.
func clear():
    for row in self.option_row_container__ref.get_children(): if row is ChatChoiceWindowRow:
        self.option_row_container__ref.remove_child(row)
    self.current_selected_index = -1 # Set to none as the row container is empty now.

## Set selected index to 0, make choice window to appear and grab focus.
func appear():
    self.show()
    self.current_selected_index = 0 # Will grab focus.
    self.applyLanguageOption()

func applyLanguageOption():
    if not self.is_visible_in_tree():
        return
    for row in self.option_row_container__ref.get_children(): if row is ChatChoiceWindowRow:
        row.applyLanguageOption()

func __onUnhandledInput__(event: InputEvent) -> void:
    if not self.is_visible_in_tree():
        return

    # TODO: Not working. Alt sln is add index in `ChatChoiceWindowRow`.
    #if   event.is_action_pressed("ui_up"):
        #self.current_selected_index -= 1
    #elif event.is_action_pressed("ui_down"):
        #self.current_selected_index += 1

    if event.is_action_pressed("ui_accept"):
        var choice_row := self.option_row_container__ref.get_child(
            self.current_selected_index
        )
        self.choice_selected.emit(choice_row.choice_variant__ref)
        get_viewport().set_input_as_handled()
