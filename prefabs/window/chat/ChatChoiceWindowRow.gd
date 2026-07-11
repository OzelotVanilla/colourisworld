@tool
class_name ChatChoiceWindowRow
extends HBoxContainer
## UI node of chat's choice window's option row


@onready var right_arrow__ref: TextureRect = $RightArrow

@onready var label__ref: Label = $Label


## Text to be showed in option row of [ChatOverlay].
## Do not directly set value in inspector, since export was test purpose only.
@export_multiline var text: String = "":
    set(value):
        if text != value:
            text = value
            if not self.is_node_ready():
                await self.ready
            self.label__ref.text = value

var choice_window__ref: ChatChoiceWindow

var index_in_choice_window: int

var choice_option__ref: ChatChoiceOptionResource:
    set(value):
        if choice_option__ref != value:
            choice_option__ref = value
            self.applyLanguageOption()

## Currently showed choice variant.
var choice_variant__ref: ChatChoiceDialogVariantResource


func _ready() -> void: self.__onReady__()


func on_focus_entered():
    self.showArrow()
    self.choice_window__ref.current_selected_index = self.index_in_choice_window

func on_focus_exited():
    self.hideArrow()

func __onReady__():
    self.hideArrow()

func showArrow():
    self.right_arrow__ref.self_modulate.a = 1

func hideArrow():
    self.right_arrow__ref.self_modulate.a = 0

func applyLanguageOption():
    match language_manager.current_language:
        LanguageManager.LanguageOption.ja:
            self.text = self.choice_option__ref.tr__ja.text
            self.choice_variant__ref = self.choice_option__ref.tr__ja
        LanguageManager.LanguageOption.en:
            self.text = self.choice_option__ref.tr__en.text
            self.choice_variant__ref = self.choice_option__ref.tr__en
        LanguageManager.LanguageOption.zh:
            self.text = self.choice_option__ref.tr__zh.text
            self.choice_variant__ref = self.choice_option__ref.tr__zh
        LanguageManager.LanguageOption.ja_original:
            self.text = self.choice_option__ref.tr__ja_original.text
            self.choice_variant__ref = self.choice_option__ref.tr__ja_original
